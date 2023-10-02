//
//  PromiseListCell.swift
//  Promise
//
//  Created by dylan on 2023/08/04.
//

import Foundation
import UIKit

class PromiseListCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
    }
    
    func updateBorder(focusRatio: CGFloat) {
        let borderWidth: CGFloat = 1
        let focusedColor: UIColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
        let unfocusedColor: UIColor = .clear
        
        contentView.layer.borderWidth = borderWidth * focusRatio
        contentView.layer.borderColor = UIColor.transition(from: unfocusedColor, to: focusedColor, with: focusRatio).cgColor
    }
}
