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
    
    private let label = {
        let label = UILabel()
        label.text = L10n.CreatePromise.Form.placeLabel
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeType = {
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
        imageView.widthAnchor.constraint(equalToConstant: adjustedValue(20, .width)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(20, .height)).isActive = true
        return imageView
    }()
    
    private let selectedPlace = {
        let label = UILabel()
        
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width))
        label.text = L10n.CreatePromise.promisePlaceInputPlaceholder
        label.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var selectPlaceButton = {
        let stackView = UIStackView(arrangedSubviews: [selectPlaceButtonIcon, selectedPlace])
        
        stackView.axis = .horizontal
        stackView.spacing = adjustedValue(5, .width)
        stackView.alignment = .center
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        stackView.layer.borderWidth = adjustedValue(1, .width)
        stackView.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        stackView.layer.cornerRadius = adjustedValue(8, .width)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapSelectPlaceButton))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tapGesture)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.heightAnchor.constraint(equalToConstant: adjustedValue(45, .height)).isActive = true
        return stackView
    }()
    
    private lazy var middlePlaceGuidanceButton = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
        label.text = L10n.CreatePromise.promiseMiddlePlaceGuidance
        label.textColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
        
        let imageView = UIImageView(image: Asset.questionMarkPrimary.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: adjustedValue(16, .width)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(16, .height)).isActive = true
        
        let view = UIView()
        view.backgroundColor = .white
        
        [label, imageView].forEach{ view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: adjustedValue(3, .width))
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
        var fontSize = adjustedValue(16, .width)
        let fullWidth = createPromiseVM.currentVC?.view.frame.width
        if let fullWidth, fullWidth < 393 {
            fontSize = adjustedValue(15, .width)
        }
        
        let desiredLineHeight: CGFloat = adjustedValue(24, .height)
        
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
            animatedMapImage.widthAnchor.constraint(equalToConstant: adjustedValue(200, .width)),
            animatedMapImage.heightAnchor.constraint(equalToConstant: adjustedValue(200, .height)),
            
            label.topAnchor.constraint(equalTo: animatedMapImage.bottomAnchor, constant: adjustedValue(16, .height)),
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
        let stackView = UIStackView(arrangedSubviews: [
            selectPlaceButton, 
            middlePlaceGuidanceButton
        ])
        
        stackView.axis = .vertical
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        createPromiseVM.placeTypeDidChange = { type in
            
            DispatchQueue.main.async { [weak self] in
                switch(type) {
                case .STATIC:
                    self?.placeType.updateUIForSelectedTab(tab: .LEFT)
                    self?.selectPlaceButton.isHidden = false
                    self?.middlePlaceGuidanceButton.isHidden = true
                    
                case .DYNAMIC:
                    self?.placeType.updateUIForSelectedTab(tab: .RIGHT)
                    self?.selectPlaceButton.isHidden = true
                    self?.middlePlaceGuidanceButton.isHidden = false
                    
                }
                
                self?.layoutIfNeeded()
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
        configure()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        assignPlaceTypeDidChange()
        assignPlaceDidChange()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func render() {
        [label, placeType, placeWrapper].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            placeType.topAnchor.constraint(equalTo: label.bottomAnchor, constant: adjustedValue(8, .height)),
            placeType.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeType.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            placeWrapper.topAnchor.constraint(equalTo: placeType.bottomAnchor, constant: adjustedValue(8, .height)),
            placeWrapper.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeWrapper.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeWrapper.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension FormPlaceView: FormTabMenuViewDelegate, PlaceSelectionDelegate {
    func onTapLeftButton() {
        createPromiseVM.onChangedPlaceType(Components.Schemas.InputUpdatePromiseDTO.destinationTypePayload.STATIC)
    }
    
    func onTapRightButton() {
        createPromiseVM.onChangedPlaceType(Components.Schemas.InputUpdatePromiseDTO.destinationTypePayload.DYNAMIC)
    }
}
