//
//  EditProfileVC.swift
//  Promise
//
//  Created by zzee22su on 2023/10/14.
//

import UIKit

class EditProfileVC: UIViewController {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "프로필 수정"
        label.textColor = .black
        label.font = UIFont.pretendard(style: .H1_B)
        label.textAlignment = .center
        return label
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        configureAccountVC()
        render()
        
        if #available(iOS 11.0, *) {
                additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                view.backgroundColor = .white
            }
    }
           
    func configureAccountVC() {
        view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
    }
    
    func render() {
        [label].forEach { view.addSubview($0) }
        [label].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        setupAutoLayout()
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 253),
            label.heightAnchor.constraint(equalToConstant: 36),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }

}
