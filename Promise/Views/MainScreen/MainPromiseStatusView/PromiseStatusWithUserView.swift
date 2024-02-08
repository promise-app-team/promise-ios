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
    
    private let userSharingStateLabel = {
        let label = UILabel()
        
        label.text = L10n.PromiseStatusWithUserView.Label.userSharingState
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let departureLocation = {
        let label = UILabel()
        
        label.font = UIFont(font: FontFamily.Pretendard.semiBold, size: adjustedValue(16, .width))
        
        // Placeholder
        label.textColor = UIColor(red: 1, green: 0.408, blue: 0.304, alpha: 1)
        label.text = L10n.PromiseStatusWithUserView.departureLocationPlaceholder
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let departureLocationEditIcon = {
        let imageView = UIImageView(image: Asset.editRed.image) // Placeholder icon
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.widthAnchor.constraint(equalToConstant: adjustedValue(16, .width)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(16, .height)).isActive = true
        
        return imageView
    }()
    
    private lazy var departureLocationWrapper = {
        let view = UIView()
        [departureLocation, departureLocationEditIcon].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            departureLocation.topAnchor.constraint(equalTo: view.topAnchor),
            departureLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            departureLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            departureLocationEditIcon.leadingAnchor.constraint(equalTo: departureLocation.trailingAnchor, constant: adjustedValue(4, .width)),
            departureLocationEditIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userStatus = {
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
    
    private let userSharingState = {
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
        
    }
    
    private func render() {
        [
            departureLocationLabel,
            departureLocationWrapper,
            userStatusLabel,
            userStatus,
            userSharingStateLabel,
            userSharingState
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
            
            userStatus.topAnchor.constraint(equalTo: userStatusLabel.bottomAnchor, constant: adjustedValue(12, .height)),
            userStatus.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            
            userSharingStateLabel.topAnchor.constraint(equalTo: userStatus.bottomAnchor, constant: adjustedValue(18, .height)),
            userSharingStateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            
            userSharingState.topAnchor.constraint(equalTo: userSharingStateLabel.bottomAnchor, constant: adjustedValue(12, .height)),
            userSharingState.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
        ])
    }
}

extension PromiseStatusWithUserView {
    public func updatePromiseStatusWithUser(with promise: Components.Schemas.OutputPromiseListItem) {
        print("promise")
    }
}
