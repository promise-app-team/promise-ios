//
//  PromiseStatusWithUser.swift
//  Promise
//
//  Created by kwh on 2/3/24.
//

import Foundation
import UIKit

class PromiseStatusWithUserView: UIView {
    // MARK: properties
    
    let mainVM: MainVM
    
    private var isEnabledLocationServiceOnDevice = LocationService.shared.isEnabledLocationServiceOnDevice {
        didSet {
            if isEnabledLocationServiceOnDevice {
                DispatchQueue.main.async { [weak self] in
                    self?.userSharingStateLight.image = Asset.statusOn.image
                    
                    self?.userSharingStateTaggedLabel.text = L10n.PromiseStatusWithUserView.Tag.sharingOn
                    self?.userSharingStateTaggedLabel.textColor = UIColor(red: 0.02, green: 0.675, blue: 0.557, alpha: 1)
                    self?.userSharingStateTaggedLabel.backgroundColor = UIColor(red: 0.902, green: 0.976, blue: 0.961, alpha: 1)
                }
                
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.userSharingStateLight.image = Asset.statusOff.image
                    
                    self?.userSharingStateTaggedLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
                    self?.userSharingStateTaggedLabel.text = L10n.PromiseStatusWithUserView.Tag.sharingOff
                    self?.userSharingStateTaggedLabel.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
                }
            }
        }
    }
    
    // MARK: subviews
    
    private let spacingView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: adjustedValue(32, .height)).isActive = true
        view.backgroundColor = .white
        view.layer.zPosition = 1
        return view
    }()
    
    private let departureLocationLabel = {
        let label = UILabel()
        
        label.text = L10n.PromiseStatusWithUserView.Label.departureLocation
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userStatusLabel = {
        let label = UILabel()
        
        label.text = L10n.PromiseStatusWithUserView.Label.userStatus
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userStatusLight = {
        let imageView = UIImageView(image:Asset.statusOff.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.widthAnchor.constraint(equalToConstant: adjustedValue(16, .width)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(16, .height)).isActive = true
        
        return imageView
    }()
    
    private lazy var userStatusLabelWrapper = {
        let stackView = UIStackView(arrangedSubviews: [
            userStatusLabel,
            userStatusLight
        ])
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let userSharingStateLabel = {
        let label = UILabel()
        
        label.text = L10n.PromiseStatusWithUserView.Label.userSharingState
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var userSharingStateLight = {
        let imageView = UIImageView(
            image: isEnabledLocationServiceOnDevice ? Asset.statusOn.image : Asset.statusOff.image
        )
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.widthAnchor.constraint(equalToConstant: adjustedValue(16, .width)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(16, .height)).isActive = true
        
        return imageView
    }()
    
    private lazy var userSharingStateLabelWrapper = {
        let stackView = UIStackView(arrangedSubviews: [
            userSharingStateLabel,
            userSharingStateLight
        ])
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let departureLocation = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let font = UIFont(font: FontFamily.Pretendard.semiBold, size: adjustedValue(16, .width))
        label.font = font
        
        let lineHeight = font?.lineHeight
        label.heightAnchor.constraint(equalToConstant: lineHeight ?? 0).isActive = true
        
        // label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        // label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let departureLocationEditIcon = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.widthAnchor.constraint(equalToConstant: adjustedValue(16, .width)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(16, .height)).isActive = true
        
        return imageView
    }()
    
    private lazy var departureLocationWrapper = {
        
        let iconWrapper = UIView()
        iconWrapper.translatesAutoresizingMaskIntoConstraints = false
        
        iconWrapper.addSubview(departureLocationEditIcon)
        iconWrapper.widthAnchor.constraint(greaterThanOrEqualTo: departureLocationEditIcon.widthAnchor).isActive = true
        
        departureLocationEditIcon.leadingAnchor.constraint(equalTo: iconWrapper.leadingAnchor).isActive = true
        departureLocationEditIcon.centerYAnchor.constraint(equalTo: iconWrapper.centerYAnchor).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [departureLocation, iconWrapper])

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = adjustedValue(4, .width)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapDepartureLocationLabel))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tapGesture)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let userStatusTaggedLabel = {
        let insetLabel = InsetLabel()
        
        insetLabel.topInset = adjustedValue(3, .height)
        insetLabel.bottomInset = adjustedValue(3, .height)
        insetLabel.leftInset = adjustedValue(8, .width)
        insetLabel.rightInset = adjustedValue(8, .width)
        
        // Placeholder
        insetLabel.text = L10n.PromiseStatusWithUserView.Tag.notStart
        insetLabel.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(12, .width))
        insetLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        insetLabel.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        
        insetLabel.layer.masksToBounds = true
        insetLabel.layer.cornerRadius = 9
        insetLabel.sizeToFit()
        
        insetLabel.translatesAutoresizingMaskIntoConstraints = false
        return insetLabel
    }()
    
    private lazy var userSharingStateTaggedLabel = {
        let insetLabel = InsetLabel()
        
        insetLabel.topInset = adjustedValue(3, .height)
        insetLabel.bottomInset = adjustedValue(3, .height)
        insetLabel.leftInset = adjustedValue(8, .width)
        insetLabel.rightInset = adjustedValue(8, .width)
        
        // Placeholder
        insetLabel.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(12, .width))
        
        if isEnabledLocationServiceOnDevice {
            insetLabel.text = L10n.PromiseStatusWithUserView.Tag.sharingOn
            insetLabel.textColor = UIColor(red: 0.02, green: 0.675, blue: 0.557, alpha: 1)
            insetLabel.backgroundColor = UIColor(red: 0.902, green: 0.976, blue: 0.961, alpha: 1)
        } else {
            insetLabel.text = L10n.PromiseStatusWithUserView.Tag.sharingOff
            insetLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            insetLabel.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        }
        
        insetLabel.layer.masksToBounds = true
        insetLabel.layer.cornerRadius = adjustedValue(9, .width)
        insetLabel.sizeToFit()
        
        insetLabel.translatesAutoresizingMaskIntoConstraints = false
        return insetLabel
    }()
    
    // MARK: handler
    
    @objc func onTapDepartureLocationLabel() {
        guard let topVC = parentViewController() else { return }
        let placeSelectionVC = PlaceSelectionVC()
        placeSelectionVC.delegate = self
        topVC.navigationController?.pushViewController(placeSelectionVC, animated: true)
    }
    
    // MARK: initialize
    
    init(vm: MainVM) {
        mainVM = vm
        super.init(frame: .null)
        configure()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        backgroundColor = .white
        
        if let id = mainVM.currentFocusedPromise?.pid {
            mainVM.getDepartureLoaction(id: id) { location in
                
                DispatchQueue.main.async { [weak self] in
                    
                    let departureLoaction = location.city + " " + location.district + " " + location.address

                    self?.departureLocation.text = departureLoaction
                    self?.departureLocation.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                    
                    self?.departureLocationEditIcon.image = UIImage(asset: Asset.editGreen)
                }
                
            } onFailure: { [weak self] error in
                
                DispatchQueue.main.async { [weak self] in
                    
                    // Placeholder
                    self?.departureLocation.text = L10n.PromiseStatusWithUserView.departureLocationPlaceholder
                    self?.departureLocation.textColor = UIColor(red: 1, green: 0.408, blue: 0.304, alpha: 1)
                    
                    self?.departureLocationEditIcon.image = Asset.editRed.image
                }
                
            }
        }
        
    }
    
    private func render() {
        [
            spacingView,
            departureLocationLabel,
            departureLocationWrapper,
            userStatusLabelWrapper,
            userStatusTaggedLabel,
            userSharingStateLabelWrapper,
            userSharingStateTaggedLabel
        ].forEach { addSubview($0) }
        
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            spacingView.topAnchor.constraint(equalTo: topAnchor),
            spacingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            spacingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            departureLocationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            departureLocationLabel.bottomAnchor.constraint(equalTo: departureLocationWrapper.topAnchor, constant: -adjustedValue(8, .height)),
            
            departureLocationWrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            departureLocationWrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: adjustedValue(-24, .width)),
            departureLocationWrapper.bottomAnchor.constraint(equalTo: userStatusLabelWrapper.topAnchor, constant: -adjustedValue(17, .height)),
            
            userStatusLabelWrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            userStatusLabelWrapper.bottomAnchor.constraint(equalTo: userStatusTaggedLabel.topAnchor, constant: -adjustedValue(11, .height)),
            
            userStatusTaggedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            userStatusTaggedLabel.bottomAnchor.constraint(equalTo: userSharingStateLabelWrapper.topAnchor, constant: -adjustedValue(17, .height)),
            
            userSharingStateLabelWrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            userSharingStateLabelWrapper.bottomAnchor.constraint(equalTo: userSharingStateTaggedLabel.topAnchor, constant: -adjustedValue(11, .height)),
            
            userSharingStateTaggedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            userSharingStateTaggedLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -adjustedValue(45, .height))
        ])
    }
}

