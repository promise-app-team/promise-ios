//
//  CommonFloatingContentViewController.swift
//  Promise
//
//  Created by Sun on 2023/07/02.
//

import Foundation
import UIKit

class CommonFloatingContentVC : UIViewController {
    
    var smallViewHeightConstraint: NSLayoutConstraint!
    let smallviewHeight: CGFloat = CommonFloatingContainerVC.minHeight
    
    lazy var smallView: UIView = {
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
        view.addSubview(smallView)
        view.addSubview(fullView)
        
        smallView.translatesAutoresizingMaskIntoConstraints = false
        fullView.translatesAutoresizingMaskIntoConstraints = false
        
        smallViewHeightConstraint = smallView.heightAnchor.constraint(equalToConstant: smallviewHeight)
        smallViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            smallView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            smallView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            smallView.topAnchor.constraint(equalTo: view.topAnchor),
            smallView.bottomAnchor.constraint(equalTo: fullView.topAnchor),
            
            fullView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fullView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             
            fullView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    public func updateHalfViewHeight(height: CGFloat) {
        smallViewHeightConstraint.constant = height
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
}
