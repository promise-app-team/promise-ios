//
//  MainVC.swift
//  Promise
//
//  Created by 신동오 on 2023/07/26.
//

import UIKit

final class MainVC: UIViewController {
    
    // MARK: - Private property
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = ZoomAndSnapFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
    }
    
    // MARK: - Private function
    
    private func configureHierarchy() {
        view.addSubview(collectionView)
    }
}

// MARK: - Extension: UICollectionViewDataSource

extension MainVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
        
        return cell
    }
}