extension PromiseStatusWithUserView {
    public func updateStateForLocationServiceOnDevice(isEnabled: Bool) {
        isEnabledLocationServiceOnDevice = isEnabled
    }
    
    public func updatePromiseStatusWithUser(with promise: Components.Schemas.OutputPromiseListItem) {
        let id = promise.pid
        
        mainVM.getDepartureLoaction(id: id) { location in
            
            DispatchQueue.main.async { [weak self] in
                
                let departureLoaction = location.city + " " + location.district + " " + location.address

                self?.departureLocation.text = departureLoaction
                self?.departureLocation.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                
                self?.departureLocationEditIcon.image = UIImage(asset: Asset.editGreen)
            }
            
        } onFailure: { [weak self] error in
            
            DispatchQueue.main.async { [weak self] in
                
                // Placeholder
                self?.departureLocation.text = L10n.PromiseStatusWithUserView.departureLocationPlaceholder
                self?.departureLocation.textColor = UIColor(red: 1, green: 0.408, blue: 0.304, alpha: 1)
                
                self?.departureLocationEditIcon.image = Asset.editRed.image
            }
        }
        
    }
}

extension PromiseStatusWithUserView: PlaceSelectionDelegate {
    // TODO: 장소 설정 완료후 callback으로 변경 (장소 설정 플로우 화면이 완성되면)
    func onDidHide() {
        // TODO: 임시
        let location = Components.Schemas.InputUpdateUserStartLocation(city: "서울특별시", district: "관악구", address: "신림로3가길 46-17", latitude: 37.469726, longitude: 126.9419844)
        
        let address = location.city + " " + location.district + " " + (location.address ?? "")
        
        if address == departureLocation.text {
            return
        }
        
        Task {
            await mainVM.editDepartureLoaction(with: location) {
                
                DispatchQueue.main.async { [weak self] in
                    self?.departureLocation.text = address
                    self?.departureLocation.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                    
                    self?.departureLocationEditIcon.image = UIImage(asset: Asset.editGreen)
                }
                
            }
        }
    }
}
