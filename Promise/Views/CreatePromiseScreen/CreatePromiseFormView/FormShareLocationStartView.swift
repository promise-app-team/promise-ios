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
        label.text = L10n.CreatePromise.Form.shareLocationStartTimeLabel
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
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
    
    private lazy var shareLocationStartBasedOnDistanceInputButton = {
        let shareLocationStartBasedOnDistanceInfo = createPromiseVM.shareLocationStartBasedOnDistanceInfo
        let items = shareLocationStartBasedOnDistanceInfo.items
        let initialItem = shareLocationStartBasedOnDistanceInfo.initialItem
        
        let formShareLocationSelectionInputView = FormShareLocationSelectionInputView(
            currentVC: createPromiseVM.currentVC,
            items: items,
            initialItemIndex: initialItem.itemIndex,
            placeholder: "\(L10n.CreatePromise.ShareLocationStartType.BaseOnDistance.itemPrefix) \(initialItem.itemText)",
            label: L10n.CreatePromise.ShareLocationStartType.BaseOnDistance.selectionLabel
        )
        
        formShareLocationSelectionInputView.delegate = self
        
        formShareLocationSelectionInputView.isHidden = false
        formShareLocationSelectionInputView.translatesAutoresizingMaskIntoConstraints = false
        return formShareLocationSelectionInputView
    }()
    
    private lazy var shareLocationStartBasedOnTimeInputButton = {
        let shareLocationStartBasedOnTimeInfo = createPromiseVM.shareLocationStartBasedOnTimeInfo
        let items = shareLocationStartBasedOnTimeInfo.items
        let initialItem = shareLocationStartBasedOnTimeInfo.initialItem
        
        let formShareLocationSelectionInputView = FormShareLocationSelectionInputView(
            currentVC: createPromiseVM.currentVC,
            items: items,
            initialItemIndex: initialItem.itemIndex,
            placeholder: "\(L10n.CreatePromise.ShareLocationStartType.BasedOnTime.itemPrefix) \(initialItem.itemText)",
            label: L10n.CreatePromise.ShareLocationStartType.BasedOnTime.selectionLabel
        )
        
        formShareLocationSelectionInputView.delegate = self
        
        formShareLocationSelectionInputView.isHidden = true
        formShareLocationSelectionInputView.translatesAutoresizingMaskIntoConstraints = false
        return formShareLocationSelectionInputView
    }()
    
    private func assignShareLocationStartTypeDidChange() {
        createPromiseVM.shareLocationStartTypeDidChange = { type in
            
            DispatchQueue.main.async { [weak self] in
                switch(type) {
                case .DISTANCE:
                    self?.shareLocationStartType.updateUIForSelectedTab(tab: .LEFT)
                    self?.shareLocationStartBasedOnDistanceInputButton.isHidden = false
                    self?.shareLocationStartBasedOnTimeInputButton.isHidden = true
                case .TIME:
                    self?.shareLocationStartType.updateUIForSelectedTab(tab: .RIGHT)
                    self?.shareLocationStartBasedOnDistanceInputButton.isHidden = true
                    self?.shareLocationStartBasedOnTimeInputButton.isHidden = false
                }
                
                self?.layoutIfNeeded()
            }
        }
    }
    
    private func assignShareLocationStartValueDidChange() {
        createPromiseVM.shareLocationStartValueDidChange = { selectedItem in
            
            DispatchQueue.main.async { [weak self] in
                guard let shareLocationStartType = self?.createPromiseVM.shareLocationStartType else { return }
                
                switch shareLocationStartType {
                case .DISTANCE:
                    
                    if let displayText = self?.createPromiseVM
                        .shareLocationStartBasedOnDistanceInfo
                        .getPrefixedItemText(
                            itemText: selectedItem.itemText
                        ) {
                        
                        self?.shareLocationStartBasedOnDistanceInputButton
                            .updateInputButtonText(
                                displayText: displayText,
                                item: selectedItem
                            )
                        
                    }
                     
                case .TIME:
                        
                    if let displayText = self?.createPromiseVM
                        .shareLocationStartBasedOnTimeInfo
                        .getPrefixedItemText(
                            itemText: selectedItem.itemText
                        ) {
                        
                        self?.shareLocationStartBasedOnTimeInputButton
                            .updateInputButtonText(
                                displayText: displayText,
                                item: selectedItem
                            )
                        
                    }
                    
                }
                
                self?.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        isUserInteractionEnabled = false
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        isUserInteractionEnabled = true
    }
    
    init(vm: CreatePromiseVM) {
        createPromiseVM = vm
        super.init(frame: .null)
        configure()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        assignShareLocationStartTypeDidChange()
        assignShareLocationStartValueDidChange()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func render() {
        [label,
         shareLocationStartType,
         shareLocationStartBasedOnTimeInputButton,
         shareLocationStartBasedOnDistanceInputButton
        ].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            shareLocationStartType.topAnchor.constraint(equalTo: label.bottomAnchor, constant: adjustedValue(8, .height)),
            shareLocationStartType.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLocationStartType.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            shareLocationStartBasedOnDistanceInputButton.topAnchor.constraint(equalTo: shareLocationStartType.bottomAnchor, constant: adjustedValue(8, .height)),
            shareLocationStartBasedOnDistanceInputButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLocationStartBasedOnDistanceInputButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareLocationStartBasedOnDistanceInputButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            shareLocationStartBasedOnTimeInputButton.topAnchor.constraint(equalTo: shareLocationStartType.bottomAnchor, constant: adjustedValue(8, .height)),
            shareLocationStartBasedOnTimeInputButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLocationStartBasedOnTimeInputButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareLocationStartBasedOnTimeInputButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension FormShareLocationStartView: FormTabMenuViewDelegate, FormShareLocationSelectionInputViewDelegate {
    func onTapLeftButton() {
        createPromiseVM.onChangedShareLocationStartType(.DISTANCE)
        
        createPromiseVM
            .onChangedShareLocationStartValue(
                shareLocationStartValue: 
                    shareLocationStartBasedOnDistanceInputButton
                    .currentItem
            )
    }
    
    func onTapRightButton() {
        createPromiseVM.onChangedShareLocationStartType(.TIME)
        
        createPromiseVM
            .onChangedShareLocationStartValue(
                shareLocationStartValue:
                    shareLocationStartBasedOnTimeInputButton
                    .currentItem
            )
    }
    
    func onSelect(selected: SelectionItem) -> String? {
        createPromiseVM.onChangedShareLocationStartValue(shareLocationStartValue: selected)
        
        let shareLocationStartBasedOnDistanceInfo = createPromiseVM.shareLocationStartBasedOnDistanceInfo
        
        let shareLocationStartBasedOnTimeInfo = createPromiseVM.shareLocationStartBasedOnTimeInfo
        
        let shareLocationStartType = createPromiseVM.shareLocationStartType
        let selectedItemText = selected.itemText
        
        // Update input button selected text
        switch(shareLocationStartType) {
        case .DISTANCE:
            
            return shareLocationStartBasedOnDistanceInfo.getPrefixedItemText(itemText: selectedItemText)
            
        case .TIME:
            
            return shareLocationStartBasedOnTimeInfo.getPrefixedItemText(itemText: selectedItemText)
            
        }
    }
}
