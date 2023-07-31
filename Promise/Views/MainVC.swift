//
//  ViewController.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import UIKit

final class MainVC: UIViewController {
    private let tokenLabel = {
        let label = UILabel()
        let user = UserService.shared.getUser()
        var text = ""
        
        if let nickname = user?.nickname, let profileUrl = user?.profileUrl {
            text = nickname
        }
        
        label.text = "Your nickname is:\n\n\(text)"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainPageLabel = {
        let label = UILabel()
        
        label.text = L10n.Common.promise
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 1, green: 0.41, blue: 0.3, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 12
        button.backgroundColor = UIColor(red: 0.51, green: 0.87, blue: 0.81, alpha: 1)
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(onTapSignOutButton), for: .touchUpInside)
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc private func onTapSignOutButton() {
        UserService.shared.signOut(currentVC: self)
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            mainPageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            mainPageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mainPageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        
        NSLayoutConstraint.activate([
            tokenLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            tokenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            tokenLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        
        NSLayoutConstraint.activate([
            signOutButton.heightAnchor.constraint(equalToConstant: 48),
            signOutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            signOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            signOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainView()
        render()
    }
    
    func configureMainView() {
        view.backgroundColor = .white
    }
    
    private func render() {
        [mainPageLabel, tokenLabel, signOutButton].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
}

