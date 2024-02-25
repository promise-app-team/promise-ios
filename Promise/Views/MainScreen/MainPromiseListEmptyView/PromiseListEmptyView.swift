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
        let title = UILabel()
        title.numberOfLines = 0
        
        title.font = UIFont(font: FontFamily.Pretendard.regular, size: 20)
        title.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        
        title.attributedText = NSMutableAttributedString(
            string: L10n.Main.emptyPromisesTitle,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        
        let description = UILabel()
        description.numberOfLines = 0
        
        description.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        description.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        
        
        description.attributedText = NSMutableAttributedString(
            string: L10n.Main.emptyPromisesDescription,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
        )
        
        title.translatesAutoresizingMaskIntoConstraints = false
        description.translatesAutoresizingMaskIntoConstraints = false
        
        let emptyTextWrapper = UIView()
        [title, description].forEach{ emptyTextWrapper.addSubview($0) }
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: emptyTextWrapper.topAnchor),
            title.leadingAnchor.constraint(equalTo: emptyTextWrapper.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: emptyTextWrapper.trailingAnchor),
            
            description.topAnchor.constraint(equalTo: title.bottomAnchor, constant: adjustedValue(4, .height)),
            description.centerXAnchor.constraint(equalTo: emptyTextWrapper.centerXAnchor),
            description.bottomAnchor.constraint(equalTo: emptyTextWrapper.bottomAnchor)
        ])
        
        // MARK: 정렬은 view에 추가된 이후에 가능(부모를 기준으로 정렬하기 때문)
        title.textAlignment = .center
        description.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [
            emptyPromisesImage,
            emptyTextWrapper
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
