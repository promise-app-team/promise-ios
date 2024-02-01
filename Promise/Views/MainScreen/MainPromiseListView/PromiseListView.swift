//
//  PromiseListView.swift
//  Promise
//
//  Created by dylan on 2023/08/06.
//

import Foundation
import UIKit

final class PromiseListView: UICollectionView {
    private var mainVM: MainVM
    
    init(dataSource: UICollectionViewDataSource & MainVC, delegate: UICollectionViewDelegate, layout: UICollectionViewLayout) {
        self.mainVM = dataSource.mainVM
        
        super.init(frame: .null, collectionViewLayout: layout)
        
        self.dataSource = dataSource
        self.delegate = delegate
        
        register(PromiseListCell.self, forCellWithReuseIdentifier: "cell")
        decelerationRate = .fast
        contentInsetAdjustmentBehavior = .always
        showsHorizontalScrollIndicator = false
        
        configurePromiseListView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePromiseListView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
    }
}
