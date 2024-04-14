//
//  SelectUserImageVC.swift
//  Promise
//
//  Created by zzee22su on 4/14/24.
//

import UIKit

class SelectUserImageVC: UIViewController {
    
    let modalView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()

    lazy var albumButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Account.EditProfile.SelectUserImage.album, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font =  UIFont.pretendard(style: .B1_R)
        button.addTarget(self, action: #selector(albumButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var defaultImageButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Account.EditProfile.SelectUserImage.default, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font =  UIFont.pretendard(style: .B1_R)
        button.addTarget(self, action: #selector(defaultImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: Button = {
        let button = Button()
        button.initialize(title: L10n.Common.cancel, style: .secondary, iconTitle: "", disabled: false)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
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
        [modalView, albumButton, defaultImageButton, cancelButton].forEach { view.addSubview($0) }
        [modalView, albumButton, defaultImageButton, cancelButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        setupAutoLayout()
    }
    
    func clickBackgroud() {
        let backgroundGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(backgroundGesture)
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            modalView.topAnchor.constraint(equalTo: view.topAnchor, constant: 662),
            modalView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            modalView.widthAnchor.constraint(equalToConstant: 393),
            modalView.heightAnchor.constraint(equalToConstant: 191),

            albumButton.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 24),
            albumButton.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 24),
            albumButton.widthAnchor.constraint(equalToConstant: 345),
            albumButton.heightAnchor.constraint(equalToConstant: 24),
            
            defaultImageButton.topAnchor.constraint(equalTo: albumButton.bottomAnchor, constant: 16),
            defaultImageButton.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 24),
            defaultImageButton.widthAnchor.constraint(equalToConstant: 345),
            defaultImageButton.heightAnchor.constraint(equalToConstant: 24),
            
            cancelButton.topAnchor.constraint(equalTo: defaultImageButton.bottomAnchor, constant: 24),
            cancelButton.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 24),
            cancelButton.widthAnchor.constraint(equalToConstant: 345),
            cancelButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func backgroundTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func albumButtonTapped() {
    }
    
    @objc private func defaultImageButtonTapped() {
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
