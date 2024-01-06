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
    
    // 데이터 소스에 필요한 데이터, 예를 들어, 프로미스 목록 등
    var shouldFocusPromiseId: Double?
//    var onLoadingHandlerForGettingPromises: ((Bool) -> Void)?
    var promisesDidChange: (([Components.Schemas.OutputPromiseListItem?]) -> Void)?
    var promises: [Components.Schemas.OutputPromiseListItem?] = [] {
        didSet {
            promisesDidChange?(promises)
        }
    }
    
    
    init(currentVC: MainVC? = nil) {
        self.currentVC = currentVC
        super.init()
        APIService.shared.delegate = self
    }
    
    
    func getPromiseList() async {
        let result: Result<[Components.Schemas.OutputPromiseListItem] ,NetworkError> = await APIService.shared.fetch(.GET, "/promise/list")
        
        switch result {
        case .success(let promises):
            self.promises = promises
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
            shouldFocusPromiseId = createdPromise.id
            await getPromiseList()
        }
    }
    
    func onLoading(path: String?, isLoading: Bool) {
        switch(path) {
        case "/promise/list":
            if(isLoading) {
                promises = [nil]
            }
        default:
            break
        }
    }
}
