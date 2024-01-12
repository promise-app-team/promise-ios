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
        label.text = "주소 검색 Tip"
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 16)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        let subviews = [
            UILabel(),
            PlaceSelectionTipStackView(title: "도로명 + 건물번호", description: "(예 : 프로미스로 58길)"),
            PlaceSelectionTipStackView(title: "지역명 + 번지", description: "(예 : 프로미스동 58)"),
            PlaceSelectionTipStackView(title: "건물명, 아파트명", description: "(예 : 프로미스 오피스텔 508동)")]
        subviews.forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
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
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
    }
}
