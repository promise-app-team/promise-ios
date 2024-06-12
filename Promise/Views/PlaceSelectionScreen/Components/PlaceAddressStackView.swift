//
//  PlaceAddressStackView.swift
//  Promise
//
//  Created by 신동오 on 2024/01/26.
//

import UIKit

final class PlaceAddressStackView: UIStackView {
    
    enum AddressType {
        case roadName, lotNumber, address
    }
    
    private var addressType: AddressType
    
    private lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        switch addressType {
        case .roadName:
            label.text = L10n.PlaceSelection.Label.loadPlaceName
        case .lotNumber:
            label.text = L10n.PlaceSelection.Label.streetPlaceName
        case .address:
            label.text = L10n.PlaceSelection.Label.address
        }
        
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(12, .width))
        label.widthAnchor.constraint(equalToConstant: adjustedValue(33, .width)).isActive = true
        return label
    }()
    
    private let addressDetailLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.PlaceSelection.Label.empty
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(12, .width))
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
        spacing = adjustedValue(4, .width)
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
