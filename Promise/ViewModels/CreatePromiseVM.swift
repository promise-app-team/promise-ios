//
//  CreatePromiseVM.swift
//  Promise
//
//  Created by dylan on 2023/08/28.
//

import Foundation
import UIKit

class CreatePromiseVM: NSObject {
    var currentVC: CreatePromiseVC?
    
    var capturedEditingPromiseTitle: String? = nil
    var capturedEditingPromiseDate: SelectionDate? = nil
    var capturedEditingPromiseThemes: [SelectableTheme]? = nil
    var capturedEditingPromisePlaceType: Components
        .Schemas
        .InputUpdatePromiseDTO
        .destinationTypePayload? = nil
    var capturedEditingPromisePlace: Components
        .Schemas
        .InputUpdatePromiseDTO
        .destinationPayload? = nil
    var capturedEditingPromiseMiddlePlace: Components
        .Schemas
        .InputUpdatePromiseDTO
        .destinationPayload? = nil
    var capturedEditingPromiseShareLocationStartType: Components
        .Schemas
        .InputUpdatePromiseDTO
        .locationShareStartTypePayload? = nil
    var capturedEditingPromiseShareLocationStartValue: Double? = nil
    var capturedEditingPromiseShareLocationEndValue: Double? = nil
    
    var dynamicDestinationState: DynamicDestinationState? = nil
    
    var editingPromise: Components.Schemas.PromiseDTO? = nil {
        didSet {
            guard let editingPromise else { return }
            
            let title = editingPromise.title
            self.title = title
            self.capturedEditingPromiseTitle = title
            
            let date = SelectionDate(originDate: editingPromise.promisedAt)
            self.date = date
            self.capturedEditingPromiseDate = date
            
            // MARK: 테마는 CreatePromiseVC/lazyConfigureAfterInitializeSubviews에서 세팅
            
            switch editingPromise.destinationType {
            case.STATIC:
                
                self.placeType = .STATIC
                self.capturedEditingPromisePlaceType = .STATIC
                
                // TODO: 약속 수정시 확인
                let destination = editingPromise.destination?.value1
                let place = Components
                    .Schemas
                    .InputUpdatePromiseDTO
                    .destinationPayload(value1: .init(
                        city: destination?.city ?? "",
                        district: destination?.district ?? "",
                        address: destination?.address ?? "",
                        latitude: destination?.latitude ?? 0,
                        longitude: destination?.longitude ?? 0)
                    )
                
                self.place = place
                self.capturedEditingPromisePlace = place
                
            case .DYNAMIC:
                self.placeType = .DYNAMIC
                self.capturedEditingPromisePlaceType = .DYNAMIC
                
                let helper = DynamicDestinationHelper()
                let state = helper.getConfigurableState(promise: editingPromise)
                self.dynamicDestinationState = state
                
                switch state {
                case .notConfigurable, .configurable:
                    break
                case .configured, .newlyConfigurable:
                    let destination = editingPromise.destination?.value1
                    let middlePlace = Components
                        .Schemas
                        .InputUpdatePromiseDTO
                        .destinationPayload(value1: .init(
                            city: destination?.city ?? "",
                            district: destination?.district ?? "",
                            address: destination?.address ?? "",
                            latitude: destination?.latitude ?? 0,
                            longitude: destination?.longitude ?? 0)
                        )
                    
                    self.middlePlace = middlePlace
                    self.capturedEditingPromiseMiddlePlace = middlePlace
                    
                }
            }
            
            // MARK: 타입별 위치 공유 시작 시간
            switch editingPromise.locationShareStartType {
            case .DISTANCE:
                self.shareLocationStartType = .DISTANCE
                self.capturedEditingPromiseShareLocationStartType = .DISTANCE
                
                let originItmes = shareLocationStartBasedOnDistanceInfo.originItmes
                let value = String(Int(editingPromise.locationShareStartValue))
                
                let itemIndex = originItmes.firstIndex { $0 == value }
                guard let itemIndex else { break }
                
                let items = shareLocationStartBasedOnDistanceInfo.items
                let item = items[itemIndex]
                
                let selectionItem = SelectionItem(
                    itemText: item,
                    itemIndex: itemIndex
                )
                self.shareLocationStartValue = selectionItem
                self.capturedEditingPromiseShareLocationStartValue = editingPromise.locationShareStartValue
                
            case .TIME:
                self.shareLocationStartType = .TIME
                self.capturedEditingPromiseShareLocationStartType = .TIME
                
                let originItmes = shareLocationStartBasedOnTimeInfo.originItmes
                let value = String(Int(editingPromise.locationShareStartValue))

                let itemIndex = originItmes.firstIndex { $0 == value }
                guard let itemIndex else { break }
                
                let items = shareLocationStartBasedOnTimeInfo.items
                let item = items[itemIndex]
                
                let selectionItem = SelectionItem(
                    itemText: item,
                    itemIndex: itemIndex
                )
                self.shareLocationStartValue = selectionItem
                self.capturedEditingPromiseShareLocationStartValue = editingPromise.locationShareStartValue
            }
            
            
            // MARK: 위치 공유 종료 시간
            let originItmes = shareLocationEndInfo.originItmes
            let value = String(Int(editingPromise.locationShareEndValue))

            let itemIndex = originItmes.firstIndex { $0 == value }
            guard let itemIndex else { return }
            
            let items = shareLocationEndInfo.items
            let item = items[itemIndex]
            
            let selectionItem = SelectionItem(
                itemText: item,
                itemIndex: itemIndex
            )
            self.shareLocationEndValue = selectionItem
            self.capturedEditingPromiseShareLocationEndValue = editingPromise.locationShareEndValue
        
        }
    }
    
