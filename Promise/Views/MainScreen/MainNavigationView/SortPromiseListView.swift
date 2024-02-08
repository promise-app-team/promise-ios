//
//  SortPromiseListView.swift
//  Promise
//
//  Created by dylan on 2023/08/04.
//

import Foundation
import UIKit

class SortPromiseListView: UIStackView {
    private var mainVM: MainVM
    
    var disabled: Bool = true {
        didSet {
            guard disabled else {
                layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
                sortTitle.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                sortIcon.image = Asset.arrowDown.image
                
                return
            }
            
            layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
            sortTitle.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            sortIcon.image = Asset.arrowDownLight.image
        }
    }
    
    let sortTitle = {
        let label = UILabel()
        
        label.text = "약속시간 빠른순" // TODO: 모달에서 선택한 텍스트로 변경
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width))
        label.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // TODO: 모달 열리면 반대 방향 아이콘으로 변경
    let sortIcon = {
        let imageView = UIImageView(image: Asset.arrowDownLight.image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: adjustedValue(24, .width)),
            imageView.heightAnchor.constraint(equalToConstant: adjustedValue(24, .height)),
        ])
        
        return imageView
    }()
    
    init(mainVM: MainVM) {
        self.mainVM = mainVM
        super.init(frame: .null)
        
        configureSortPromiseListView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSortPromiseListView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(
            top: adjustedValue(6, .height),
            left: adjustedValue(16, .width),
            bottom: adjustedValue(6, .height),
            right: adjustedValue(12, .width)
        )

        
        axis = .horizontal
        alignment = .center
        spacing = 4
        
        [sortTitle, sortIcon].forEach { addArrangedSubview($0) }
    }
}
