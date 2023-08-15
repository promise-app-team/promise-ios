//
//  HeaderSort.swift
//  Promise
//
//  Created by dylan on 2023/08/04.
//

import Foundation
import UIKit

class HeaderSortPromiseList: UIStackView {
    private var mainVM: MainVM
    
    let sortTitle = {
        let label = UILabel()
        label.text = "약속시간 빠른순" // TODO: 모달에서 선택한 텍스트로 변경
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // TODO: 모달 열리면 반대 방향 아이콘으로 변경
    let sortIcon = {
        let imageView = UIImageView(image: Asset.arrowDown.image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        return imageView
    }()
    
    init(mainVM: MainVM) {
        self.mainVM = mainVM
        super.init(frame: .null)
        
        configureHeaderSortPromiseList()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeaderSortPromiseList() {
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 6, left: 16, bottom: 6, right: 12)

        
        axis = .horizontal
        alignment = .center
        spacing = 4
        
        [sortTitle, sortIcon].forEach { addArrangedSubview($0) }
    }
}
