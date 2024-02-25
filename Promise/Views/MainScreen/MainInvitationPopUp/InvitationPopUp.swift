//
//  InvitationPopUp.swift
//  Promise
//
//  Created by kwh on 1/22/24.
//

import Foundation
import UIKit

protocol InvitationPopUpDelegate: NSObject {
    func onSuccessAttendPromise(promise: Components.Schemas.OutputPromiseListItem)
    func onFailureAttendPromise(targetPromise: Components.Schemas.OutputPromiseListItem, error: BadRequestError)
    func onLoadingAttendPromise()
}

class InvitationPopUp {
    weak var delegate: InvitationPopUpDelegate?
    
    // properties
    
    private var popupVC: PopupVC?
    
    private let invitedPromise: Components.Schemas.OutputPromiseListItem
    private let currentVC: UIViewController
    
    // subviews
    
    private let invitationMainImage = {
        let imageView = UIImageView(image: Asset.invitationMainImage.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let notificationMainTitle = {
        let imageView = UIImageView(image: Asset.notificationGreen.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 12)
        label.textColor = UIColor(red: 0.02, green: 0.675, blue: 0.557, alpha: 1)
        label.text = L10n.TaggedNotification.invitedToPromise
        
        let wrapper = UIView()
        wrapper.translatesAutoresizingMaskIntoConstraints = false
        [imageView, label].forEach { wrapper.addSubview($0) }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: wrapper.topAnchor, constant: 1),
            imageView.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor, constant: -1),
            imageView.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
            
            label.topAnchor.constraint(equalTo: wrapper.topAnchor),
            label.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 2),
            label.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
        ])
        
        let container = UIView()
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 10
        container.backgroundColor =  UIColor(red: 0.902, green: 0.976, blue: 0.961, alpha: 1)
        
        [wrapper].forEach { container.addSubview($0) }
        
        NSLayoutConstraint.activate([
            wrapper.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
            wrapper.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2),
            wrapper.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var invitationPromisedAt = {
        let label = UILabel()
        
        // TimeInterval을 Date 객체로 변환
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd a hh시 mm분"
        
        label.text = dateFormatter.string(from: invitedPromise.promisedAt)
        label.textColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        let font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        label.font = font
        
        label.isSkeletonable = true
        label.linesCornerRadius = 4
        label.lastLineFillPercent = 80
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let lineHeight = font?.lineHeight
        label.heightAnchor.constraint(equalToConstant: lineHeight ?? 0).isActive = true
        
        return label
    }()
    
    private lazy var invitationTitle = {
        let label = UILabel()
        
        label.text = invitedPromise.title
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        let font = UIFont(font: FontFamily.Pretendard.bold, size: 20)
        label.font = font
        
        label.isSkeletonable = true
        label.linesCornerRadius = 4
        label.lastLineFillPercent = 90
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let lineHeight = font?.lineHeight
        label.heightAnchor.constraint(equalToConstant: lineHeight ?? 0).isActive = true
        
        return label
    }()
    
    private lazy var placeIcon = {
        var imageView = UIImageView()
        
        if let destination = invitedPromise.destination, invitedPromise.destinationType == .STATIC {
            imageView = UIImageView(image: Asset.placeThin.image)
            
        } else {
            imageView = UIImageView(image: Asset.placeThinRed.image)
        }
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let hostIcon = {
        let imageView = UIImageView(image: Asset.host.image)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var place = {
        let label = UILabel()
        
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        
        if let destination = invitedPromise.destination, invitedPromise.destinationType == .STATIC {
            label.text = destination.value1.address
            label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        } else {
            label.text = L10n.InvitationPopUp.middlePlaceWarning
            label.textColor = UIColor(red: 1, green: 0.408, blue: 0.304, alpha: 1)
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var host = {
        let label = UILabel()
        
        label.text = invitedPromise.host.username
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeWrapper = {
        let view = UIView()
        [placeIcon, place].forEach{ view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            placeIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            placeIcon.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
            placeIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            place.topAnchor.constraint(equalTo: view.topAnchor),
            place.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            place.leadingAnchor.constraint(equalTo: placeIcon.trailingAnchor, constant: 4),
            place.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hostWrapper = {
        let view = UIView()
        [hostIcon, host].forEach{ view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            hostIcon.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            hostIcon.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
            hostIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            host.topAnchor.constraint(equalTo: view.topAnchor),
            host.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            host.leadingAnchor.constraint(equalTo: hostIcon.trailingAnchor, constant: 4),
            host.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var taggedThemes = {
        let taggedTheme = invitedPromise.themes.map { themeTitle in
            let insetLabel = InsetLabel()
            insetLabel.topInset = 3
            insetLabel.bottomInset = 3
            insetLabel.leftInset = 8
            insetLabel.rightInset = 8
            
            insetLabel.text = themeTitle
            insetLabel.font = UIFont(font: FontFamily.Pretendard.regular, size: 12)
            insetLabel.textColor = UIColor(red: 0.898, green: 0.702, blue: 0.204, alpha: 1)
            insetLabel.backgroundColor = UIColor(red: 1, green: 0.976, blue: 0.922, alpha: 1)
            
            insetLabel.layer.masksToBounds = true
            insetLabel.layer.cornerRadius = 10
            insetLabel.sizeToFit()
            
            insetLabel.translatesAutoresizingMaskIntoConstraints = false
            return insetLabel
        }
        
        let stackView = UIStackView(arrangedSubviews: taggedTheme)
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var themesScrollWrap = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(taggedThemes)
        NSLayoutConstraint.activate([
            taggedThemes.topAnchor.constraint(equalTo: scrollView.topAnchor),
            taggedThemes.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            taggedThemes.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            taggedThemes.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            taggedThemes.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let line = {
        let dashLineView = UIView()
        dashLineView.translatesAutoresizingMaskIntoConstraints = false
        dashLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return dashLineView
    }()
    
    private let startLocation = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        
        // Placeholder
        label.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        label.text = L10n.InvitationPopUp.startLocationPlaceholder
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let notificationStartLocationWarning = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 12)
        label.textColor = UIColor(red: 0.898, green: 0.369, blue: 0.275, alpha: 1)
        label.text = L10n.TaggedNotification.middlePlaceWarning
        
        let container = UIView()
        container.layer.masksToBounds = true
        container.layer.cornerRadius = 10
        container.backgroundColor =  UIColor(red: 1, green: 0.941, blue: 0.929, alpha: 1)
        
        [label].forEach { container.addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2),
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        ])
        
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var startLocationButton = {
        let imageView = UIImageView(image: Asset.placeThin.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [imageView, startLocation])
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        stackView.layer.masksToBounds = true
        stackView.layer.cornerRadius = 8
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapStartLocationButton))
        stackView.addGestureRecognizer(tapGesture)
        stackView.isUserInteractionEnabled = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var invitationContent = {
        let view = UIView()
        
        [
            invitationMainImage,
            notificationMainTitle,
            invitationPromisedAt,
            invitationTitle,
            themesScrollWrap,
            placeWrapper,
            hostWrapper,
            line,
            notificationStartLocationWarning,
            startLocationButton
        ].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            invitationMainImage.topAnchor.constraint(equalTo: view.topAnchor),
            invitationMainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            invitationMainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            invitationMainImage.heightAnchor.constraint(equalToConstant: 180),
            
            notificationMainTitle.topAnchor.constraint(equalTo: invitationMainImage.bottomAnchor, constant: 16),
            notificationMainTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            notificationMainTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            invitationPromisedAt.topAnchor.constraint(equalTo: notificationMainTitle.bottomAnchor, constant: 16),
            invitationPromisedAt.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            invitationPromisedAt.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            invitationTitle.topAnchor.constraint(equalTo: invitationPromisedAt.bottomAnchor, constant: 4),
            invitationTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            invitationTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            themesScrollWrap.topAnchor.constraint(equalTo: invitationTitle.bottomAnchor, constant: 8),
            themesScrollWrap.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            themesScrollWrap.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            placeWrapper.topAnchor.constraint(equalTo: themesScrollWrap.bottomAnchor, constant: 8),
            placeWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            hostWrapper.topAnchor.constraint(equalTo: placeWrapper.bottomAnchor, constant: 8),
            hostWrapper.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            line.topAnchor.constraint(equalTo: hostWrapper.bottomAnchor, constant: 16),
            line.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        if invitedPromise.destinationType == .DYNAMIC {
            NSLayoutConstraint.activate([
                notificationStartLocationWarning.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 16),
                notificationStartLocationWarning.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                notificationStartLocationWarning.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                
                startLocationButton.topAnchor.constraint(equalTo: notificationStartLocationWarning.bottomAnchor, constant: 16),
                startLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                startLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                startLocationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                startLocationButton.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 16),
                startLocationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                startLocationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                startLocationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // handler
    
    private func onTapAttendButton() {
        self.popupVC?.close(completion: {
            Task { [weak self] in
                guard let targetPromise = self?.invitedPromise else { return }
                
                let result: Result<EmptyResponse, NetworkError> = await APIService.shared.fetch(.POST, "/promises/\(targetPromise.pid)/attend")
                
                switch result {
                case .success:
                    
                    self?.delegate?.onSuccessAttendPromise(promise: targetPromise)
                    
                case .failure(let errorType):
                    
                    switch errorType {
                    case .badRequest(let error):
                        
                        self?.delegate?.onFailureAttendPromise(targetPromise: targetPromise, error: error)
                        
                    default:
                        
                        // Other Error(Network, badUrl ...)
                        break
                    }
                    
                }
                
            }
        })

    }
    
    @objc private func onTapStartLocationButton() {
        // TODO: 출발지 설정 화면으로 이동 그리고 설정 완료되면 델리게이트에서 받아서 텍스트 업데이트!
    }
    
    // initializer
    
    init(invitedPromise: Components.Schemas.OutputPromiseListItem, currentVC: UIViewController) {
        self.invitedPromise = invitedPromise
        self.currentVC = currentVC
    }
    
}

extension InvitationPopUp {
    public func showInvitationPopUp() {
        APIService.shared.delegate = self
        
        DispatchQueue.main.async {
            let popupVC = PopupVC()
            self.popupVC = popupVC
            
            popupVC.disableBackgroundTap = true
            popupVC.containerView.backgroundColor = UIColor(red: 1, green: 0.992, blue: 0.976, alpha: 1)
            
            popupVC.initialize(
                contentView: self.invitationContent,
                leftBtnTitle: L10n.Common.refuse,
                leftBtnHandler: {
                    popupVC.close()
                    self.popupVC = nil
                },
                rightBtnTitle: L10n.Common.attend,
                rightBtnHandelr: self.onTapAttendButton
            )
            
            self.currentVC.present(popupVC, animated: false) {
                self.line.addDashedBorder()
            }
        }
        
    }
}

extension InvitationPopUp: APIServiceDelegate {
    func onLoading(path: String?, isLoading: Bool) {
        switch(path) {
        case "/promises/\(invitedPromise.pid)/attend":
            if(isLoading) {
                self.delegate?.onLoadingAttendPromise()
            }
        default:
            break
        }
    }
}
