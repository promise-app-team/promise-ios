//
//  PromiseListEmptyView.swift
//  Promise
//
//  Created by kwh on 1/29/24.
//

import Foundation
import UIKit

class PromiseListEmptyView: UIView {
    private var mainVM: MainVM
    
    private let emptyPromisesImage = {
        let imageView = UIImageView(image: Asset.emptyPromises.image)
        
        let screenWidth = UIScreen.main.bounds.width
        let imageViewWidthRatio = CGFloat(180) / CGFloat(393)
        let imageViewWidth = screenWidth * imageViewWidthRatio
        
        let screenHeight = UIScreen.main.bounds.height
        let imageViewHeightRatio = CGFloat(258) / CGFloat(852)
        let imageViewHeight = screenHeight * imageViewHeightRatio
        
        imageView.widthAnchor.constraint(equalToConstant: imageViewWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageViewHeight).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var emptyPromisesWrap = {
        let label = UILabel()
        label.numberOfLines = 0
        
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 20)
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        label.textAlignment = .center
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        
        label.attributedText = NSMutableAttributedString(
            string: L10n.Main.emptyPromisesTitle,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        
        let stackView = UIStackView(arrangedSubviews: [
            emptyPromisesImage,
            label
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var promiseAddButton = {
        let button = Button()
        button.initialize(title: L10n.Main.addNewPromise, style: .primary, iconTitle: Asset.circleOutlinePlusWhite.name)
        
        button.addTarget(self, action: #selector(onTapPromiseAddButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: handler
    
    @objc private func onTapPromiseAddButton() {
        mainVM.navigateCreatePromiseScreen()
    }
    
    // MARK: initialize
    
    init(mainVM: MainVM) {
        self.mainVM = mainVM
        super.init(frame: .null)
        
        configurePromiseListEmptyView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePromiseListEmptyView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [emptyPromisesWrap, promiseAddButton].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            emptyPromisesWrap.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -50),
            emptyPromisesWrap.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            promiseAddButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            promiseAddButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            promiseAddButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            promiseAddButton.heightAnchor.constraint(equalToConstant: Button.Height),
        ])
    }
}
