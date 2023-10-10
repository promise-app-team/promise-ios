//
//  MainHeaderView.swift
//  Promise
//
//  Created by dylan on 2023/08/06.
//

import Foundation
import UIKit

final class HeaderView: UIView {
    private var mainVM: MainVM
    
    private lazy var navigation = HeaderNavigation(mainVM: mainVM)
    private lazy var sortPromiseList = HeaderSortPromiseList(mainVM: mainVM)
    
    init(mainVM: MainVM) {
        self.mainVM = mainVM
        super.init(frame: .null)
        
        configureHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHeaderView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [navigation, sortPromiseList].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            navigation.centerYAnchor.constraint(equalTo: centerYAnchor),
            navigation.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            
            sortPromiseList.centerYAnchor.constraint(equalTo: centerYAnchor),
            sortPromiseList.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
        ])
    }
}

