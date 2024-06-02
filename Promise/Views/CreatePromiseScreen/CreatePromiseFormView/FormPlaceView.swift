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
        stackView.spacing = adjustedValue(4, .width)
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
    
    private let middlePlaceGuidanceTaggedText = {
        let label = UILabel()
        
        // Placeholder
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(12, .width))
        
        label.text = L10n.UpdatePromise.DynamicDestination.Guidance.configurable
        label.textColor = UIColor(red: 0.898, green: 0.369, blue: 0.275, alpha: 1)
        
        label.sizeToFit()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let middlePlaceGuidanceTaggedIcon = {
        let imageView = UIImageView(image: Asset.informationRed.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: adjustedValue(16, .width)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(16, .height)).isActive = true
        return imageView
    }()
    
    private lazy var middlePlaceGuidanceTaggedWrapper = {
        let view = UIView()
        
        [
            middlePlaceGuidanceTaggedIcon,
            middlePlaceGuidanceTaggedText
        ].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            middlePlaceGuidanceTaggedIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            middlePlaceGuidanceTaggedIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            middlePlaceGuidanceTaggedText.leadingAnchor.constraint(equalTo: middlePlaceGuidanceTaggedIcon.trailingAnchor, constant: adjustedValue(4, .width)),
            middlePlaceGuidanceTaggedText.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            middlePlaceGuidanceTaggedText.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var middlePlaceTaggedGuidance = {
        let view = UIView()
        view.addSubview(middlePlaceGuidanceTaggedWrapper)
        NSLayoutConstraint.activate([
            middlePlaceGuidanceTaggedWrapper.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            middlePlaceGuidanceTaggedWrapper.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        view.backgroundColor = UIColor(red: 1, green: 0.941, blue: 0.929, alpha: 1)
        view.layer.cornerRadius = adjustedValue(12, .width)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.heightAnchor.constraint(equalToConstant: adjustedValue(24, .height)).isActive = true
        return view
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
    
    private lazy var middlePlaceSelectionButton = {
        let button = Button()
        button.initialize(
            title: L10n.UpdatePromise.DynamicDestination.selectionButtonTitle,
            bgColor: .white,
            borderColor: UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1),
            fontColor: UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
        )
        
        button.addTarget(self, action: #selector(onTapMiddlePlaceSelectionButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: Button.Height).isActive = true
        button.isHidden = true
        return button
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
            middlePlaceTaggedGuidance,
            selectPlaceButton,
            middlePlaceGuidanceButton,
            middlePlaceSelectionButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = adjustedValue(16, .height)
        
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    @objc private func onTapSelectPlaceButton() {
        switch createPromiseVM.placeType {
        case .STATIC:
            let placeSelectionVC = PlaceSelectionVC(mode: .destination)
            placeSelectionVC.dataDelegate = self
            createPromiseVM.currentVC?.present(placeSelectionVC, animated: true)
        case .DYNAMIC:
            guard let state = createPromiseVM.dynamicDestinationState else { return }
            guard state == .configurable else { return }
            onTapMiddlePlaceSelectionButton()
        }
    }
    
    @objc private func onTapMiddlePlaceGuidanceButton() {
        createPromiseVM.currentVC?.present(middlePlaceGuidancePopup, animated: false) { [weak self] in
            self?.animatedMapImage.play()
        }
    }
    
    @objc private func onTapMiddlePlaceSelectionButton() {
        
        guard let state = createPromiseVM.dynamicDestinationState else { return }
        
        let dynamicDestinationSelectionVC = DynamicDestinationSelectionVC(vm: createPromiseVM, state: state)
        dynamicDestinationSelectionVC.delegate = self
        createPromiseVM.currentVC?.present(dynamicDestinationSelectionVC, animated: true)
    }
    
    private func updateMiddlePlaceViewByState() {
        guard let state = createPromiseVM.dynamicDestinationState else {
            self.selectPlaceButton.isHidden = true
            self.middlePlaceGuidanceButton.isHidden = false
            return
        }
        
        switch state {
        case .notConfigurable:
            
            self.placeWrapper.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.middlePlaceGuidanceButton.isHidden = false
            self.selectPlaceButton.isHidden = true
            
        case .configurable:
            
            self.placeWrapper.layoutMargins = UIEdgeInsets(
                top: adjustedValue(8, .height),
                left: 0,
                bottom: 0,
                right: 0
            )
            
            self.middlePlaceGuidanceButton.isHidden = true
            
            self.selectPlaceButton.isHidden = false
            if createPromiseVM.isNewSelectedMiddlePlaceForUpdate {
                self.selectPlaceButton.layer.borderColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor
            } else {
                self.selectPlaceButton.layer.borderColor = UIColor(red: 1, green: 0.41, blue: 0.3, alpha: 1).cgColor
            }
            
            if let middlePlace = self.createPromiseVM.form.middlePlace {
                let middlePlaceText = AddressHelper().getDisplayAddressText(place: middlePlace)
                self.selectedPlace.text = middlePlaceText
                self.selectedPlace.textColor = .black
                
            } else {
                
                self.selectedPlace.text = L10n.UpdatePromise.DynamicDestination.Configurable.placeholder
                self.selectedPlace.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
                
            }
            
            // MARK: configuable 상태에서 middlePlaceTaggedGuidance 내용 및 색상은 초기화 시 default 구성
            self.middlePlaceTaggedGuidance.isHidden = false
            if createPromiseVM.isNewSelectedMiddlePlaceForUpdate {
                self.middlePlaceTaggedGuidance.backgroundColor = UIColor(red: 0.9, green: 0.98, blue: 0.96, alpha: 1)
                self.middlePlaceGuidanceTaggedIcon.image = Asset.informationGreen.image
                self.middlePlaceGuidanceTaggedText.textColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
                self.middlePlaceGuidanceTaggedText.text = L10n.UpdatePromise.DynamicDestination.Guidance.staging
            }
            
        case .configured:
            
            self.placeWrapper.layoutMargins = UIEdgeInsets(
                top: adjustedValue(8, .height),
                left: 0,
                bottom: 0,
                right: 0
            )
            
            self.middlePlaceGuidanceButton.isHidden = true
            
            self.selectPlaceButton.isHidden = false
            if createPromiseVM.isNewSelectedMiddlePlaceForUpdate {
                self.selectPlaceButton.layer.borderColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor
            } else {
                self.selectPlaceButton.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
            }
            
            if let middlePlace = self.createPromiseVM.form.middlePlace {
                
                let middlePlaceText = AddressHelper().getDisplayAddressText(place: middlePlace)
                
                self.selectedPlace.text = middlePlaceText
                self.selectedPlace.textColor = .black
                
            } else {
                
                self.selectedPlace.text = L10n.UpdatePromise.DynamicDestination.Configurable.placeholder
                self.selectedPlace.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
                
            }
            
            self.middlePlaceTaggedGuidance.isHidden = false
            
            if createPromiseVM.isNewSelectedMiddlePlaceForUpdate {
                self.middlePlaceTaggedGuidance.backgroundColor = UIColor(red: 0.9, green: 0.98, blue: 0.96, alpha: 1)
                self.middlePlaceGuidanceTaggedIcon.image = Asset.informationGreen.image
                self.middlePlaceGuidanceTaggedText.textColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
                self.middlePlaceGuidanceTaggedText.text = L10n.UpdatePromise.DynamicDestination.Guidance.staging
            } else {
                self.middlePlaceTaggedGuidance.backgroundColor = UIColor(red: 0.922, green: 0.957, blue: 1, alpha: 1)
                self.middlePlaceGuidanceTaggedIcon.image = Asset.informationBlue.image
                self.middlePlaceGuidanceTaggedText.textColor = UIColor(red: 0.2, green: 0.52, blue: 0.9, alpha: 1)
                self.middlePlaceGuidanceTaggedText.text = L10n.UpdatePromise.DynamicDestination.Guidance.configured
            }
            
            self.middlePlaceSelectionButton.isHidden = false
            
        case .newlyConfigurable:
            
            self.placeWrapper.layoutMargins = UIEdgeInsets(
                top: adjustedValue(8, .height),
                left: 0,
                bottom: 0,
                right: 0
            )
            
            self.middlePlaceGuidanceButton.isHidden = true
            
            self.selectPlaceButton.isHidden = false
            if createPromiseVM.isNewSelectedMiddlePlaceForUpdate {
                self.selectPlaceButton.layer.borderColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor
            } else {
                self.selectPlaceButton.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
            }
            
            if let middlePlace = self.createPromiseVM.form.middlePlace {
                
                let middlePlaceText = AddressHelper().getDisplayAddressText(place: middlePlace)
                
                self.selectedPlace.text = middlePlaceText
                self.selectedPlace.textColor = .black
                
            } else {
                
                self.selectedPlace.text = L10n.UpdatePromise.DynamicDestination.Configurable.placeholder
                self.selectedPlace.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
                
            }
            
            self.middlePlaceTaggedGuidance.isHidden = false
            if createPromiseVM.isNewSelectedMiddlePlaceForUpdate {
                self.middlePlaceTaggedGuidance.backgroundColor = UIColor(red: 0.9, green: 0.98, blue: 0.96, alpha: 1)
                self.middlePlaceGuidanceTaggedIcon.image = Asset.informationGreen.image
                self.middlePlaceGuidanceTaggedText.textColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
                self.middlePlaceGuidanceTaggedText.text = L10n.UpdatePromise.DynamicDestination.Guidance.staging
            } else {
                self.middlePlaceGuidanceTaggedText.text = L10n.UpdatePromise.DynamicDestination.Guidance.newlyConfigurable
            }
            
            self.middlePlaceSelectionButton.isHidden = false
        }
        
        self.layoutIfNeeded()
    }
    
    private func assignPlaceTypeDidChange() {
        createPromiseVM.placeTypeDidChange = { type in
            
            DispatchQueue.main.async { [weak self] in
                if let _ = self?.createPromiseVM.editingPromise {
                    
                    switch(type) {
                    case .STATIC:
                        
                        self?.placeType.updateUIForSelectedTab(tab: .LEFT)
                        
                        self?.placeWrapper.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        
                        self?.selectPlaceButton.isHidden = false
                        self?.selectPlaceButton.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
                        
                        if let place = self?.createPromiseVM.form.place {
                            
                            let placeText = AddressHelper().getDisplayAddressText(place: place)
                            
                            self?.selectedPlace.text = placeText
                            self?.selectedPlace.textColor = .black
                            
                        } else {
                            
                            self?.selectedPlace.text = L10n.CreatePromise.promisePlaceInputPlaceholder
                            self?.selectedPlace.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
                            
                        }
                        
                        self?.middlePlaceGuidanceButton.isHidden = true
                        self?.middlePlaceTaggedGuidance.isHidden = true
                        self?.middlePlaceSelectionButton.isHidden = true
                        
                    case .DYNAMIC:
                        
                        self?.placeType.updateUIForSelectedTab(tab: .RIGHT)
                        self?.updateMiddlePlaceViewByState()
                    }
                    
                } else {
                    
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
                    
                }
                
                self?.layoutIfNeeded()
            }
        }
    }
    
    private func updatePlace() {
        if let place = self.createPromiseVM.form.place {
            
            let placeText = AddressHelper().getDisplayAddressText(place: place)
            self.selectedPlace.text = placeText
            self.selectedPlace.textColor = .black
            
        } else {
            
            self.selectedPlace.text = L10n.CreatePromise.promisePlaceInputPlaceholder
            self.selectedPlace.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            
        }
        
        self.layoutIfNeeded()
    }
    
    private func assignMiddlePlaceDidChange() {
        createPromiseVM.middlePlaceDidChange = { middlePlace in
            
            DispatchQueue.main.async { [weak self] in
                self?.updateMiddlePlaceViewByState()
            }
        }
    }
    
    // TODO: placeDidChange
    private func assignPlaceDidChange() {
        createPromiseVM.placeDidChange = { place in
            
            DispatchQueue.main.async { [weak self] in
                self?.updatePlace()
            }
        }
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
        assignMiddlePlaceDidChange()
        
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

extension FormPlaceView: FormTabMenuViewDelegate {
    func onTapLeftButton() {
        createPromiseVM.onChangedPlaceType(.STATIC)
    }
    
    func onTapRightButton() {
        createPromiseVM.onChangedPlaceType(.DYNAMIC)
    }
}

extension FormPlaceView: PlaceSelectionDataDelegate {
    func handlePlaceResult(place: PlaceLocationMDL) {
        guard let latitude = Double(place.latitude),
              let longitude = Double(place.longitude) else  { return }
        
        let updatePlace: Components.Schemas.InputUpdatePromiseDTO.destinationPayload = .init(value1: .init(
            city: place.city,
            district: place.disctrict,
            address1: place.address1,
            address2: place.address2,
            latitude: latitude,
            longitude: longitude)
        )
        
        createPromiseVM.onChangedPlace(updatePlace)
    }
}

extension FormPlaceView: DynamicDestinationSelectionDelegate {
    func onSelectedMiddlePlace(place: Components.Schemas.InputUpdatePromiseDTO.destinationPayload, middlePoint: Components.Schemas.PointDTO, midpointCalculatedIds: [Double]) {
        createPromiseVM.onChangedMiddlePlace(place)
        createPromiseVM.onChangeMiddlePoint(middlePoint)
        createPromiseVM.onChangeMidpointCalculatedIds(midpointCalculatedIds)
    }
}
