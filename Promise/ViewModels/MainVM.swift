//
//  MainVM.swift
//  Promise
//
//  Created by dylan on 2023/08/06.
//

import Foundation
import UIKit

class MainVM: NSObject {
    var currentVC: MainVC?
    
    var currentFocusedPromise: Components.Schemas.OutputPromiseListItem?
    
    var promiseStatusContainer: CommonFloatingContainerVC?
    var promiseStatusContent: CommonFloatingContentVC?
    
    var shouldFocusPromiseId: String?
    var promisesDidChange: (([Components.Schemas.OutputPromiseListItem?]?) -> Void)?
    var promises: [Components.Schemas.OutputPromiseListItem?]? {
        didSet {
            promisesDidChange?(promises)
        }
    }
    
    init(currentVC: MainVC? = nil) {
        self.currentVC = currentVC
        super.init()
        APIService.shared.delegate = self
    }
    
    func sortedPromises(
        with willBeSortedPromises: [Components.Schemas.OutputPromiseListItem?],
        by order: SortPromiseListEnum = .dateTimeQuickOrder
    ) -> [Components.Schemas.OutputPromiseListItem?] {
        
        // MARK: nil, [nil], [promise] 경우 early return
        guard willBeSortedPromises.count > 1 else {
            return willBeSortedPromises
        }
        
        switch order {
        case .dateTimeQuickOrder:
            
            return willBeSortedPromises.sorted {
                guard let next = $0, let before = $1 else { return false }
                return next.promisedAt < before.promisedAt
            }
            
        case .dateTimeLateOrder:
            
            return willBeSortedPromises.sorted {
                guard let next = $0, let before = $1 else { return false }
                return next.promisedAt > before.promisedAt
            }
            
        default:
            
            return willBeSortedPromises
        }
    }
    
    
    func getPromiseList() async {
        let result: Result<[Components.Schemas.OutputPromiseListItem] ,NetworkError> = await APIService.shared.fetch(.GET, "/promises", ["status": "available"])
        
        switch result {
        case .success(let promises):
            self.promises = sortedPromises(with: promises)
        case .failure(let errorType):
            switch errorType {
            case .badRequest:
                // TODO: 약속 리스트 에러 핸들링
                break
            default:
                // Other Error(Network, badUrl ...)
                break
            }
        }
    }
    
    func getDepartureLoaction(
        id: String,
        onSuccess: @escaping ((Components.Schemas.OutputStartLocation) -> Void),
        onFailure: @escaping ((BadRequestError?) -> Void)
    ) {
        
        Task {
            let result: Result<Components.Schemas.OutputStartLocation ,NetworkError> = await APIService.shared.fetch(
                .GET,
                "/promises/\(id)/start-location"
            )
            
            switch result {
            case .success(let departureLoaction):
                onSuccess(departureLoaction)
            case .failure(let errorType):
                switch errorType {
                case .badRequest(let error):
                    onFailure(error)
                    break
                default:
                    // Other Error(Network, badUrl ...)
                    onFailure(nil)
                    break
                }
            }
        }
        
    }
    
    func editDepartureLoaction(with: Components.Schemas.InputUpdateUserStartLocation, onSuccess: @escaping (() -> Void)) async {
        guard let id = currentFocusedPromise?.pid, !id.isEmpty else { return }
        
        let result: Result<EmptyResponse ,NetworkError> = await APIService.shared.fetch(
            .POST,
            "/promises/\(id)/start-location",
            nil,
            with
        )
        
        switch result {
        case .success:
            onSuccess()
        case .failure(let errorType):
            switch errorType {
            case .badRequest:
                
                break
            default:
                // Other Error(Network, badUrl ...)
                break
            }
        }
    }
    
