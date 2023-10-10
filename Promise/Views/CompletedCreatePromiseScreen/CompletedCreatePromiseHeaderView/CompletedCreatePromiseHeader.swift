//
//  CompletedCreatePromiseHeader.swift
//  Promise
//
//  Created by dylan on 2023/10/01.
//

import Foundation
import UIKit

final class CompletedCreatePromiseHeaderView: UIView {
    private let title = {
        let label = UILabel()
        label.text = L10n.CompletedCreatePromise.headerTitle
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .null)
        configureHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHeaderView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [title].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
