//
//  CreatePromiseVM.swift
//  Promise
//
//  Created by dylan on 2023/08/28.
//

import Foundation
import UIKit

class CreatePromiseVM: NSObject {
    var currentVC: UIViewController?
    
    var title = "" {
        didSet {
            updateForm(keyPath: \.title, value: title)
        }
    }
    
    var dateDidChange: ((SelectionDate) -> Void)?
    var date: SelectionDate? = nil {
        didSet {
            guard let date else { return }
            dateDidChange?(date)
            updateForm(keyPath: \.date, value: date)
        }
    }
    
    var themesLoading = false
    var themesDidChange: (([SelectableTheme]) -> Void)?
    var themes: [SelectableTheme] = [] {
        didSet {
            themesDidChange?(themes)
            updateForm(keyPath: \.themes, value: themes)
        }
    }
    
    var placeTypeDidChange: ((Components.Schemas.InputCreatePromise.destinationTypePayload) -> Void)?
    var placeType = Components.Schemas.InputCreatePromise.destinationTypePayload.STATIC {
        didSet {
            placeTypeDidChange?(placeType)
            updateForm(keyPath: \.placeType, value: placeType)
        }
    }
    
    var placeDidChange: ((Components.Schemas.InputCreatePromise.destinationPayload) -> Void)?
    var place = Components.Schemas.InputCreatePromise.destinationPayload(value1: .init(city: "서울특별시", district: "관악구", address: "관악로 14길 109", latitude: 37.4749, longitude: 126.9571)) {
        didSet {
            placeDidChange?(place)
            updateForm(keyPath: \.place, value: place)
        }
    }
    
    var shareLocationStartTypeDidChange: ((Components.Schemas.InputCreatePromise.locationShareStartTypePayload) -> Void)?
    var shareLocationStartType = Components.Schemas.InputCreatePromise.locationShareStartTypePayload.DISTANCE {
        didSet {
            shareLocationStartTypeDidChange?(shareLocationStartType)
            updateForm(keyPath: \.shareLocationStartType, value: shareLocationStartType)
        }
    }
    
    let shareLocationStartBasedOnDistanceInfo = ShareLocationStartBasedOnDistanceInfo()
    let shareLocationStartBasedOnTimeInfo = ShareLocationStartBasedOnTimeInfo()
    
    lazy var shareLocationStart = shareLocationStartBasedOnDistanceInfo.initialItem {
        didSet {
            switch(shareLocationStartType) {
            case .DISTANCE:
                if let originItem = shareLocationStartBasedOnDistanceInfo.getOriginItem(at: shareLocationStart.itemIndex) {
                    updateForm(keyPath: \.shareLocationStart, value: originItem)
                }
            case .TIME:
                if let originItem = shareLocationStartBasedOnTimeInfo.getOriginItem(at: shareLocationStart.itemIndex) {
                    updateForm(keyPath: \.shareLocationStart, value: originItem)
                }
            }
        }
    }
    
    let shareLocationEndInfo = ShareLocationEndInfo()
    lazy var shareLocationEnd = shareLocationEndInfo.initialItem {
        didSet {
            if let originItem = shareLocationEndInfo.getOriginItem(at: shareLocationEnd.itemIndex) {
                updateForm(keyPath: \.shareLocationEnd, value: originItem)
            }
        }
    }
    
    lazy var form = PromiseForm(
        title: title,
        date: date,
        themes: [],
        placeType: placeType,
        place: place,
        shareLocationStartType: shareLocationStartType,
        shareLocationStart: shareLocationStartBasedOnDistanceInfo.getOriginItem(at: shareLocationStart.itemIndex)!,
        shareLocationEnd: shareLocationEndInfo.getOriginItem(at: shareLocationEnd.itemIndex)!
    ) {
        didSet {
            validateForm(form)
        }
    }
    
    init(currentVC: UIViewController? = nil) {
        self.currentVC = currentVC
    }
    