    func leavePromise() {
        guard let promise = currentFocusedPromise, !promise.pid.isEmpty else { return }
        let id = promise.pid
        let isOwner = String(Int(promise.host.id)) == UserService.shared.getUser()?.userId
        
        if isOwner {
            return
        }
        
        Task {
            
            let result: Result<EmptyResponse, NetworkError> = await APIService.shared.fetch(.DELETE, "/promises/\(id)/attend")
            
            switch result {
            case .success:
                
                // 현재 포커스된 promise의 index
                if let promises, let index = promises.firstIndex(where: { $0?.pid == id }) {
                    
                    if index > 0 {
                        
                        // 앞에 promise 객체가 있는지 확인
                        self.shouldFocusPromiseId = promises[index - 1]?.pid
                        
                    } else if index + 1 < promises.count {
                        
                        // 뒤에 promise 객체가 있는지 확인
                        self.shouldFocusPromiseId = promises[index + 1]?.pid
                        
                    }
                    
                    // 앞이나 뒤에 promise가 없는 경우, shouldFocusPromiseId는 변경하지 않음
                }
                
                await getPromiseList()
                await ToastView(message: L10n.PromiseStatusWithAllAttendeesView.More.LeavePromise.success).showToast()
                
            case .failure(let errorType):
                switch errorType {
                case .badRequest(let error):
                    
                    await currentVC?.showPopUp(
                        title: L10n.PromiseStatusWithAllAttendeesView.More.LeavePromise.failure,
                        message: error.errorResponse?.message ?? ""
                    )
                    
                default:
                    // Other Error(Network, badUrl ...)
                    break
                }
            }
            
        }
    
    }
    
    
    func navigateAccountScreen() {
        DispatchQueue.main.async {[weak self] in
            let accountVC = AccountVC()
            self?.currentVC?.navigationController?.pushViewController(accountVC, animated: true)
        }
    }
    
    
    func navigateNotificationScreen() {
        DispatchQueue.main.async {[weak self] in
            let notificationVC = NotificationVC()
            self?.currentVC?.navigationController?.pushViewController(notificationVC, animated: true)
        }
    }
    
    func navigateCreatePromiseScreen() {
        DispatchQueue.main.async {[weak self] in
            let createPromiseVC = CreatePromiseVC()
            createPromiseVC.delegate = self
            self?.currentVC?.navigationController?.pushViewController(createPromiseVC, animated: true)
        }
    }
}

extension MainVM: CreatePromiseDelegate, APIServiceDelegate {
    func onDidCreatePromise(createdPromise: Components.Schemas.OutputCreatePromise) {
        
        Task {
            shouldFocusPromiseId = createdPromise.pid
            await getPromiseList()
        }
    }
    
    func onLoading(path: String?, isLoading: Bool) {
        switch(path) {
        case "/promises":
            if(isLoading) {
                promises = [nil]
            }
        default:
            break
        }
    }
}

extension MainVM: InvitationPopUpDelegate {
    func onSuccessAttendPromise(promise: Components.Schemas.OutputPromiseListItem) {
        Task {
            await getPromiseList()
            await currentVC?.focusPromiseById(id: promise.pid)
            await ToastView(message: L10n.InvitationPopUp.Toast.successAttendPromise).showToast()
        }
    }
    
    func onFailureAttendPromise(targetPromise: Components.Schemas.OutputPromiseListItem, error: BadRequestError) {
        DispatchQueue.main.async { [weak self] in
            self?.currentVC?.focusPromiseById(id: targetPromise.pid)
            
            guard let errorMessage = error.errorResponse?.message, !errorMessage.isEmpty else {
                self?.currentVC?.showPopUp(
                    title: L10n.InvitationPopUp.IsFailedAttendPromise.title,
                    message: L10n.InvitationPopUp.IsFailedAttendPromise.description
                )
                
                return
            }
            
            self?.currentVC?.showPopUp(
                title: L10n.InvitationPopUp.IsFailedAttendPromise.title,
                message: errorMessage
            )
        }
        
    }
    
    func onLoadingAttendPromise() {
        // TODO: 추후 로딩 UI가 있으면 좋을 것 같음.
    }
}

extension MainVM: SortPromiseListViewDelegate {
    func onSelected(order: SortPromiseListEnum) {
        guard let promises, promises.count > 1 else { return }
        let sortedPromises = sortedPromises(with: promises, by: order)
        self.promises = sortedPromises
        currentVC?.focusPromiseById(id: sortedPromises[0]?.pid)
    }
}
