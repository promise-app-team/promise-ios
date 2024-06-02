//
//  PlaceSelectionTableViewCell.swift
//  Promise
//
//  Created by 신동오 on 2024/01/09.
//

import UIKit

enum Address {
    case streetName // 도로명
    case streetNumber // 지번
}

class PlaceSelectionTableViewCell: UITableViewCell {
    
    // MARK: Public Property
    
    var addressType: Address = .streetName
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width))
        return label
    }()
    
    private lazy var addressIconLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(12, .width))
        label.text = addressType == .streetName ? L10n.PlaceSelection.Label.loadPlaceName : L10n.PlaceSelection.Label.streetPlaceName
        label.widthAnchor.constraint(equalToConstant: adjustedValue(33, .width)).isActive = true
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(12, .width))
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        return label
    }()
    
    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(addressIconLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = adjustedValue(4, .width)
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressStackView)
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = adjustedValue(8, .height)
        return stackView
    }()
    
    // MARK: Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Function
    
    func updateNameLabel(newText: String) {
        nameLabel.text = newText
    }
    
    func updateAddressLabel(newText: String) {
        addressLabel.text = newText
    }
    
    // MARK: Private Function
    
    private func configure() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: adjustedValue(16, .height)),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -adjustedValue(24, .width)),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -adjustedValue(16, .height)),
        ])
    }
}