    private func updateForm<T>(keyPath: WritableKeyPath<PromiseForm, T>, value: T) {
        var newForm = self.form
        newForm[keyPath: keyPath] = value
        self.form = newForm
    }
    
    var assignOnVaildateForm: ((Bool) -> Void)?
    private func validateForm(_ form: PromiseForm) {
        guard !form.title.isEmpty else {
            assignOnVaildateForm?(false)
            return
        }
        
        guard let _ = form.date else {
            assignOnVaildateForm?(false)
            return
        }
        
        let isExistSelectedThemes = !themes.filter{ $0.isSelected }.isEmpty
        guard isExistSelectedThemes else {
            assignOnVaildateForm?(false)
            return
        }
        
        if form.placeType == .STATIC,
           let _ = form.place?.value1.city,
           let _ = form.place?.value1.district,
           let _ = form.place?.value1.address,
           let _ = form.place?.value1.latitude,
           let _ = form.place?.value1.longitude
        {
            assignOnVaildateForm?(true)
            return
        }
        
        assignOnVaildateForm?(true)
    }
    
    func onChangedTitle(_ textField: UITextField) {
        self.title = textField.text ?? ""
    }
    
    func onChangedDate(_ date: SelectionDate) {
        self.date = date
    }
    
    func onChangeThemes(index: Int) {
        self.themes[index].isSelected = !self.themes[index].isSelected
    }
    
    func onChangedPlaceType(_ type: Components.Schemas.InputCreatePromise.destinationTypePayload) {
        self.placeType = type
    }
    
    func onChangedPlace(_ place: Components.Schemas.InputCreatePromise.destinationPayload) {
        self.place = place
    }
    
    func onChangedShareLocationStartType(_ type: Components.Schemas.InputCreatePromise.locationShareStartTypePayload) {
        self.shareLocationStartType = type
    }
    
    func onChangedShareLocationStart(shareLocationStart: SelectionItem) {
        self.shareLocationStart = shareLocationStart
    }
    
    func onChangedShareLocationEnd(shareLocationEnd: SelectionItem) {
        self.shareLocationEnd = shareLocationEnd
    }
    
    func submit(_ completion: @escaping ((Components.Schemas.OutputCreatePromise?) -> Void)) {
        let submitForm = Components.Schemas.InputCreatePromise(
            title: form.title,
            themeIds: themes.filter{ $0.isSelected }.map{ $0.id },
            promisedAt: form.date!.timeIntervalInSeconds,
            destinationType: form.placeType,
            destination: form.placeType == .STATIC ? form.place : nil,
            locationShareStartType: form.shareLocationStartType,
            locationShareStartValue: form.shareLocationStart,
            locationShareEndType: Components.Schemas.InputCreatePromise.locationShareEndTypePayload.TIME,
            locationShareEndValue: form.shareLocationEnd
        )
        
        Task {
            let result: Result<Components.Schemas.OutputCreatePromise, NetworkError> = await APIService.shared.fetch(.POST, "/promises", nil, submitForm)
            
            switch result {
            case .success(let createdPromise):
                completion(createdPromise)
            case .failure(let errorType):
                switch errorType {
                case .badRequest:
                    // TODO: 약속 생성 에러 핸들링
                    break
                default:
                    // Other Error(Network, badUrl ...)
                    break
                }
            }
        }
    }
    
    func getTodayString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
    func getSupportedTheme() async {
        themesLoading = true
        
        let result: Result<[Components.Schemas.ThemeEntity] ,NetworkError> = await APIService.shared.fetch(.GET, "/promises/themes")
        
        switch result {
        case .success(let themes):
            self.themes = themes.map { themeEntity in
                return SelectableTheme(id: themeEntity.id, theme: themeEntity.theme, isSelected: false)
            }
        case .failure(let errorType):
            switch errorType {
            case .badRequest:
                // TODO: 테마 에러 핸들링
                break
            default:
                // Other Error(Network, badUrl ...)
                break
            }
        }
        
        themesLoading = false
    }
}
