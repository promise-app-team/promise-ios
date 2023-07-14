//
//  ViewController.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import UIKit

final class SignInVC: UIViewController {
    private lazy var signInVM = SignInVM()
    
    private lazy var signInButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            kakaoSignInButton,
            googleSignInButton,
            appleSignInButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var kakaoSignInButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(red: 0.996, green: 0.902, blue: 0.004, alpha: 1)
        button.setTitle("Kakao", for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0.004, alpha: 1), for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(onTapKakaoSignInButton), for: .touchUpInside)
        
        let shadowedButton = setShadow(button)
        shadowedButton.translatesAutoresizingMaskIntoConstraints = false
        return shadowedButton
    }()
    
    private lazy var googleSignInButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitle("Google", for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0.004, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let shadowedButton = setShadow(button, shouldCornerRadius: true)
        
        //MARK: 탭 이벤트
        // shadowedButton.addTarget(self, action: #selector(googleSignInButtonTapped), for: .touchUpInside)
        
        shadowedButton.translatesAutoresizingMaskIntoConstraints = false
        return shadowedButton
    }()
    
    private lazy var appleSignInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitle("Apple", for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0.004, alpha: 1), for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let shadowedButton = setShadow(button, shouldCornerRadius: true)
        
        
        //MARK: 탭 이벤트
        // shadowedButton.addTarget(self, action: #selector(appleSignInButtonTapped), for: .touchUpInside)
        
        shadowedButton.translatesAutoresizingMaskIntoConstraints = false
        return shadowedButton
    }()
    
    private let guidanceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "로그인 수단 선택"
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 140/255, green: 140/255, blue: 140/255, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        // paragraphStyle.lineHeightMultiple = 1.42
        paragraphStyle.lineSpacing = CGFloat(60 / 4)
        
        let text = "ㅗ프라인 약속은\n프로미스에서!"
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 35, weight: .heavy),
            .foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1),
        ], range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0/255, green: 192/255, blue: 135/255, alpha: 1), range: (text as NSString).range(of: "프로미스"))
        
        label.attributedText = attributedString
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.text = "만나기 전에 서로의 위치를 공유해보세요."
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(red: 0.412, green: 0.412, blue: 0.412, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setShadow(_ button: UIButton, shouldCornerRadius: Bool = false) -> UIButton {
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 2
        
        if(shouldCornerRadius) {
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
            
            return button
        }
        
        return button
    }
    
    private func setupAutoLayout() {
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 158),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 29),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -29),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 29),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -29),
        ])
        
        NSLayoutConstraint.activate([
            guidanceLabel.bottomAnchor.constraint(equalTo: signInButtonsStackView.topAnchor, constant: -18),
            guidanceLabel.centerXAnchor.constraint(equalTo: signInButtonsStackView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signInButtonsStackView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -70),
            signInButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signInButtonsStackView.heightAnchor.constraint(equalToConstant: 202),
        ])
    }
    
    @objc func onTapKakaoSignInButton() {
        signInVM.handleKakaoSignIn(currentVC: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainVIew()
        render()
    }
    
    private func configureMainVIew() {
        view.backgroundColor = .white
    }
    
    private func render() {
        [titleLabel, descriptionLabel, guidanceLabel, signInButtonsStackView].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
}

