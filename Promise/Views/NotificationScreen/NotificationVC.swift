//
//  NotificationVC.swift
//  Promise
//
//  Created by dylan on 2023/08/14.
//

import Foundation
import UIKit

class NotificationVC: UIViewController {
    let screenTitle = {
        let label = UILabel()
        label.text = "알림 화면을 구현해주세요."
        label.font = UIFont(font: FontFamily.Pretendard.semiBold, size: 15)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNotificationVC()
        render()
    }
    
    func configureNotificationVC() {
        view.backgroundColor = .white
    }
    
    func render() {
        [screenTitle].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
}
