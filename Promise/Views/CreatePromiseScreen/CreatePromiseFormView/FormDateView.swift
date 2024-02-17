//
//  FormDateView.swift
//  Promise
//
//  Created by dylan on 2023/08/28.
//

import Foundation
import UIKit

class FormDateView: UIView {
    var createPromiseVM: CreatePromiseVM
    
    private let label = {
        let label = UILabel()
        label.text = L10n.CreatePromise.formDateLabel
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 12)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var datePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.tintColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
        
        datePicker.layer.borderWidth = 1
        datePicker.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        datePicker.layer.cornerRadius = 8
        datePicker.layer.backgroundColor = UIColor.white.cgColor
        
        datePicker.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        
        datePicker.addTarget(self, action: #selector(onSelectedDateAndTime), for: .valueChanged)
        datePicker.minimumDate = Date() // TODO: 현재부터 10분 후로 변경

        return datePicker
    }()
    
    lazy var popoverView = {
        let popoverView = PopoverView(
            from: PopoverTarget(x: nil, y: 8, target: promiseDateInput),
            in: createPromiseVM.currentVC!,
            contentView: datePicker,
            isEnableDimmingView: false,
            paddingHorizontal: 8
        )
        
        popoverView.delegate = self
        
        return popoverView
    }()
    
    private lazy var selectedDate = {
        let label = UILabel()
        
        let placeholder = createPromiseVM.getTodayString()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        label.text = placeholder
        label.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        return label
    }()
    
    private lazy var promiseDateInput = {
        let imageView = UIImageView(image: Asset.calander.image)
        imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageView, selectedDate])
        
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        stackView.layer.cornerRadius = 8
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapPromiseDateInput))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tapGesture)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    @objc func onTapPromiseDateInput() {
        if(createPromiseVM.date == nil) {
            let selectionDate = SelectionDate(originDate: Date())
            createPromiseVM.onChangedDate(selectionDate)
        }
        
        KeyboardManager.shared.hideKeyboard()
        popoverView.show()
    }
    
    @objc func onSelectedDateAndTime(_ sender: UIDatePicker) {
        let selectionDate = SelectionDate(originDate: sender.date)
        createPromiseVM.onChangedDate(selectionDate)
    }
    
    private func assignDateDidChange() {
        createPromiseVM.dateDidChange = { [weak self] date in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.selectedDate.text = date.formattedDate
                self.selectedDate.textColor = .black
            }
        }
    }
    
    private func updatePromiseDateInput(isFocused: Bool) {
        let animationColor = isFocused
        ? UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor
        : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        
        UIView.animate(withDuration: 0.1) {
            self.promiseDateInput.layer.borderColor = animationColor
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
        
        assignDateDidChange()
        configureFormDateView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFormDateView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [label, promiseDateInput].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            promiseDateInput.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            promiseDateInput.leadingAnchor.constraint(equalTo: leadingAnchor),
            promiseDateInput.trailingAnchor.constraint(equalTo: trailingAnchor),
            promiseDateInput.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            promiseDateInput.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension FormDateView: PopoverViewDelegate {
    func onWillShow() {
        updatePromiseDateInput(isFocused: true)
    }
    
    func onWillHide() {
        updatePromiseDateInput(isFocused: false)
    }
}
