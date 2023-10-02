//
//  PromiseListView.swift
//  Promise
//
//  Created by dylan on 2023/08/06.
//

import Foundation
import UIKit

final class PromiseListView: UICollectionView {
    init(dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        super.init(frame: .null, collectionViewLayout: PromiseListLayout())
        
        self.dataSource = dataSource
        self.delegate = delegate
        
        decelerationRate = .fast
        contentInsetAdjustmentBehavior = .always
        backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)

        showsHorizontalScrollIndicator = false
        
        register(PromiseListCell.self, forCellWithReuseIdentifier: "cell")
        
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
