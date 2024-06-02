//
//  PlaceSelectionSearchFailView.swift
//  Promise
//
//  Created by 신동오 on 5/11/24.
//

import UIKit

final class PlaceSelectionSearchFailView: UIView {
    
    // MARK: Private Property
    
    private let probee: UIImageView = {
        let imageView = UIImageView(image: Asset.probeeNoResult.image)
        return imageView
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
        
        addSubview(probee)
        probee.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            probee.centerXAnchor.constraint(equalTo: centerXAnchor),
            probee.topAnchor.constraint(equalTo: topAnchor, constant: adjustedValue(200, .height)),
            probee.widthAnchor.constraint(equalToConstant: adjustedValue(225, .width)),
        ])
    }
}
