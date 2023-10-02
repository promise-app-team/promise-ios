//
//  HeaderView.swift
//  Promise
//
//  Created by dylan on 2023/08/28.
//

import Foundation
import UIKit

final class CreatePromiseHeaderView: UIView {
    private var createPromiseVM: CreatePromiseVM
    
    private lazy var leftButton = {
        let imageView = UIImageView(image: Asset.arrowLeft.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        imageView.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapLeftButton))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let title = {
        let label = UILabel()
        label.text = L10n.CreatePromise.headerTitle
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc func onTapLeftButton() {
        createPromiseVM.goBack()
    }
    
    init(vm: CreatePromiseVM) {
        createPromiseVM = vm
        super.init(frame: .null)
        configureHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHeaderView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [leftButton, title].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            leftButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
