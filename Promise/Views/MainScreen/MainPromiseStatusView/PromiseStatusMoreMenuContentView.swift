//
//  PromiseStatusMoreMenusView.swift
//  Promise
//
//  Created by kwh on 2/27/24.
//

import Foundation
import UIKit

enum Menu {
    case edit
    case delegate
    case leave
}

class PromiseStatusMoreMenuContentView: UIView {
    private let mainVM: MainVM
    
    private let heightMaxHeight = adjustedValue(234, .height)
    private let heightMinHeight = adjustedValue(164, .height)
    private var heightConstraint: NSLayoutConstraint!
    
    private lazy var editLabel = {
        let label = UILabel()
        label.text = L10n.Common.MoreMenu.editPromise
        label.textColor = .black
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapEditPromise))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var delegateLabel = {
        let label = UILabel()
        label.text = L10n.Common.MoreMenu.delegatePromise
        label.textColor = .black
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapDelegatePromise))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    private lazy var leaveLabel = {
        let label = UILabel()
        label.text = L10n.Common.MoreMenu.leavePromise
        label.textColor = UIColor(red: 1, green: 0.408, blue: 0.304, alpha: 1)
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapLeavePromise))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cancelButton = {
        let button = Button()
        button.initialize(title: L10n.Common.cancel, style: .secondary)
        button.addTarget(self, action: #selector(onTapCancelMoreMenuButton), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var dynamicMenus = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: handler
    
    @objc private func onTapEditPromise() {
        // TODO:
        print(#function)
    }
    
    @objc private func onTapDelegatePromise() {
        // TODO:
        print(#function)
    }
    
    @objc private func onTapLeavePromise() {
        CommonModalManager.shared.dismiss {
            self.mainVM.promiseStatusContainer?.moveHalf()
        }
        
        mainVM.leavePromise()
    }
    
    @objc private func onTapCancelMoreMenuButton() {
        CommonModalManager.shared.dismiss()
    }
    
    // MARK: initialize
    
    init(mv: MainVM) {
        self.mainVM = mv
        super.init(frame: .null)
        
        configure()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        
        heightConstraint = heightAnchor.constraint(equalToConstant: heightMinHeight)
        heightConstraint.isActive = true
    }
    
    private func render() {
        [dynamicMenus, cancelButton].forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            dynamicMenus.topAnchor.constraint(equalTo: topAnchor, constant: adjustedValue(26, .height)),
            dynamicMenus.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            dynamicMenus.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -adjustedValue(24, .width)),
            dynamicMenus.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -adjustedValue(22, .height)),
            
            
            cancelButton.heightAnchor.constraint(equalToConstant: Button.Height),
            cancelButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: adjustedValue(24, .width)),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -adjustedValue(24, .width)),
            cancelButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -adjustedValue(14, .height))
        ])
    }
}

extension PromiseStatusMoreMenuContentView {
    public func updateMenus(menus: [Menu]) {
        if menus.count > 1 {
            heightConstraint.constant = heightMaxHeight
        } else {
            heightConstraint.constant = heightMinHeight
        }
        
        dynamicMenus.arrangedSubviews.forEach {
            dynamicMenus.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        
        menus.forEach { menu in
            
            switch menu {
            case .edit:
                dynamicMenus.addArrangedSubview(editLabel)
                break
            case .delegate:
                dynamicMenus.addArrangedSubview(delegateLabel)
                break
            case .leave:
                 dynamicMenus.addArrangedSubview(leaveLabel)
                break
            }
            
        }
        
    }
}
