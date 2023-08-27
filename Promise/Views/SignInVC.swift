//
//  ViewController.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import UIKit

class SignInButtonWithLogoImage: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(
            x: 12,
            y: (frame.height - imageView.frame.height) / 2,
            width: imageView.frame.width,
            height: imageView.frame.height
        )
        
        
        let titleX = (bounds.width - titleLabel.bounds.width) / 2
        let titleY = (bounds.height - titleLabel.bounds.height) / 2
        titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleLabel.bounds.width, height: titleLabel.bounds.height)
    }
}

final class SignInVC: UIViewController {
    private lazy var signInVM = SignInVM(currentVC: self)
    
    private lazy var signInButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            kakaoSignInButton,
            googleSignInButton,
            appleSignInButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var kakaoSignInButton: UIButton = {
        let button = SignInButtonWithLogoImage()
        
        button.backgroundColor = UIColor(red: 0.992, green: 0.925, blue: 0.314, alpha: 1)
        button.setTitle(L10n.SignIn.kakaoSignInButtonText, for: .normal)
        button.setTitleColor(UIColor(red: 0.243, green: 0.153, blue: 0.137, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(font: FontFamily.Pretendard.semiBold, size: 15)
        
        button.layer.cornerRadius = 20
        
        let logoImage = Asset.kakaoLogo.image.resize(newSize: CGSize(width: 21.25, height: 20))
        button.setImage(logoImage, for: .normal)
        
        button.addTarget(self, action: #selector(onTapKakaoSignInButton), for: .touchUpInside)
   
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var googleSignInButton: UIButton = {
        let button = SignInButtonWithLogoImage()
        
        button.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.setTitle(L10n.SignIn.googleSignInButtonText, for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(font: FontFamily.Pretendard.semiBold, size: 15)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        button.layer.cornerRadius = 20
        
        let logoImage = Asset.googleLogo.image.resize(newSize: CGSize(width: 20, height: 20))
        button.setImage(logoImage, for: .normal)
        
        button.addTarget(self, action: #selector(onTapGoogleSignInButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var appleSignInButton: UIButton = {
        let button = SignInButtonWithLogoImage()
        
        button.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        button.setTitle(L10n.SignIn.appleSignInButtonText, for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont(font: FontFamily.Pretendard.semiBold, size: 15)
        
        button.layer.cornerRadius = 20
        
        let logoImage = Asset.appleLogo.image.resize(newSize: CGSize(width: 20, height: 20))
        button.setImage(logoImage, for: .normal)
        
        button.addTarget(self, action: #selector(onTapAppleSignInButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let logo: UIImageView = {
        let imageView = UIImageView(image: Asset.promiseLogo.image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = L10n.SignIn.mainDescription
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 15)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupAutoLayout() {
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor, constant: 88),
            logo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 84),
            logo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -84),
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 5),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            kakaoSignInButton.heightAnchor.constraint(equalToConstant: 40),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 40),
            appleSignInButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        NSLayoutConstraint.activate([
            signInButtonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            signInButtonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            signInButtonsStackView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -67),
        ])
    }
    
    @objc func onTapKakaoSignInButton() {
        signInVM.handleSignIn(method: .KAKAO)
    }
    
    @objc func onTapGoogleSignInButton() {
        signInVM.handleSignIn(method: .GOOGLE)
    }
    
    @objc func onTapAppleSignInButton() {
        signInVM.handleSignIn(method: .APPLE)
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
        [logo, descriptionLabel, signInButtonsStackView].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
}

