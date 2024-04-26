//
//  ShareLocationEndTimeView.swift
//  Promise
//
//  Created by dylan on 2023/08/28.
//

import Foundation
import UIKit

class FormShareLocationEndView: UIView {
    var createPromiseVM: CreatePromiseVM
    
    private let label = {
        let label = UILabel()
        label.text = L10n.CreatePromise.Form.shareLocationEndTimeLabel
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shareLocationEndInputButton = {
        let shareLocationEndInfo = createPromiseVM.shareLocationEndInfo
        let items = shareLocationEndInfo.items
        let initialItem = shareLocationEndInfo.initialItem
        
        let formShareLocationSelectionInputView = FormShareLocationSelectionInputView(
            currentVC: createPromiseVM.currentVC,
            items: items,
            initialItemIndex: initialItem.itemIndex,
            placeholder: "\(initialItem.itemText)",
            label: L10n.CreatePromise.ShareLocationEnd.selectionLabel
        )

        formShareLocationSelectionInputView.delegate = self

        formShareLocationSelectionInputView.translatesAutoresizingMaskIntoConstraints = false
        return formShareLocationSelectionInputView
    }()
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        isUserInteractionEnabled = false
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        isUserInteractionEnabled = true
    }
    
    private func assignShareLocationEndValueDidChange() {
        createPromiseVM.shareLocationEndValueDidChange = { selectedItem in
            
            DispatchQueue.main.async { [weak self] in
                
                self?.shareLocationEndInputButton
                    .updateInputButtonText(
                        displayText: selectedItem.itemText,
                        item: selectedItem
                    )
                
                self?.layoutIfNeeded()
            }
        }
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
        
        assignShareLocationEndValueDidChange()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func render() {
        [label, shareLocationEndInputButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            shareLocationEndInputButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: adjustedValue(8, .height)),
            shareLocationEndInputButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLocationEndInputButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareLocationEndInputButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -adjustedValue(20, .height))
        ])
    }
}

extension FormShareLocationEndView: FormShareLocationSelectionInputViewDelegate {
    func onSelect(selected: SelectionItem) -> String? {
        createPromiseVM.onChangedShareLocationEndValue(
            shareLocationEndValue: selected
        )
        
        let items = createPromiseVM.shareLocationEndInfo.items
        let selectedItemText = selected.itemText
        let selectedItemIndex = selected.itemIndex
        
        // Update input button selected text
        if items.endIndex == selectedItemIndex {
            return "\(selectedItemText)"
        }
        
        return "\(selectedItemText)"
    }
}
