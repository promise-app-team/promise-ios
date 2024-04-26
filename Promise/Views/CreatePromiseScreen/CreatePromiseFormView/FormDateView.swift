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
        label.text = L10n.CreatePromise.Form.dateLabel
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
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
        
        datePicker.layer.borderWidth = adjustedValue(1, .width)
        datePicker.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        datePicker.layer.cornerRadius = adjustedValue(8, .width)
        datePicker.layer.backgroundColor = UIColor.white.cgColor
        
        datePicker.layoutMargins = UIEdgeInsets(
            top: adjustedValue(20, .height),
            left: adjustedValue(20, .width),
            bottom: 0,
            right: adjustedValue(20, .width)
        )
        
        datePicker.addTarget(self, action: #selector(onSelectedDateAndTime), for: .valueChanged)

        return datePicker
    }()
    
    lazy var popoverView = {
        let popoverView = PopoverView(
            from: PopoverTarget(x: nil, y: adjustedValue(8, .height), target: promiseDateInput),
            in: createPromiseVM.currentVC!,
            contentView: datePicker,
            isEnableDimmingView: false,
            paddingHorizontal: adjustedValue(8, .width)
        )
        
        popoverView.delegate = self
        
        return popoverView
    }()
    
    private lazy var selectedDate = {
        let label = UILabel()
        
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width))
        
        let placeholder = createPromiseVM.getTodayString()
        label.text = placeholder
        label.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var promiseDateInput = {
        let imageView = UIImageView(image: Asset.calander.image)
        imageView.widthAnchor.constraint(equalToConstant: adjustedValue(20, .width)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(20, .height)).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageView, selectedDate])
        
        stackView.axis = .horizontal
        stackView.spacing = adjustedValue(5, .width)
        stackView.alignment = .center
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: adjustedValue(8, .height),
            left: adjustedValue(12, .width),
            bottom: adjustedValue(8, .height),
            right: adjustedValue(12, .width)
        )
        
        stackView.layer.borderWidth = adjustedValue(1, .width)
        stackView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        stackView.layer.cornerRadius = adjustedValue(8, .width)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapPromiseDateInput))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tapGesture)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    @objc func onTapPromiseDateInput() {
        
        if let date = createPromiseVM.date {
            datePicker.date = date.originDate
        } else {
            // MARK: 선택된 날짜가 없으면 현재 날짜로 지정
            let currentDate = Date()
            let initialDate = SelectionDate(originDate: currentDate)
            
            createPromiseVM.onChangedDate(initialDate)
            
            // MARK: 현재 시간으로부터 20분 후 부터 설정 가능
            datePicker.minimumDate = Calendar.current.date(
                byAdding: .minute,
                value: 20,
                to: currentDate
            )
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
            
            DispatchQueue.main.async { [weak self] in
                self?.selectedDate.text = date.formattedDate
                self?.selectedDate.textColor = .black
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
        configure()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        assignDateDidChange()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func render() {
        
        [label, promiseDateInput].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            promiseDateInput.topAnchor.constraint(equalTo: label.bottomAnchor, constant: adjustedValue(8, .height)),
            promiseDateInput.leadingAnchor.constraint(equalTo: leadingAnchor),
            promiseDateInput.trailingAnchor.constraint(equalTo: trailingAnchor),
            promiseDateInput.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            promiseDateInput.heightAnchor.constraint(equalToConstant: adjustedValue(45, .height))
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
