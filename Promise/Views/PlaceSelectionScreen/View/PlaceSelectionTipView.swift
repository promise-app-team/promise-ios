//
//  PlaceSelectionTipView.swift
//  Promise
//
//  Created by 신동오 on 2024/01/09.
//

import UIKit

final class PlaceSelectionTipView: UIView {
    
    // MARK: Private Property
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.PlaceSelection.Tip.title
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(16, .width))
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        let subviews = [
            UILabel(),
            PlaceSelectionTipStackView(
                title: L10n.PlaceSelection.Tip.description1,
                description: L10n.PlaceSelection.Tip.description1Suffix
            ),
            PlaceSelectionTipStackView(
                title: L10n.PlaceSelection.Tip.description2,
                description: L10n.PlaceSelection.Tip.description2Suffix
            ),
            PlaceSelectionTipStackView(
                title: L10n.PlaceSelection.Tip.description3,
                description: L10n.PlaceSelection.Tip.description3Suffix
            )
        ]
        subviews.forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = adjustedValue(8, .height)
        return stackView
    }()
    
    // MARK: Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Function
    
    private func configure() {
        backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: adjustedValue(24, .height)),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -adjustedValue(24, .width)),
        ])
    }
}
