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
    
    private lazy var shareLocationStartBasedOnDistanceInputButton = {
        let shareLocationStartBasedOnDistanceInfo = createPromiseVM.shareLocationStartBasedOnDistanceInfo
        let items = shareLocationStartBasedOnDistanceInfo.items
        let initialItem = shareLocationStartBasedOnDistanceInfo.initialItem
        
        let formShareLocationSelectionInputView = FormShareLocationSelectionInputView(
            currentVC: createPromiseVM.currentVC,
            items: items,
            initialItemIndex: initialItem.itemIndex,
            placeholder: "\(L10n.CreatePromise.ShareLocationStartType.BaseOnDistance.itemPrefix) \(initialItem.item)",
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
            placeholder: "\(L10n.CreatePromise.ShareLocationStartType.BasedOnTime.itemPrefix) \(initialItem.item)",
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
                    self.shareLocationStartBasedOnDistanceInputButton.isHidden = false
                    self.shareLocationStartBasedOnTimeInputButton.isHidden = true
                case .TIME:
                    self.shareLocationStartBasedOnDistanceInputButton.isHidden = true
                    self.shareLocationStartBasedOnTimeInputButton.isHidden = false
                default:
                    break
                }
                
                self.layoutIfNeeded()
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
        
        assignShareLocationStartTypeDidChange()
        configureFormShareLocationStartView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFormShareLocationStartView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [label,
         shareLocationStartType,
         shareLocationStartBasedOnTimeInputButton,
         shareLocationStartBasedOnDistanceInputButton
        ].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            shareLocationStartType.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            shareLocationStartType.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLocationStartType.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            shareLocationStartBasedOnDistanceInputButton.topAnchor.constraint(equalTo: shareLocationStartType.bottomAnchor, constant: 8),
            shareLocationStartBasedOnDistanceInputButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLocationStartBasedOnDistanceInputButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareLocationStartBasedOnDistanceInputButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            shareLocationStartBasedOnTimeInputButton.topAnchor.constraint(equalTo: shareLocationStartType.bottomAnchor, constant: 8),
            shareLocationStartBasedOnTimeInputButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLocationStartBasedOnTimeInputButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareLocationStartBasedOnTimeInputButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension FormShareLocationStartView: FormTabMenuViewDelegate, FormShareLocationSelectionInputViewDelegate {
    func onTapLeftButton() {
        createPromiseVM.onChangedShareLocationStartType(Components.Schemas.InputCreatePromise.locationShareStartTypePayload.DISTANCE)
        createPromiseVM.onChangedShareLocationStart(shareLocationStart: shareLocationStartBasedOnDistanceInputButton.currentItem)
    }
    
    func onTapRightButton() {
        createPromiseVM.onChangedShareLocationStartType(Components.Schemas.InputCreatePromise.locationShareStartTypePayload.TIME)
        createPromiseVM.onChangedShareLocationStart(shareLocationStart: shareLocationStartBasedOnTimeInputButton.currentItem)
    }
    
    func onSelect(selected: SelectionItem) -> String? {
        createPromiseVM.onChangedShareLocationStart(shareLocationStart: selected)
        
        let shareLocationStartType = createPromiseVM.shareLocationStartType
        let selectedItemText = selected.item
        
        // Update input button selected text
        switch(shareLocationStartType) {
        case .DISTANCE:
            return "\(L10n.CreatePromise.ShareLocationStartType.BaseOnDistance.itemPrefix) \(selectedItemText)"
        case .TIME:
            return "\(L10n.CreatePromise.ShareLocationStartType.BasedOnTime.itemPrefix) \(selectedItemText)"
        default:
            return nil
        }
    }
}
