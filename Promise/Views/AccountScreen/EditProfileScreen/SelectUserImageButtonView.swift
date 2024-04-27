//
//  SelectUserImageView.swift
//  Promise
//
//  Created by zzee22su on 4/14/24.
//

import UIKit

import UIKit

class SelectUserImageButtonView: UIView {
    
    let contentView: UIView = {
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
        //        button.addTarget(self, action: #selector(albumButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var defaultImageButton: UIButton = {
        let button = UIButton()
        button.setTitle(L10n.Account.EditProfile.SelectUserImage.default, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font =  UIFont.pretendard(style: .B1_R)
        //        button.addTarget(self, action: #selector(defaultImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var cancelButton: Button = {
        let button = Button()
        button.initialize(title: L10n.Common.cancel, style: .secondary, iconTitle: "", disabled: false)
        //        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(contentView)
        [albumButton, defaultImageButton, cancelButton].forEach { contentView.addSubview($0) }
    }
    
    private func setupConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        [albumButton, defaultImageButton, cancelButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor, constant: -48),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 68),
            contentView.widthAnchor.constraint(equalToConstant: 393),
            contentView.heightAnchor.constraint(equalToConstant: 191),
            
            albumButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            albumButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            albumButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            albumButton.heightAnchor.constraint(equalToConstant: 24),
            
            defaultImageButton.topAnchor.constraint(equalTo: albumButton.bottomAnchor, constant: 16),
            defaultImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            defaultImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            defaultImageButton.heightAnchor.constraint(equalToConstant: 24),
            
            cancelButton.topAnchor.constraint(equalTo: defaultImageButton.bottomAnchor, constant: 24),
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            cancelButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
