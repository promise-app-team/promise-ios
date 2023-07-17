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
    
    private let textFieldWrapper = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 12
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.textColor = .black
        
        let placeholderColor = UIColor.lightGray
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderColor,
        ]

        let attributedPlaceholder = NSAttributedString(
            string: "Ping 보낼 메시지 입력",
            attributes: placeholderAttributes
        )

        textField.attributedPlaceholder = attributedPlaceholder
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        textField.delegate = self

        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var emitButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
        button.setTitle("Emit", for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0.004, alpha: 1), for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.addTarget(self, action: #selector(onTapEmitButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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
            textFieldWrapper.topAnchor.constraint(equalTo: tokenLabel.bottomAnchor, constant: 25),
            textFieldWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textFieldWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            textFieldWrapper.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: textFieldWrapper.topAnchor, constant: 2),
            textField.leadingAnchor.constraint(equalTo: textFieldWrapper.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: textFieldWrapper.trailingAnchor, constant: -16),
            textField.bottomAnchor.constraint(equalTo: textFieldWrapper.bottomAnchor, constant: -2)
        ])
        
        NSLayoutConstraint.activate([
            emitButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            emitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            emitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            emitButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func onTapEmitButton() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        SocketService.shared.emitEvent(message: textField.text)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocketService.shared.connectToServer()
        configureMainView()
        render()
    }
    
    func configureMainView() {
        view.backgroundColor = .white
    }
    
    private func render() {
        [mainPageLabel, tokenLabel, emitButton, textFieldWrapper, textField].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
}

extension MainVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 사용자가 Return 키를 누르면 키보드를 숨깁니다.
        textField.resignFirstResponder()
        return true
    }
}

