//
//  MainVM.swift
//  Promise
//
//  Created by dylan on 2023/08/06.
//

import Foundation
import UIKit
import FloatingPanel

class MainVM: NSObject {
    var currentVC: UIViewController?
    private var previousFocusedIndexPath: IndexPath?
    
    // 데이터 소스에 필요한 데이터, 예를 들어, 프로미스 목록 등
    private var items: [PromiseMDL] = [] // PromiseItem은 적절한 모델 클래스라고 가정

    init(currentVC: UIViewController? = nil) {
        self.currentVC = currentVC
    }
    
    // 데이터 로드 및 변환 로직
    func fetchData() {
        // 서버 데이터를 가져와 items에 저장
    }
    
    
    func navigateAccountScreen() {
        DispatchQueue.main.async {[weak self] in
            let accountVC = AccountVC()
            self?.currentVC?.navigationController?.pushViewController(accountVC, animated: true)
        }
    }
    
    
    func navigateNotificationScreen() {
        DispatchQueue.main.async {[weak self] in
            let notificationVC = NotificationVC()
            self?.currentVC?.navigationController?.pushViewController(notificationVC, animated: true)
        }
    }
    
    func navigateCreatePromiseScreen() {
        DispatchQueue.main.async {[weak self] in
            let createPromiseVC = CreatePromiseVC()
            self?.currentVC?.navigationController?.pushViewController(createPromiseVC, animated: true)
        }
    }
}

extension MainVM: UICollectionViewDataSource, UICollectionViewDelegate, FloatingPanelControllerDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PromiseListCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let promiseCell = cell as? PromiseListCell {
            // 첫 번째로 표시되는 셀에 테두리 적용
            if indexPath.row == 0 {
                promiseCell.updateBorder(focusRatio: 1)
            }
        }
    }
    
    // UICollectionViewDataSource 프로토콜을 구현
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return items.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PromiseListCell
//
//        let item = items[indexPath.row]
//        // 셀에 데이터를 설정
//        // 예: cell.configure(with: item)
//        return cell
//    }
}
