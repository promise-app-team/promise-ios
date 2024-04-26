//
//  PlaceAddressStackView.swift
//  Promise
//
//  Created by 신동오 on 2024/01/26.
//

import UIKit

final class PlaceAddressStackView: UIStackView {
    
    enum AddressType {
        case roadName, lotNumber
    }
    
    private var addressType: AddressType
    
    private lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        switch addressType {
        case .roadName:
            label.text = "도로명"
        case .lotNumber:
            label.text = "지번"
        }
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 12)
        label.widthAnchor.constraint(equalToConstant: 33).isActive = true
        return label
    }()
    
    private let addressDetailLabel: UILabel = {
        let label = UILabel()
        label.text = "없음"
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 12)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        return label
    }()
    
    init(addressType: AddressType) {
        self.addressType = addressType
        super.init(frame: .zero)
        
        addArrangedSubview(addressTitleLabel)
        addArrangedSubview(addressDetailLabel)
        axis = .horizontal
        distribution = .fill
        spacing = 4
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Function
    
    func clearLabelText() {
        addressDetailLabel.text = nil
    }
    
    func updateAddressLabel(newAddress: String) {
        addressDetailLabel.text = newAddress
    }
}
