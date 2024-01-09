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
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        return label
    }()
    
    private lazy var addressIconLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        label.text = addressType == .streetName ? "도로명" : "지번"
        label.widthAnchor.constraint(equalToConstant: 15).isActive = true
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 12)
        return label
    }()
    
    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(addressIconLabel)
        stackView.addArrangedSubview(addressLabel)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressStackView)
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 8
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
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
}
