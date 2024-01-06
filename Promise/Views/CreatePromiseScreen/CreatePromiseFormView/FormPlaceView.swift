//
//  FormPlaceView.swift
//  Promise
//
//  Created by dylan on 2023/08/28.
//

import Foundation
import UIKit
import Lottie

class FormPlaceView: UIView {
    var createPromiseVM: CreatePromiseVM
    
    // mini 대응
    var placeWrapperHeightConstraint: NSLayoutConstraint?
    var selectPlaceButtonIconWidthConstraint: NSLayoutConstraint?
    var selectPlaceButtonIconHeightConstraint: NSLayoutConstraint?
    
    private let label = {
        let label = UILabel()
        label.text = L10n.CreatePromise.formPlaceLabel
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 12)
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeTypeWrapper = {
        let formTabMenu = FormTabMenuView(
            leftButtonTitle: L10n.CreatePromise.PlaceType.designation,
            rightButtonTitle: L10n.CreatePromise.PlaceType.middle
        )
        
        formTabMenu.delegate = self
        formTabMenu.translatesAutoresizingMaskIntoConstraints = false
        return formTabMenu
    }()
    
    private let selectPlaceButtonIcon = {
        let imageView = UIImageView(image: Asset.place.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let selectedPlace = {
        let label = UILabel()
        
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        label.text = L10n.CreatePromise.promisePlaceInputPlaceholder
        label.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var selectPlaceButton = {
        let stackView = UIStackView(arrangedSubviews: [selectPlaceButtonIcon, selectedPlace])
        
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.alignment = .center
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        stackView.layer.cornerRadius = 8
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapSelectPlaceButton))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tapGesture)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var middlePlaceGuidanceButton = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 12)
        label.text = L10n.CreatePromise.promiseMiddlePlaceGuidance
        label.textColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
        
        let imageView = UIImageView(image: Asset.questionMarkPrimary.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let view = UIView()
        view.backgroundColor = .white
        
        [label, imageView].forEach{ view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 1),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            imageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 3)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapMiddlePlaceGuidanceButton))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let animatedMapImage = {
        let lottieAnimationView = LottieAnimationView(name: "map")
        lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        return lottieAnimationView
    }()
    
    
    private lazy var middlePlaceGuidancePopup = {
        var fontSize = 16.0
        let fullWidth = createPromiseVM.currentVC?.view.frame.width
        if let fullWidth, fullWidth < 393 {
            fontSize = 15.0
        }
        
        let desiredLineHeight: CGFloat = 24.0
        
        let font = UIFont(font: FontFamily.Pretendard.regular, size: fontSize)!
        let actualLineHeight = font.lineHeight
        
        let lineSpacing = desiredLineHeight - actualLineHeight
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let text = L10n.CreatePromise.PromiseMiddlePlaceGuidance.popupDescription
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([
            .paragraphStyle: paragraphStyle,
            .font: font,
            .foregroundColor: UIColor.black,
        ], range: NSMakeRange(0, attributedString.length))
        
        attributedString.addAttribute(
            .font,
            value: UIFont(font: FontFamily.Pretendard.bold, size: fontSize)!,
            range: (text as NSString).range(of: L10n.CreatePromise.PromiseMiddlePlaceGuidance.PopupDescription.highlight)
        )
        
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = attributedString
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        [animatedMapImage, label].forEach{ view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            animatedMapImage.topAnchor.constraint(equalTo: view.topAnchor),
            animatedMapImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatedMapImage.widthAnchor.constraint(equalToConstant: 200),
            animatedMapImage.heightAnchor.constraint(equalToConstant: 200),
            
            label.topAnchor.constraint(equalTo: animatedMapImage.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        let popupVC = PopupVC()
        popupVC.initialize(contentView: view, rightBtnTitle: L10n.Common.confirm) {
            popupVC.close()
        }
        
        return popupVC
    }()
    
    private lazy var placeWrapper = {
        let view = UIView()
        [selectPlaceButton, middlePlaceGuidanceButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            selectPlaceButton.topAnchor.constraint(equalTo: view.topAnchor),
            selectPlaceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectPlaceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectPlaceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            middlePlaceGuidanceButton.topAnchor.constraint(equalTo: view.topAnchor),
            middlePlaceGuidanceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2),
            middlePlaceGuidanceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            middlePlaceGuidanceButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    @objc private func onTapSelectPlaceButton(){
        let placeSelectionVC = PlaceSelectionVC()
        placeSelectionVC.delegate = self
        createPromiseVM.currentVC?.present(placeSelectionVC, animated: true)
    }
    
    @objc private func onTapMiddlePlaceGuidanceButton() {
        createPromiseVM.currentVC?.present(middlePlaceGuidancePopup, animated: false) { [weak self] in
            self?.animatedMapImage.play()
        }
    }
    
    private func assignPlaceTypeDidChange() {
        createPromiseVM.placeTypeDidChange = { [weak self] type in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch(type) {
                case .STATIC:
                    self.selectPlaceButton.isHidden = false
                    self.middlePlaceGuidanceButton.isHidden = true
                    
                    self.selectPlaceButtonIconWidthConstraint?.constant = 20
                    self.selectPlaceButtonIconHeightConstraint?.constant = 20
                    self.placeWrapperHeightConstraint?.constant = 45
                    
                case .DYNAMIC:
                    self.selectPlaceButton.isHidden = true
                    self.middlePlaceGuidanceButton.isHidden = false
                    
                    self.selectPlaceButtonIconWidthConstraint?.constant = 0
                    self.selectPlaceButtonIconHeightConstraint?.constant = 0
                    self.placeWrapperHeightConstraint?.constant = 16
                }
                
                self.layoutIfNeeded()
            }
        }
    }
    
    private func assignPlaceDidChange() {
//        createPromiseVM.placeDidChange = { [weak self] place in
//            guard let self else { return }
//
//            DispatchQueue.main.async {
//                // TODO: 주소 업데이트 시 UI 업데이트
//
//            }
//        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        isUserInteractionEnabled = false
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        isUserInteractionEnabled = true
    }
    
    init(vm: CreatePromiseVM) {
        createPromiseVM = vm
        
        super.init(frame: .null)
        
        assignPlaceTypeDidChange()
        assignPlaceDidChange()
        configureFormPlaceView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFormPlaceView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        placeWrapperHeightConstraint = placeWrapper.heightAnchor.constraint(equalToConstant: 45)
        selectPlaceButtonIconWidthConstraint = selectPlaceButtonIcon.widthAnchor.constraint(equalToConstant: 20)
        selectPlaceButtonIconHeightConstraint = selectPlaceButtonIcon.heightAnchor.constraint(equalToConstant: 20)
        
        NSLayoutConstraint.activate([
            placeWrapperHeightConstraint!,
            selectPlaceButtonIconWidthConstraint!,
            selectPlaceButtonIconHeightConstraint!
        ])
        
        [label, placeTypeWrapper, placeWrapper].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            placeTypeWrapper.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            placeTypeWrapper.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeTypeWrapper.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            placeWrapper.topAnchor.constraint(equalTo: placeTypeWrapper.bottomAnchor, constant: 8),
            placeWrapper.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeWrapper.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeWrapper.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension FormPlaceView: FormTabMenuViewDelegate, PlaceSelectionDelegate {
    func onTapLeftButton() {
        createPromiseVM.onChangedPlaceType(Components.Schemas.InputCreatePromise.destinationTypePayload.STATIC)
    }
    
    func onTapRightButton() {
        createPromiseVM.onChangedPlaceType(Components.Schemas.InputCreatePromise.destinationTypePayload.DYNAMIC)
    }
}
