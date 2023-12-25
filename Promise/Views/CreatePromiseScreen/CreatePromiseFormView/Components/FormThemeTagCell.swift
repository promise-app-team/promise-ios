//
//  FormThemeTagView.swift
//  Promise
//
//  Created by dylan on 2023/09/21.
//

import Foundation
import UIKit

class FormThemeTagCell: UICollectionViewCell {
    static let identifier = "FormThemeTagCell"

    static func cellSize(for themeEntity: SelectableTheme) -> CGSize {
        let label = UILabel()
        
        label.text = themeEntity.theme
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        label.sizeToFit()
        
        let cellSize = CGSize(width: label.frame.width + 16, height: 28)
        return cellSize
    }
    
    private lazy var themeTag: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = false
        
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        label.textAlignment = .center

        label.layer.masksToBounds = true
        label.layer.cornerRadius = 14
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(themeTag)
        
        NSLayoutConstraint.activate([
            themeTag.topAnchor.constraint(equalTo: topAnchor),
            themeTag.bottomAnchor.constraint(equalTo: bottomAnchor),
            themeTag.leadingAnchor.constraint(equalTo: leadingAnchor),
            themeTag.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureFormThemeTagCell(with selectableTheme: SelectableTheme) {
        themeTag.text = selectableTheme.theme
        
        if(selectableTheme.isSelected) {
            themeTag.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            themeTag.textColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
            
            themeTag.layer.borderWidth = 1
            themeTag.layer.borderColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor
        } else {
            themeTag.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
            themeTag.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            
            themeTag.layer.borderWidth = 0
            themeTag.layer.borderColor = .none
        }
    }
    
    
}
