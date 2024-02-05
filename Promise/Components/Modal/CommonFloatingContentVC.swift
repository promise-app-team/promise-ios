//
//  CommonFloatingContentViewController.swift
//  Promise
//
//  Created by Sun on 2023/07/02.
//

import Foundation
import UIKit

class CommonFloatingContentVC: UIViewController {
    
    var halfViewHeightConstraint: NSLayoutConstraint!
    let halfViewHeight: CGFloat = CommonFloatingContainerVC.minHeight
    
    lazy var halfView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var fullView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setViewLayout()
    }
    
    private func setViewLayout(){
        view.addSubview(halfView)
        view.addSubview(fullView)
        
        halfView.translatesAutoresizingMaskIntoConstraints = false
        fullView.translatesAutoresizingMaskIntoConstraints = false
        
        halfViewHeightConstraint = halfView.heightAnchor.constraint(equalToConstant: halfViewHeight)
        halfViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            halfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            halfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            halfView.topAnchor.constraint(equalTo: view.topAnchor),
            halfView.bottomAnchor.constraint(equalTo: fullView.topAnchor),
            
            fullView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             
            fullView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension CommonFloatingContentVC {
    public func updateHalfViewHeight(height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.halfViewHeightConstraint.constant = height
            self.view.layoutIfNeeded() // 레이아웃을 즉시 업데이트
            // self.view.setNeedsLayout // 레이아웃 업데이트 예약(다음 사이클에서 레이아웃 업데이트)
        }
    }
}
