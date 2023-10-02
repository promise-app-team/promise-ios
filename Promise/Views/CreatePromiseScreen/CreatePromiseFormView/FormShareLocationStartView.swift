//
//  ShareLocationStartTimeView.swift
//  Promise
//
//  Created by dylan on 2023/08/28.
//

import Foundation
import UIKit

class FormShareLocationStartView: UIView {
    var createPromiseVM: CreatePromiseVM
    
    private let label = {
        let label = UILabel()
        label.text = L10n.CreatePromise.formShareLocationStartTimeLabel
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 12)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shareLocationStartType = {
        let formTabMenu = FormTabMenuView(
            leftButtonTitle: L10n.CreatePromise.ShareLocationStartType.basedOnDistance,
            rightButtonTitle: L10n.CreatePromise.ShareLocationStartType.basedOnTime
        )
        
        formTabMenu.delegate = self
        formTabMenu.translatesAutoresizingMaskIntoConstraints = false
        return formTabMenu
    }()
    
    private lazy var shareLocationBasedOnDistanceInputButton = {
        let meters = ["100", "200", "300", "400", "500", "600", "700", "800", "900"]
        let kilometers = ["1", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50"]
        
        let metersText = meters.map { "\($0)\(L10n.Common.m)" }
        let kilometersText = kilometers.map { "\($0)\(L10n.Common.km)" }
        
        let items = metersText + kilometersText
        let initialItem = (items[9], 9)
        
        let formShareLocationSelectionInputView = FormShareLocationSelectionInputView(
            currentVC: createPromiseVM.currentVC,
            items: items,
            initialItemIndex: initialItem.1,
            placeholder: "\(L10n.CreatePromise.ShareLocationStartType.BaseOnDistance.itemPrefix) \(initialItem.0)",
            label: L10n.CreatePromise.ShareLocationStartType.BaseOnDistance.selectionLabel
        )
        
        formShareLocationSelectionInputView.delegate = self
        
        formShareLocationSelectionInputView.isHidden = false
        formShareLocationSelectionInputView.translatesAutoresizingMaskIntoConstraints = false
        return formShareLocationSelectionInputView
    }()
    
    private lazy var shareLocationBasedOnTimeInputButton = {
        let minutes = ["10", "20", "30", "40", "50"]
        let hours = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        
        let minutesText = minutes.map { "\($0)\(L10n.Common.minute) \(L10n.CreatePromise.ShareLocationStartType.BasedOnTime.itemSuffix)" }
        let hoursText = hours.map { "\($0)\(L10n.Common.hour) \(L10n.CreatePromise.ShareLocationStartType.BasedOnTime.itemSuffix)" }
        
        let items = minutesText + hoursText
        let initialItem = (items[5], 5)
        
        let formShareLocationSelectionInputView = FormShareLocationSelectionInputView(
            currentVC: createPromiseVM.currentVC,
            items: items,
            initialItemIndex: initialItem.1,
            placeholder: "\(L10n.CreatePromise.ShareLocationStartType.BasedOnTime.itemPrefix) \(initialItem.0)",
            label: L10n.CreatePromise.ShareLocationStartType.BasedOnTime.selectionLabel
        )
        
        formShareLocationSelectionInputView.delegate = self
        
        formShareLocationSelectionInputView.isHidden = true
        formShareLocationSelectionInputView.translatesAutoresizingMaskIntoConstraints = false
        return formShareLocationSelectionInputView
    }()
    
    private func assignShareLocationStartTypeDidChange() {
        createPromiseVM.shareLocationStartTypeDidChange = { [weak self] type in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch(type) {
                case .DISTANCE:
                    self.shareLocationBasedOnDistanceInputButton.isHidden = false
                    self.shareLocationBasedOnTimeInputButton.isHidden = true
                case .TIME:
                    self.shareLocationBasedOnDistanceInputButton.isHidden = true
                    self.shareLocationBasedOnTimeInputButton.isHidden = false
                }
                
                self.layoutIfNeeded()
            }
        }
    }
    
    init(vm: CreatePromiseVM) {
        createPromiseVM = vm
        super.init(frame: .null)
        
        assignShareLocationStartTypeDidChange()
        configureFormShareLocationStartView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFormShareLocationStartView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [label,
         shareLocationStartType,
         shareLocationBasedOnTimeInputButton,
         shareLocationBasedOnDistanceInputButton
        ].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            shareLocationStartType.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            shareLocationStartType.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLocationStartType.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            shareLocationBasedOnTimeInputButton.topAnchor.constraint(equalTo: shareLocationStartType.bottomAnchor, constant: 8),
            shareLocationBasedOnTimeInputButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLocationBasedOnTimeInputButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareLocationBasedOnTimeInputButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            shareLocationBasedOnDistanceInputButton.topAnchor.constraint(equalTo: shareLocationStartType.bottomAnchor, constant: 8),
            shareLocationBasedOnDistanceInputButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLocationBasedOnDistanceInputButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareLocationBasedOnDistanceInputButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension FormShareLocationStartView: FormTabMenuViewDelegate, FormShareLocationSelectionInputViewDelegate {
    func onTapLeftButton() {
        createPromiseVM.onChangedShareLocationStartType(ShareLocationEnum.DISTANCE)
    }
    
    func onTapRightButton() {
        createPromiseVM.onChangedShareLocationStartType(ShareLocationEnum.TIME)
    }
    
    func onSelect(selected: (String, Int)) -> String? {
        createPromiseVM.onChangedShareLocationStart(shareLocationStart: selected)
        
        let shareLocationStartType = createPromiseVM.shareLocationStartType
        let (selectedItemText, _) = selected
        
        // Update input button selected text
        switch(shareLocationStartType) {
        case .DISTANCE:
            return "\(L10n.CreatePromise.ShareLocationStartType.BaseOnDistance.itemPrefix) \(selectedItemText)"
        case .TIME:
            return "\(L10n.CreatePromise.ShareLocationStartType.BasedOnTime.itemPrefix) \(selectedItemText)"
        }
    }
}
