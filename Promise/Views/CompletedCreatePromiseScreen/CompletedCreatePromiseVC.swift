//
//  CompletedCreatePromiseVC.swift
//  Promise
//
//  Created by dylan on 2023/10/01.
//

import Foundation
import UIKit

class CompletedCreatePromiseVC: UIViewController {
    private let headerView = CompletedCreatePromiseHeaderView()
    
    private var mainTitle: UILabel = {
        let fontSize: CGFloat = 24.0
        let desiredLineHeight: CGFloat = 36.0
        
        let font = UIFont(font: FontFamily.Pretendard.bold, size: fontSize)!
        let actualLineHeight = font.lineHeight
        
        let lineSpacing = desiredLineHeight - actualLineHeight
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let text = L10n.CompletedCreatePromise.mainTitle
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([
            .paragraphStyle: paragraphStyle,
            .font: font,
            .foregroundColor: UIColor.black,
        ], range: NSMakeRange(0, attributedString.length))
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = attributedString
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let screenshotMain = {
        let imageView = UIImageView(image: Asset.main.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let screenshotMap = {
        let imageView = UIImageView(image: Asset.map.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var mainDescription: UILabel = {
        let fontSize: CGFloat = 16.0
        let desiredLineHeight: CGFloat = 24.0
        
        let font = UIFont(font: FontFamily.Pretendard.regular, size: fontSize)!
        let actualLineHeight = font.lineHeight
        
        let lineSpacing = desiredLineHeight - actualLineHeight
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let text = L10n.CompletedCreatePromise.mainDescription
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([
            .paragraphStyle: paragraphStyle,
            .font: font,
            .foregroundColor: UIColor.black,
        ], range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(
            .font,
            value: UIFont(font: FontFamily.Pretendard.bold, size: fontSize)!,
            range: (text as NSString).range(of: L10n.CompletedCreatePromise.MainDescription.highlight)
        )
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = attributedString
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var confirmButton = {
        let button = Button()
        button.initialize(
            title: L10n.Common.confirm,
            style: .secondary,
            iconTitle: "",
            disabled: false
        )
        
        button.addTarget(self, action: #selector(onTapConfirmButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var shareButton = {
        let button = Button()
        button.initialize(
            title: L10n.CompletedCreatePromise.shareButtonText,
            style: .primary,
            iconTitle: "",
            disabled: false
        )
        
        button.addTarget(self, action: #selector(onTapShareButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var buttonsWrapper = {
        let stackView = UIStackView(arrangedSubviews: [
            confirmButton,
            shareButton
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func setupAutoLayout() {
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        let mainTitleFormHeaderSpacingRatio = (view.frame.height > 850 ? CGFloat(24) : CGFloat(10)) / CGFloat(852)
        let mainTitleFormHeaderSpacing = view.frame.height * mainTitleFormHeaderSpacingRatio
        
        let imageWidthRatio = CGFloat(345) / CGFloat(393)
        let imageHeightRatio = CGFloat(209) / CGFloat(852)
        
        let imageWidth = view.frame.width * imageWidthRatio
        let imageHeight = view.frame.height * imageHeightRatio
        
        let spacingBetweenMainToMapRatio = CGFloat(20) / CGFloat(852)
        let spacingBetweenMainToMap = view.frame.height * spacingBetweenMainToMapRatio
        
        let mainDescriptionFormHeaderSpacingRatio = CGFloat(30) / CGFloat(852)
        let mainDescriptionFormHeaderSpacing = view.frame.height * mainDescriptionFormHeaderSpacingRatio
        
        let safeareaBottomSpacingRatio = CGFloat(10) / CGFloat(852)
        let safeareaBottomSpacing = view.frame.height * safeareaBottomSpacingRatio
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 56),
            headerView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainTitle.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: mainTitleFormHeaderSpacing),
            mainTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            screenshotMain.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenshotMain.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            
            screenshotMain.widthAnchor.constraint(equalToConstant: imageWidth),
            screenshotMain.heightAnchor.constraint(equalToConstant: imageHeight),
            
            screenshotMap.topAnchor.constraint(equalTo: view.centerYAnchor, constant: spacingBetweenMainToMap),
            screenshotMap.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            screenshotMap.widthAnchor.constraint(equalToConstant: imageWidth),
            screenshotMap.heightAnchor.constraint(equalToConstant: imageHeight),
            
            mainDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mainDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            mainDescription.bottomAnchor.constraint(equalTo: buttonsWrapper.topAnchor, constant: -mainDescriptionFormHeaderSpacing),
            
            buttonsWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            buttonsWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            buttonsWrapper.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -safeareaBottomSpacing),
            buttonsWrapper.heightAnchor.constraint(equalToConstant: Button.Height + 3),
        ])
    }
    
    @objc private func onTapConfirmButton() {
        guard let viewControllers = navigationController?.viewControllers else { return }
        
        for controller in viewControllers {
            if controller is MainVC {
                navigationController?.popToViewController(controller, animated: true)
                break
            }
        }
        
        // Root로 이동하는 방법(앱은 항상 MainVC가 루트):
        // navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func onTapShareButton() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAccountVC()
        render()
    }
    
    func configureAccountVC() {
        view.backgroundColor = .white
    }
    
    func render() {
        [headerView, mainTitle, screenshotMain, screenshotMap, mainDescription, buttonsWrapper].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
}
