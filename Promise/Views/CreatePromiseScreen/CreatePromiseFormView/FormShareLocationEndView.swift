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
        label.text = L10n.CreatePromise.formShareLocationEndTimeLabel
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 12)
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
            placeholder: "\(initialItem.item)",
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
    
    init(vm: CreatePromiseVM) {
        createPromiseVM = vm
        super.init(frame: .null)
        configureFormShareLocationEndView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFormShareLocationEndView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [label, shareLocationEndInputButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            shareLocationEndInputButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            shareLocationEndInputButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLocationEndInputButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareLocationEndInputButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

extension FormShareLocationEndView: FormShareLocationSelectionInputViewDelegate {
    func onSelect(selected: SelectionItem) -> String? {
        createPromiseVM.onChangedShareLocationEnd(shareLocationEnd: selected)
        
        let items = createPromiseVM.shareLocationEndInfo.items
        let selectedItemText = selected.item
        let selectedItemIndex = selected.itemIndex
        
        // Update input button selected text
        if items.endIndex == selectedItemIndex {
            return "\(selectedItemText)"
        }
        
        return "\(selectedItemText)"
    }
}