    var titleDidChange: ((String) -> Void)?
    var title = "" {
        didSet {
            guard !title.isEmpty else { return }
            titleDidChange?(title)
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
    
    var placeTypeDidChange: ((Components.Schemas.InputUpdatePromiseDTO.destinationTypePayload) -> Void)?
    var placeType = Components.Schemas.InputUpdatePromiseDTO.destinationTypePayload.STATIC {
        didSet {
            placeTypeDidChange?(placeType)
            updateForm(keyPath: \.placeType, value: placeType)
        }
    }
    
    var placeDidChange: ((Components.Schemas.InputUpdatePromiseDTO.destinationPayload?) -> Void)?
    var place: Components.Schemas.InputUpdatePromiseDTO.destinationPayload? = nil {
        didSet {
            placeDidChange?(place)
            updateForm(keyPath: \.place, value: place)
        }
    }
    
    var middlePlaceDidChange: ((Components.Schemas.InputUpdatePromiseDTO.destinationPayload?) -> Void)?
    var middlePlace: Components.Schemas.InputUpdatePromiseDTO.destinationPayload? = nil {
        didSet {
            middlePlaceDidChange?(middlePlace)
            updateForm(keyPath: \.middlePlace, value: middlePlace)
        }
    }
    
    var shareLocationStartTypeDidChange: ((Components.Schemas.InputUpdatePromiseDTO.locationShareStartTypePayload) -> Void)?
    var shareLocationStartType = Components.Schemas.InputUpdatePromiseDTO.locationShareStartTypePayload.DISTANCE {
        didSet {
            shareLocationStartTypeDidChange?(shareLocationStartType)
            updateForm(keyPath: \.shareLocationStartType, value: shareLocationStartType)
        }
    }
    
    let shareLocationStartBasedOnDistanceInfo = ShareLocationStartBasedOnDistanceInfo()
    let shareLocationStartBasedOnTimeInfo = ShareLocationStartBasedOnTimeInfo()
    
    var shareLocationStartValueDidChange: ((SelectionItem) -> Void)?
    lazy var shareLocationStartValue = shareLocationStartBasedOnDistanceInfo.initialItem {
        didSet {
            switch(shareLocationStartType) {
            case .DISTANCE:
                
                shareLocationStartValueDidChange?(shareLocationStartValue)
                
                if let originItem = shareLocationStartBasedOnDistanceInfo
                    .getOriginItem(at: shareLocationStartValue.itemIndex) {
                    
                    updateForm(keyPath: \.shareLocationStartValue, value: originItem)
                    
                }
                
            case .TIME:
                    
                shareLocationStartValueDidChange?(shareLocationStartValue)
                
                if let originItem = shareLocationStartBasedOnTimeInfo
                    .getOriginItem(at: shareLocationStartValue.itemIndex) {
                    
                    updateForm(keyPath: \.shareLocationStartValue, value: originItem)
                    
                }
                
            }
        }
    }
    
    let shareLocationEndInfo = ShareLocationEndInfo()
    
    var shareLocationEndValueDidChange: ((SelectionItem) -> Void)?
    lazy var shareLocationEndValue = shareLocationEndInfo.initialItem {
        didSet {
            
            shareLocationEndValueDidChange?(shareLocationEndValue)
            
            if let originItem = shareLocationEndInfo
                .getOriginItem(at: shareLocationEndValue.itemIndex) {
                
                updateForm(keyPath: \.shareLocationEndValue, value: originItem)
                
            }
        }
    }
    
    lazy var form = PromiseForm(
        title: title,
        date: date,
        themes: [],
        placeType: placeType,
        place: place,
        middlePlace: middlePlace,
        shareLocationStartType: shareLocationStartType,
        shareLocationStartValue: shareLocationStartBasedOnDistanceInfo.getOriginItem(at: shareLocationStartValue.itemIndex)!,
        shareLocationEndValue: shareLocationEndInfo.getOriginItem(at: shareLocationEndValue.itemIndex)!
    ) {
        didSet {
            validateForm(form)
        }
    }
    
    init(currentVC: CreatePromiseVC? = nil) {
        self.currentVC = currentVC
    }
    
    private func updateForm<T>(keyPath: WritableKeyPath<PromiseForm, T>, value: T) {
        var newForm = self.form
        newForm[keyPath: keyPath] = value
        self.form = newForm
    }
    
    var assignOnVaildateForm: ((Bool) -> Void)?
    private func validateForm(_ form: PromiseForm) {
        
        // MARK: 약속 수정인 경우 validate
        if let _ = self.editingPromise,
           let title = self.capturedEditingPromiseTitle,
           let date = self.capturedEditingPromiseDate,
           let placeType = self.capturedEditingPromisePlaceType,
           let shareLocationStartType = self.capturedEditingPromiseShareLocationStartType,
           let shareLocationStartValue = self.capturedEditingPromiseShareLocationStartValue,
           let shareLocationEndValue = self.capturedEditingPromiseShareLocationEndValue
        {
            if form.title.isEmpty {
                assignOnVaildateForm?(false)
                return
            }
            
            let isEmptySelectedThemes = form.themes.filter{ $0.isSelected }.isEmpty
            if isEmptySelectedThemes {
                assignOnVaildateForm?(false)
                return
            }
            
            if form.title == title &&
               form.date?.originDate == date.originDate &&
               form.placeType == placeType &&
               // MARK: 장소는 nillable
                // TODO: 중간장소 validate
                (form.place == self.capturedEditingPromisePlace || form.middlePlace == self.capturedEditingPromiseMiddlePlace) &&
               form.shareLocationStartType == shareLocationStartType &&
               form.shareLocationStartValue == shareLocationStartValue &&
               form.shareLocationEndValue == shareLocationEndValue
            {
                
                if let capturedThemes = capturedEditingPromiseThemes {
                    
                    let selectedThemes = self.themes.filter { $0.isSelected }
                    let selectedThemeIdsSet = Set(selectedThemes.compactMap { $0.id })
                    
                    let capturedSelectedThemes = capturedThemes.filter({ $0.isSelected })
                    let capturedSelectedThemeIdsSet = Set(capturedSelectedThemes.compactMap { $0.id })
                    
                    if selectedThemeIdsSet != capturedSelectedThemeIdsSet {
                        assignOnVaildateForm?(true)
                        return
                    }
                }
                
                assignOnVaildateForm?(false)
                return
            }
            
            assignOnVaildateForm?(true)
            return
        }
        
        guard !form.title.isEmpty else {
            assignOnVaildateForm?(false)
            return
        }
        
        guard let _ = form.date else {
            assignOnVaildateForm?(false)
            return
        }
        
        let isExistSelectedThemes = !form.themes.filter{ $0.isSelected }.isEmpty
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
    
    func onChangedPlaceType(_ type: Components.Schemas.InputUpdatePromiseDTO.destinationTypePayload) {
    
        // MARK: 장소 타입 중간장소로 변경시 출발지에 따른 상태 체크
        if type == .DYNAMIC, let editingPromise {
            let helper = DynamicDestinationHelper()
            let state = helper.getConfigurableState(promise: editingPromise)
            self.dynamicDestinationState = state
        }
        
        self.placeType = type
    }
    
    func onChangedPlace(_ place: Components.Schemas.InputUpdatePromiseDTO.destinationPayload) {
        self.place = place
    }
    
    func onChangedMiddlePlace(_ middlePlace: Components.Schemas.InputUpdatePromiseDTO.destinationPayload) {
        self.middlePlace = middlePlace
    }
    
    func onChangedShareLocationStartType(_ type: Components.Schemas.InputUpdatePromiseDTO.locationShareStartTypePayload) {
        self.shareLocationStartType = type
    }
    
    func onChangedShareLocationStartValue(shareLocationStartValue: SelectionItem) {
        self.shareLocationStartValue = shareLocationStartValue
    }
    
    func onChangedShareLocationEndValue(shareLocationEndValue: SelectionItem) {
        self.shareLocationEndValue = shareLocationEndValue
    }
    
    func requestCreatePromise(
        with submitForm: Components.Schemas.InputUpdatePromiseDTO,
        _ completion: @escaping ((Components.Schemas.PromiseDTO?) -> Void)
    ) {
        Task {
            let result: Result<Components.Schemas.PromiseDTO, NetworkError> = await APIService.shared.fetch(
                .POST,
                "/promises",
                nil,
                submitForm
            )
            
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
    
    func requestEditPromise(
        with submitForm: Components.Schemas.InputUpdatePromiseDTO,
        _ completion: @escaping ((Components.Schemas.PromiseDTO?) -> Void)
    ) {
        guard let editingPromise else { return }
        
        Task {
            let result: Result<Components.Schemas.PromiseDTO, NetworkError> = await APIService.shared.fetch(
                .PUT,
                "/promises/\(editingPromise.pid)",
                nil,
                submitForm
            )
            
            switch result {
            case .success(let createdPromise):
                completion(createdPromise)
            case .failure(let errorType):
                switch errorType {
                case .badRequest:
                    // TODO: 약속 업데이트 에러 핸들링
                    break
                default:
                    // Other Error(Network, badUrl ...)
                    break
                }
            }
        }
    }
    
    func submit(_ completion: @escaping ((Components.Schemas.PromiseDTO?) -> Void)) {
        // TODO: 임시, form.place로 변경해야함.
        let tempStaticPlace = Components.Schemas.InputUpdatePromiseDTO.destinationPayload(value1: .init(city: "서울특별시", district: "관악구", address: "관악로 14길 109", latitude: 37.48436353, longitude: 126.92972946))
        
        let submitForm = Components.Schemas.InputUpdatePromiseDTO(
            title: form.title,
            themeIds: themes.filter{ $0.isSelected }.map{ $0.id },
            promisedAt: form.date!.iso8601String,
            destinationType: form.placeType,
            destination: form.placeType == .STATIC ? tempStaticPlace : form.middlePlace,
            locationShareStartType: form.shareLocationStartType,
            locationShareStartValue: form.shareLocationStartValue,
            locationShareEndType: .TIME,
            locationShareEndValue: form.shareLocationEndValue
        )
        
        if let _ = editingPromise {
            requestEditPromise(with: submitForm, completion)
        } else {
            requestCreatePromise(with: submitForm, completion)
        }
        
    }
    
    func getTodayString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
    func getSupportedTheme(initSelectedThemes: [Components.Schemas.ThemeDTO]? = nil) async {
        themesLoading = true
        
        let result: Result<[Components.Schemas.ThemeDTO] ,NetworkError> = await APIService.shared.fetch(.GET, "/promises/themes")
        
        switch result {
        case .success(let themes):
            var selectedThemeIds: Set<Double> = Set()
            
            if let initSelectedThemes {
                selectedThemeIds = Set(initSelectedThemes.compactMap { $0.id })
            }
            
             let selectableThemes = themes.map { originTheme in
                
                return SelectableTheme(
                    id: originTheme.id,
                    theme: originTheme.name,
                    // contains 시간복잡도 O(1)
                    isSelected: selectedThemeIds.contains(originTheme.id)
                )
                
            }
            
            self.themes = selectableThemes
            self.capturedEditingPromiseThemes = selectableThemes
            
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
