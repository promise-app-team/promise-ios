//
//  PlaceSelectionConfirmView.swift
//  Promise
//
//  Created by 신동오 on 2024/01/26.
//

import UIKit

protocol PlaceSelectionConfirmViewTextFieldDelegate: AnyObject {
    func onChangeText(text: String)
}

final class PlaceSelectionConfirmView: UIView {
    
    weak var textFieldDelegate: PlaceSelectionConfirmViewTextFieldDelegate?
    
    var handleTappedConfirmButton: (()->())?
    
    // MARK: - Views
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(16, .width))
        return label
    }()
    
    private let roadNameAddressView = PlaceAddressStackView(addressType: .roadName)
    private let lotNumberAddressView = PlaceAddressStackView(addressType: .lotNumber)
    private let addressView = {
        let stackView = PlaceAddressStackView(addressType: .address)
        stackView.isHidden = true
        return stackView
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.PlaceSelection.DetailAddressInput.label
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var addressTextField: TextField = {
        let textField = TextField()
        textField.initialize(placeHolder: L10n.PlaceSelection.DetailAddressInput.placeholder, showSearchIcon: false)
        textField.heightAnchor.constraint(equalToConstant: adjustedValue(40, .height)).isActive = true
        
        textField.addTarget(self, action: #selector(onChangedAddressTextField), for: .editingChanged)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let confirmButton: Button = {
        let button = Button()
        button.initialize(title: L10n.Common.success, style: .primary)
        button.addTarget(nil, action: #selector(confirmButtonTapped), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: Button.Height).isActive = true
        return button
    }()
    
    @objc func onChangedAddressTextField(_ textField: UITextField) {
        textFieldDelegate?.onChangeText(text: textField.text ?? "")
    }
    
    @objc func confirmButtonTapped() {
        handleTappedConfirmButton?()
    }
    
    // MARK: Initializer
    
    var mytextfield = UITextField()
    
    init() {
        super.init(frame: .null)
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
    
    func clearLabel() {
        titleLabel.text = " "
        roadNameAddressView.clearLabelText()
        lotNumberAddressView.clearLabelText()
        addressView.clearLabelText()
    }
    
    func updateLabel(to place: PlaceSelection) {
        DispatchQueue.main.async {
            
            self.titleLabel.text = (place.placeName ?? "").isEmpty
            ? L10n.PlaceSelection.Label.emptyPlaceName
            : place.placeName
            
            let roadName = place.roadNameAddress.isEmpty
            ? L10n.PlaceSelection.Label.empty
            : place.roadNameAddress
            
            let lotNumber = place.lotNumberAddress.isEmpty
            ? L10n.PlaceSelection.Label.empty
            : place.lotNumberAddress
            
            self.roadNameAddressView.isHidden = false
            self.lotNumberAddressView.isHidden = false
            self.addressView.isHidden = true
            
            self.roadNameAddressView.updateAddressLabel(newAddress: roadName)
            self.lotNumberAddressView.updateAddressLabel(newAddress: lotNumber)
            
            self.layoutIfNeeded()
            
        }
    }
    
    func updateLabel(with place: PlaceSelection) {
        DispatchQueue.main.async {
            
            self.titleLabel.text = (place.placeName ?? "").isEmpty
            ? L10n.PlaceSelection.Label.emptyPlaceName
            : place.placeName
            
            let address1 = place.address1
            
            self.roadNameAddressView.isHidden = true
            self.lotNumberAddressView.isHidden = true
            self.addressView.isHidden = false
            
            self.addressView.updateAddressLabel(newAddress: address1)
            
            self.layoutIfNeeded()
            
        }
    }
    
    // MARK: Private Function
    
    private func render() {
        [titleLabel, addressView, roadNameAddressView, lotNumberAddressView, detailLabel, addressTextField, confirmButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: adjustedValue(24, .height)),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -adjustedValue(24, .width)),
            
            addressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: adjustedValue(8, .height)),
            addressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addressView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            roadNameAddressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: adjustedValue(8, .height)),
            roadNameAddressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            roadNameAddressView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            lotNumberAddressView.topAnchor.constraint(equalTo: roadNameAddressView.bottomAnchor, constant: adjustedValue(8, .height)),
            lotNumberAddressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lotNumberAddressView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            detailLabel.topAnchor.constraint(equalTo: lotNumberAddressView.bottomAnchor, constant: adjustedValue(16, .height)),
            detailLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            addressTextField.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: adjustedValue(8, .height)),
            addressTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            addressTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            confirmButton.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: adjustedValue(24, .height)),
            confirmButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            confirmButton.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
}
