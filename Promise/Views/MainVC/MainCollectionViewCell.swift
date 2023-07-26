//
//  MainCollectionViewCell.swift
//  Promise
//
//  Created by 신동오 on 2023/07/26.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemPink
        contentView.layer.cornerRadius = 20
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
