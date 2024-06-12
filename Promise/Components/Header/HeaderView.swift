//
//  HeaderViewDelegate.swift
//  Promise
//
//  Created by dylan on 2023/10/03.
//

import Foundation
import UIKit

@objc protocol HeaderViewDelegate: AnyObject {
    @objc optional func onTapLeftView() -> Void
    @objc optional func onTapRightView() -> Void
}

class HeaderView: UIView {
    weak var navigationController: UINavigationController?
    weak var delegate: HeaderViewDelegate?
    
    var isHiddenLeftView = false {
        didSet {
            leftView.isHidden = isHiddenLeftView
        }
    }
    var isHiddenRightView = true {
        didSet {
            rightView.isHidden = isHiddenRightView
        }
    }
    
    private let title = {
        let label = UILabel()
        
        label.text = ""
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width))
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var leftViewIcon = {
        let imageView = UIImageView(image: Asset.arrowLeft.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: adjustedValue(24, .width)),
            imageView.heightAnchor.constraint(equalToConstant: adjustedValue(24, .height)),
        ])
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var rightViewIcon = {
        let imageView = UIImageView(image: Asset.close.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: adjustedValue(24, .width)),
            imageView.heightAnchor.constraint(equalToConstant: adjustedValue(24, .height)),
        ])
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var leftView = {
        let view = UIView()
        view.addSubview(leftViewIcon)
        NSLayoutConstraint.activate([
            leftViewIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(16, .width)),
            leftViewIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapLeftView))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        view.isHidden = isHiddenLeftView
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rightView = {
        let view = UIView()
        view.addSubview(rightViewIcon)
        NSLayoutConstraint.activate([
            rightViewIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(16, .width)),
            rightViewIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapRightView))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        view.isHidden = isHiddenRightView
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc func onTapLeftView() {
        if let onTapLeftView = delegate?.onTapLeftView {
            onTapLeftView()
            return
        }
        
        // default: go back
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onTapRightView() {
        if let onTapRightView = delegate?.onTapRightView {
            onTapRightView()
            return
        }
    }
    
    init(navigationController: UINavigationController?, title: String, isHiddenLeftView: Bool = false, isHiddenRightView: Bool = true) {
        self.navigationController = navigationController
        self.title.text = title
        self.isHiddenLeftView = isHiddenLeftView
        self.isHiddenRightView = isHiddenRightView
        super.init(frame: .null)
        configure()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: adjustedValue(56, .height)).isActive = true
    }
    
    private func render() {
        [leftView, title, rightView].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            leftView.topAnchor.constraint(equalTo: topAnchor),
            leftView.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftView.bottomAnchor.constraint(equalTo: bottomAnchor),
            leftView.widthAnchor.constraint(equalToConstant: adjustedValue(16 + 24 + 16, .width)),
            
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            rightView.topAnchor.constraint(equalTo: topAnchor),
            rightView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightView.widthAnchor.constraint(equalToConstant: adjustedValue(16 + 24 + 16, .width)),
        ])
    }
}
