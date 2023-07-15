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
        let token = UserService.shared.getAccessToken()
        
        label.text = "Your Access Token is:\n\n\(token!)"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainPageLabel = {
        let label = UILabel()
        
        label.text = "Main page"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 1, green: 0.41, blue: 0.3, alpha: 1)
        label.numberOfLines = 0
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        [mainPageLabel, tokenLabel].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
}

