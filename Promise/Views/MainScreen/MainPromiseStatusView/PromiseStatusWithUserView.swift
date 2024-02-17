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
    
    // MARK: subviews
    
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
    
    private let userSharingStateLabel = {
        let label = UILabel()
        
        label.text = L10n.PromiseStatusWithUserView.Label.userSharingState
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userSharingStateLight = {
        let imageView = UIImageView(image:Asset.statusOn.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.widthAnchor.constraint(equalToConstant: adjustedValue(16, .width)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(16, .height)).isActive = true
        
        return imageView
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
        stackView.spacing = 4
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapDepartureLocationLabel))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tapGesture)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let userStatusTaggedLabel = {
        let insetLabel = InsetLabel()
        
        insetLabel.topInset = 3
        insetLabel.bottomInset = 3
        insetLabel.leftInset = 8
        insetLabel.rightInset = 8
        
        // Placeholder
        insetLabel.text = L10n.PromiseStatusWithUserView.Tag.notStart
        insetLabel.font = UIFont(font: FontFamily.Pretendard.regular, size: 12)
        insetLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        insetLabel.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        
        insetLabel.layer.masksToBounds = true
        insetLabel.layer.cornerRadius = 9
        insetLabel.sizeToFit()
        
        insetLabel.translatesAutoresizingMaskIntoConstraints = false
        return insetLabel
    }()
    
    private let userSharingStateTaggedLabel = {
        let insetLabel = InsetLabel()
        
        insetLabel.topInset = 3
        insetLabel.bottomInset = 3
        insetLabel.leftInset = 8
        insetLabel.rightInset = 8
        
        // Placeholder
        insetLabel.text = L10n.PromiseStatusWithUserView.Tag.sharingOn
        insetLabel.font = UIFont(font: FontFamily.Pretendard.regular, size: 12)
        insetLabel.textColor = UIColor(red: 0.02, green: 0.675, blue: 0.557, alpha: 1)
        insetLabel.backgroundColor = UIColor(red: 0.902, green: 0.976, blue: 0.961, alpha: 1)
        
        insetLabel.layer.masksToBounds = true
        insetLabel.layer.cornerRadius = 9
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
            departureLocationLabel,
            departureLocationWrapper,
            userStatusLabel,
            userStatusLight,
            userStatusTaggedLabel,
            userSharingStateLabel,
            userSharingStateLight,
            userSharingStateTaggedLabel
        ].forEach { addSubview($0) }
        
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            departureLocationLabel.topAnchor.constraint(equalTo: topAnchor, constant: adjustedValue(36, .height)),
            departureLocationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            
            departureLocationWrapper.topAnchor.constraint(equalTo: departureLocationLabel.bottomAnchor, constant: adjustedValue(6, .height)),
            departureLocationWrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            departureLocationWrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: adjustedValue(-24, .width)),
            
            userStatusLabel.topAnchor.constraint(equalTo: departureLocationWrapper.bottomAnchor, constant: adjustedValue(18, .height)),
            userStatusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            
            userStatusLight.leadingAnchor.constraint(equalTo: userStatusLabel.trailingAnchor),
            userStatusLight.centerYAnchor.constraint(equalTo: userStatusLabel.centerYAnchor),
            
            userStatusTaggedLabel.topAnchor.constraint(equalTo: userStatusLabel.bottomAnchor, constant: adjustedValue(12, .height)),
            userStatusTaggedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            
            userSharingStateLabel.topAnchor.constraint(equalTo: userStatusTaggedLabel.bottomAnchor, constant: adjustedValue(18, .height)),
            userSharingStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            
            userSharingStateLight.leadingAnchor.constraint(equalTo: userSharingStateLabel.trailingAnchor),
            userSharingStateLight.centerYAnchor.constraint(equalTo: userSharingStateLabel.centerYAnchor),
            
            userSharingStateTaggedLabel.topAnchor.constraint(equalTo: userSharingStateLabel.bottomAnchor, constant: adjustedValue(12, .height)),
            userSharingStateTaggedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
        ])
    }
}

extension PromiseStatusWithUserView {
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
