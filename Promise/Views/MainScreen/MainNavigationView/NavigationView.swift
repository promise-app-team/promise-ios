//
//  NavigationView.swift
//  Promise
//
//  Created by dylan on 2023/08/06.
//

import Foundation
import UIKit

final class NavigationView: UIView {
    private var mainVM: MainVM
    
    var disabledSortPromiseList: Bool = true {
        didSet {
             sortPromiseListView.disabled = disabledSortPromiseList
        }
    }
    
    private lazy var navigation = NavigationMenusView(mainVM: mainVM)
    
    private lazy var sortPromiseListView = {
        let sortView = SortPromiseListView(mainVM: mainVM)
        sortView.delegate = mainVM
        return sortView
    }()
    
    init(mainVM: MainVM) {
        self.mainVM = mainVM
        super.init(frame: .null)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.zPosition = 1
        translatesAutoresizingMaskIntoConstraints = false
        
        [navigation, sortPromiseListView].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            navigation.centerYAnchor.constraint(equalTo: centerYAnchor),
            navigation.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            
            sortPromiseListView.centerYAnchor.constraint(equalTo: centerYAnchor),
            sortPromiseListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -adjustedValue(24, .width)),
        ])
    }
}

