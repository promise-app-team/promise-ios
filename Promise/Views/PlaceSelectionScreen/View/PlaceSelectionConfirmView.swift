//
//  PlaceSelectionConfirmView.swift
//  Promise
//
//  Created by 신동오 on 2024/01/26.
//

import UIKit

protocol PlaceSelectionConfirmViewTextFieldDelegate: UIViewController {
    func PlaceSelectionConfirmViewTextFieldDelegate()
}

final class PlaceSelectionConfirmView: UIView {
    
    weak var textFieldDelegate: PlaceSelectionConfirmViewTextFieldDelegate?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "주소"
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 16)
        return label
    }()
    
    private let roadAddressView = PlaceAddressStackView(addressType: .road, address: "도로명 주소")
    private let regionAddressView = PlaceAddressStackView(addressType: .region, address: "지번 주소")

    private let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "상세주소"
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 12)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        label.textColor = .lightGray
        return label
    }()
    
    let addressTextField: TextField = {
        let textField = TextField()
        textField.initialize(placeHolder: "ex) 미팅룸 304호", showSearchIcon: false)
        return textField
    }()
    
    let confirmButton: Button = {
        let btn = Button()
        btn.initialize(title: "완료", style: .primary)
        return btn
    }()
    
    // MARK: Initializer
    
    var mytextfield = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Function
    
    func configureAddressTextfieldDelegate(_ delegate: UITextFieldDelegate) {
        addressTextField.delegate = delegate
    }
    
    func updateTitleLabel(_ newTitle: String?) {
        if newTitle == nil {
            titleLabel.text = "주소"
            return
        }
        titleLabel.text = newTitle
    }
    
    func updateAddressLabel(_ roadAddress: String?,_ regionAddress: String?) {
        if let address = roadAddress {
            roadAddressView.updateAddressLabel(newAddress: address)
        }
        if let address = regionAddress {
            regionAddressView.updateAddressLabel(newAddress: address)
        }
    }
    
    // MARK: Private Function
    
    private func render() {
        [titleLabel, roadAddressView, regionAddressView, detailLabel, addressTextField, confirmButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            
            roadAddressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            roadAddressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            roadAddressView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
          
            regionAddressView.topAnchor.constraint(equalTo: roadAddressView.bottomAnchor, constant: 8),
            regionAddressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            regionAddressView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            detailLabel.topAnchor.constraint(equalTo: regionAddressView.bottomAnchor, constant: 16),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            addressTextField.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 8),
            addressTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addressTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            addressTextField.heightAnchor.constraint(equalToConstant: 40),
            
            confirmButton.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 24),
            confirmButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            confirmButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
