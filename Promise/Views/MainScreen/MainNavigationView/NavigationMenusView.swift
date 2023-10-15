//
//  NavigationMenusView.swift
//  Promise
//
//  Created by dylan on 2023/08/14.
//

import Foundation
import UIKit

class NavigationMenusView: UIStackView {
    private var mainVM: MainVM
    
    lazy var accountIcon = {
        let imageView = UIImageView(image: Asset.account.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        imageView.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapAccountIcon))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    lazy var notificationIcon = {
        let imageView = UIImageView(image: Asset.notification.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        imageView.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapNotificationIcon))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    @objc func onTapAccountIcon() {
        mainVM.navigateAccountScreen()
    }
    
    @objc func onTapNotificationIcon() {
        mainVM.navigateNotificationScreen()
    }
    
    init(mainVM: MainVM) {
        self.mainVM = mainVM
        super.init(frame: .null)
        
        configureNavigationMenusView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigationMenusView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        axis = .horizontal
        spacing = 16
        
        [accountIcon, notificationIcon].forEach { addArrangedSubview($0) }
    }
  
}
