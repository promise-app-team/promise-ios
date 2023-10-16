//
//  HeaderViewDelegate.swift
//  Promise
//
//  Created by dylan on 2023/10/03.
//

import Foundation
import UIKit

@objc protocol HeaderViewDelegate: AnyObject {
    @objc optional func mountLeftView() -> UIView
    @objc optional func mountRightView() -> UIView
    
    @objc optional func onTapCustomBackAction() -> Void
}

class HeaderView: UIView {
    weak var navigationController: UINavigationController?
    weak var delegate: HeaderViewDelegate?
    
    var isHiddenGoBackButton = false
    
    private let title = {
        let label = UILabel()
        
        label.text = ""
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var goBackButton = {
        let imageView = UIImageView(image: Asset.arrowLeft.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        imageView.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapGoBackButton))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        imageView.isHidden = isHiddenGoBackButton
        return imageView
    }()
    
    private lazy var leftView = {
        if let mountLeftView = delegate?.mountLeftView {
            let leftView = mountLeftView()
            leftView.translatesAutoresizingMaskIntoConstraints = false
            return leftView
        }
        
        // default: go back
        return goBackButton
    }()
    
    private lazy var rightView = {
        if let mountRightView = delegate?.mountRightView {
            let rightView = mountRightView()
            rightView.translatesAutoresizingMaskIntoConstraints = false
            return rightView
        }
        
        // default: empty
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func onTapGoBackButton() {
        if let onTapCustomBackAction = delegate?.onTapCustomBackAction {
            onTapCustomBackAction()
            return
        }
        
        // default: go back
        navigationController?.popViewController(animated: true)
    }
    
    init(navigationController: UINavigationController?, title: String, isHiddenGoBackButton: Bool = false) {
        self.navigationController = navigationController
        self.title.text = title
        self.isHiddenGoBackButton = isHiddenGoBackButton
        
        super.init(frame: .null)
        configureHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHeaderView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [leftView, title, rightView].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            leftView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            leftView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            rightView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            rightView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
