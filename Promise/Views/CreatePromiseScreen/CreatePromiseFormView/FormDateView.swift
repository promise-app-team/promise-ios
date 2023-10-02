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
    
    private let datePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.tintColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
        
        datePicker.layer.borderWidth = 1
        datePicker.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        datePicker.layer.cornerRadius = 8
        datePicker.layer.backgroundColor = UIColor.white.cgColor

        datePicker.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    lazy var popoverView = PopoverView(
        from: PopoverTarget(x: 8, y: 8, target: promiseDateInput),
        in: createPromiseVM.currentVC!,
        contentView: datePicker
    )
    
    private lazy var promiseDateInput = {
        let imageView = UIImageView(image: Asset.calander.image)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = false
        
        let selectedDateString = createPromiseVM.form.date
        
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        label.text = selectedDateString.isEmpty ? createPromiseVM.getTodayString() : selectedDateString
        label.textColor = selectedDateString.isEmpty
        ? UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        : UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapDateLabel))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapGesture)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 16)
        
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        stackView.layer.cornerRadius = 8
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    @objc func onTapDateLabel() {
        popoverView.contentView = datePicker
        popoverView.show(animated: true)
    }
    
    init(vm: CreatePromiseVM) {
        createPromiseVM = vm
        super.init(frame: .null)
        configureFormDateView()
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
            
            promiseDateInput.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
}
