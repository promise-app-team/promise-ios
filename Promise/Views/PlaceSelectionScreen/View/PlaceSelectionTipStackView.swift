//
//  PlaceSelectionTipStackView.swift
//  Promise
//
//  Created by 신동오 on 2024/01/09.
//

import UIKit

final class PlaceSelectionTipStackView: UIStackView {
    
    // MARK: Private Property
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 12)
        return label
    }()
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 12)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: Initializer
    
    init(title: String, description: String) {
        super.init(frame: .zero)
        
        nameLabel.text = title
        detailLabel.text = description
        
        [nameLabel, detailLabel].forEach { addArrangedSubview($0) }
        
        axis = .vertical
        distribution = .fillEqually
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
