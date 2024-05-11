//
//  CompletedCreatePromiseVC.swift
//  Promise
//
//  Created by dylan on 2023/10/01.
//

import Foundation
import UIKit

class CompletedCreatePromiseVC: UIViewController {
    var createdPromiseId: Int?
    
    private lazy var header = HeaderView(
        navigationController: self.navigationController,
        title: L10n.CompletedCreatePromise.headerTitle,
        isHiddenLeftView: true
    )
    
    private var mainTitle: UILabel = {
        let fontSize: CGFloat = adjustedValue(24, .width)
        let desiredLineHeight: CGFloat = adjustedValue(36, .height)
        
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
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(209, .height)).isActive = true
        return imageView
    }()
    
    private let screenshotMap = {
        let imageView = UIImageView(image: Asset.map.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(209, .height)).isActive = true
        return imageView
    }()
    
    private var mainDescription: UILabel = {
        let fontSize: CGFloat = adjustedValue(16, .width)
        let desiredLineHeight: CGFloat = adjustedValue(24, .height)
        
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
        stackView.spacing = adjustedValue(16, .width)
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: Button.Height).isActive = true
        return stackView
    }()
    
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
        guard let createdPromiseId else { return }
        let shareUrl = URL(string: "\(Config.universalLinkDomain)/share/\(createdPromiseId)")
        guard let shareUrl else { return }
        
        // UIActivityViewController 초기화
        let activityViewController = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)

        // iPad에서는 popover로 표시해야 할 수 있음
        activityViewController.popoverPresentationController?.sourceView = self.view

        // UIActivityViewController 표시
        self.present(activityViewController, animated: true, completion: nil)
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
        configure()
        render()
    }
    
    func configure() {
        view.backgroundColor = .white
    }
    
    func render() {
        [header, mainTitle, screenshotMain, screenshotMap, mainDescription, buttonsWrapper].forEach { view.addSubview($0) }
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainTitle.topAnchor.constraint(equalTo: header.bottomAnchor, constant: adjustedValue(8, .height)),
            mainTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            mainTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            
            screenshotMain.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: adjustedValue(24, .height)),
            screenshotMain.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            screenshotMain.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            
            screenshotMap.topAnchor.constraint(equalTo: screenshotMain.bottomAnchor, constant: adjustedValue(16, .height)),
            screenshotMap.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            screenshotMap.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            
            mainDescription.topAnchor.constraint(equalTo: screenshotMap.bottomAnchor, constant: adjustedValue(32, .height)),
            mainDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            mainDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            mainDescription.bottomAnchor.constraint(equalTo: buttonsWrapper.topAnchor, constant: -adjustedValue(28, .height)),
            
            buttonsWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            buttonsWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            buttonsWrapper.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -adjustedValue(16, .height))
        ])
    }
}
