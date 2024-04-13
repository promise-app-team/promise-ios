//
//  EditProfileVC.swift
//  Promise
//
//  Created by zzee22su on 2023/10/14.
//

import UIKit

class EditProfileVC: UIViewController {
    
    let editView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAccountVC()
        render()
        clickBackgroud()
    }

    func configureAccountVC() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    func render() {
        [editView].forEach { view.addSubview($0) }
        [editView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        setupAutoLayout()
    }
    
    func clickBackgroud() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(tapGesture)
    }

    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            editView.topAnchor.constraint(equalTo: view.topAnchor, constant: 259),
            editView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            editView.widthAnchor.constraint(equalToConstant: 345),
            editView.heightAnchor.constraint(equalToConstant: 334)
        ])
    }
    
    @objc func backgroundTapped() {
        dismiss(animated: true, completion: nil)
    }

}
