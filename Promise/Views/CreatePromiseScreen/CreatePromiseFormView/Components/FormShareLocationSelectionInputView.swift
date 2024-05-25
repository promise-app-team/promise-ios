//
//  FormSelectionInputView.swift
//  Promise
//
//  Created by dylan on 2023/09/27.
//

import Foundation
import UIKit

protocol FormShareLocationSelectionInputViewDelegate: UIView {
    func onSelect(selected: SelectionItem) -> String?
}

class FormShareLocationSelectionInputView: UIView {
    weak var delegate: FormShareLocationSelectionInputViewDelegate?
    
    private var placeholder: String?
    private var currentVC: UIViewController?
    
    private var items: [String]?
    private var initialItemIndex: Int?
    private var label: String?
    
    var currentItem: SelectionItem
    
    private lazy var selected = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        if let placeholder {
            label.text = placeholder
        } else {
            label.text = items?[initialItemIndex ?? 0] ?? ""
        }
        
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width))
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        return label
    }()
    
    private let selectionInputIcon = {
        let imageView = UIImageView(image: Asset.arrowDown.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: adjustedValue(24, .width)),
            imageView.heightAnchor.constraint(equalToConstant: adjustedValue(24, .height)),
        ])
        
        return imageView
    }()
    
    private lazy var inputButton = {
        let stackView = UIStackView(arrangedSubviews: [
            selected,
            selectionInputIcon
        ])
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: adjustedValue(8, .height),
            left: adjustedValue(16, .width),
            bottom: adjustedValue(8, .height),
            right: adjustedValue(12, .width))
        
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = adjustedValue(8, .width)
        stackView.layer.borderWidth = adjustedValue(1, .width)
        stackView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapInputButton))
        stackView.addGestureRecognizer(tapGesture)
        stackView.isUserInteractionEnabled = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var pickerLabel = {
        let label = UILabel()
        label.text = self.label
        label.textColor = .black
        label.font = UIFont(font: FontFamily.Pretendard.semiBold, size: adjustedValue(20, .width))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var header = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(pickerLabel)
        NSLayoutConstraint.activate([
            pickerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: adjustedValue(24, .height)),
            pickerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            pickerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            pickerLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -adjustedValue(24, .height))
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var picker = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if let items {
            let focusRow = initialItemIndex ?? 0
            pickerView.selectRow(focusRow, inComponent: 0, animated: true)
        }
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private lazy var pickerModalContent = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = adjustedValue(20, .width)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        [header, picker].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            picker.topAnchor.constraint(equalTo: header.bottomAnchor),
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(16, .width)),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(16, .width)),
            picker.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -adjustedValue(40, .height)),
            picker.heightAnchor.constraint(equalToConstant: adjustedValue(140, .height))
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc private func onTapInputButton() {
        guard let currentVC else { return }
        KeyboardManager.shared.hideKeyboard()
        CommonModalManager.shared.show(content: pickerModalContent, from: currentVC)
    }
    
    public func updateInputButtonText(displayText: String, item: SelectionItem) {
        selected.text = displayText
        picker.selectRow(item.itemIndex, inComponent: 0, animated: true)
        currentItem = item
        layoutIfNeeded()
        
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        isUserInteractionEnabled = false
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        isUserInteractionEnabled = true
    }
    
    init(
        currentVC: UIViewController?,
        items: [String],
        initialItemIndex: Int?,
        placeholder: String?,
        label: String?
    ) {
        self.currentVC = currentVC
        self.items = items
        
        if let initialItemIndex {
            self.initialItemIndex = initialItemIndex
            self.currentItem = SelectionItem(itemText: items[initialItemIndex], itemIndex: initialItemIndex)
        } else {
            self.initialItemIndex = 0
            self.currentItem = SelectionItem(itemText: items[0], itemIndex: 0)
        }
        
        if let placeholder {
            self.placeholder = placeholder
        }
        
        if let label {
            self.label = label
        }
        
        super.init(frame: .null)
        
        configure()
        render()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        CommonModalManager.shared.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func render() {
        [inputButton].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            inputButton.topAnchor.constraint(equalTo: topAnchor),
            inputButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            inputButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            inputButton.heightAnchor.constraint(equalToConstant: adjustedValue(45, .height))
        ])
    }
}

extension FormShareLocationSelectionInputView: UIPickerViewDelegate, UIPickerViewDataSource, CommonModalManagerDelegate {
    // MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items?.count ?? 0
    }
    
    // MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return adjustedValue(35, .height)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(20, .width))
        
        label.textAlignment = .center
        label.text = items?[row] ?? ""
        
        if pickerView.selectedRow(inComponent: component) == row {
            label.textColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items?[row] ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
        
        guard let item = items?[row] else { return }
        
        let selectionItem = SelectionItem(itemText: item, itemIndex: row)
        let updateText = delegate?.onSelect(selected: selectionItem)
        
        currentItem = selectionItem
        
        guard let updateText else {
            
            updateInputButtonText(
                displayText: item,
                item: selectionItem
            )
            
            return
        }
        
        updateInputButtonText(
            displayText: updateText,
            item: selectionItem
        )
    }
}
