//
//  CommonFloatingContentViewController.swift
//  Promise
//
//  Created by Sun on 2023/07/02.
//

import Foundation
import UIKit

class CommonFloatingContentVC: UIViewController {
    
    var smallViewHeightConstraint: NSLayoutConstraint!
    let smallviewHeight: CGFloat = CommonFloatingContainerVC.minHeight
    
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
        
        smallViewHeightConstraint = halfView.heightAnchor.constraint(equalToConstant: smallviewHeight)
        smallViewHeightConstraint.isActive = true
        
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
    public func hideHalfView() {
        
    }
    
    public func showHalfView() {
        
    }
    
    public func hideFullView() {
        
    }
    
    public func showFullView() {
        
    }
    
    public func updateHalfViewHeight(height: CGFloat) {
        smallViewHeightConstraint.constant = height
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}
