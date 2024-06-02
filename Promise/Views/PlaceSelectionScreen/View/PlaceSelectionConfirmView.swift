//
//  PlaceSelectionConfirmView.swift
//  Promise
//
//  Created by 신동오 on 2024/01/26.
//

import UIKit

protocol PlaceSelectionConfirmViewTextFieldDelegate: UIViewController {
    func placeSelectionConfirmViewTextFieldDelegate()
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
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.PlaceSelection.DetailAddressInput.label
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        label.textColor = .lightGray
        return label
    }()
    
    let addressTextField: TextField = {
        let textField = TextField()
        textField.initialize(placeHolder: L10n.PlaceSelection.DetailAddressInput.placeholder, showSearchIcon: false)
        textField.heightAnchor.constraint(equalToConstant: adjustedValue(40, .height)).isActive = true
        
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
    
    @objc func confirmButtonTapped() {
        handleTappedConfirmButton?()
    }
    
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
    
    func clearLabel() {
        titleLabel.text = " "
        roadNameAddressView.clearLabelText()
        lotNumberAddressView.clearLabelText()
    }
    
    func updateLabel(to place: PlaceSelection) {
        titleLabel.text = place.buildingName == "" ? L10n.PlaceSelection.Label.emptyPlaceName : place.buildingName
        let roadName = (place.roadNameAddress == "") ? L10n.PlaceSelection.Label.empty : place.roadNameAddress
        let lotNumber = (place.lotNumberAddress == "") ? L10n.PlaceSelection.Label.empty : place.lotNumberAddress
        roadNameAddressView.updateAddressLabel(newAddress: roadName)
        lotNumberAddressView.updateAddressLabel(newAddress: lotNumber)
    }
    
    // MARK: Private Function
    
    private func render() {
        [titleLabel, roadNameAddressView, lotNumberAddressView, detailLabel, addressTextField, confirmButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: adjustedValue(24, .height)),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -adjustedValue(24, .width)),
            
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
