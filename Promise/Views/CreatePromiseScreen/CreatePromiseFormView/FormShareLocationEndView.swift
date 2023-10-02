//
//  ShareLocationEndTimeView.swift
//  Promise
//
//  Created by dylan on 2023/08/28.
//

import Foundation
import UIKit

class FormShareLocationEndTimeView: UIView {
    var createPromiseVM: CreatePromiseVM
    
    let minutes = ["10", "20", "30", "40", "50"]
    let hours = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    
    lazy var minutesText = minutes.map { "\($0)\(L10n.Common.minute) \(L10n.CreatePromise.ShareLocationEnd.itemSuffix)" }
    lazy var hoursText = hours.map { "\($0)\(L10n.Common.hour) \(L10n.CreatePromise.ShareLocationEnd.itemSuffix)" }
    lazy var maxText = "\(L10n.CreatePromise.ShareLocationEnd.max)"
    
    lazy var items = minutesText + hoursText + [maxText]
    lazy var initialItem = (items[5], 5)
    
    private let label = {
        let label = UILabel()
        label.text = L10n.CreatePromise.formShareLocationEndTimeLabel
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 12)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shareLocationEndInputButton = {
        let formShareLocationSelectionInputView = FormShareLocationSelectionInputView(
            currentVC: createPromiseVM.currentVC,
            items: items,
            initialItemIndex: initialItem.1,
            placeholder: "\(L10n.CreatePromise.ShareLocationEnd.itemPrefix) \(initialItem.0)",
            label: L10n.CreatePromise.ShareLocationStartType.BasedOnTime.selectionLabel
        )
        
        formShareLocationSelectionInputView.delegate = self
        
        formShareLocationSelectionInputView.isHidden = true
        formShareLocationSelectionInputView.translatesAutoresizingMaskIntoConstraints = false
        return formShareLocationSelectionInputView
    }()
    
    init(vm: CreatePromiseVM) {
        createPromiseVM = vm
        super.init(frame: .null)
        configureFormShareLocationEndTimeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFormShareLocationEndTimeView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [label, shareLocationEndInputButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            shareLocationEndInputButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            shareLocationEndInputButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            shareLocationEndInputButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareLocationEndInputButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension FormShareLocationEndTimeView: FormShareLocationSelectionInputViewDelegate {
    func onSelect(selected: (String, Int)) -> String? {
        createPromiseVM.onChangedShareLocationEnd(shareLocationEnd: selected)
        
        let (selectedItemText, _) = selected
        
        // Update input button selected text
        if items.endIndex == selected.1 {
            return "\(L10n.CreatePromise.ShareLocationEnd.itemPrefix) \(selectedItemText)"
        }
        
        return "\(L10n.CreatePromise.ShareLocationEnd.itemPrefix) \(selectedItemText)"
    }
}
