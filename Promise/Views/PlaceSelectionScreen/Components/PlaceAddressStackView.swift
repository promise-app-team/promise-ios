//
//  PlaceAddressStackView.swift
//  Promise
//
//  Created by 신동오 on 2024/01/26.
//

import UIKit

final class PlaceAddressStackView: UIStackView {
    
    enum AddressType {
        case road, region
    }
    
    private var addressType: AddressType
    
    private lazy var addressIconLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 12)
        label.text = addressType == .road ? "도로명" : "지번"
        label.widthAnchor.constraint(equalToConstant: 33).isActive = true
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 12)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        return label
    }()
    
    init(addressType: AddressType, address: String) {
        self.addressType = addressType
        addressLabel.text = address
        super.init(frame: .zero)
        
        addArrangedSubview(addressIconLabel)
        addArrangedSubview(addressLabel)
        axis = .horizontal
        distribution = .fill
        spacing = 4
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Function
    
    func updateAddressLabel(newAddress: String) {
        addressLabel.text = newAddress
    }
}
