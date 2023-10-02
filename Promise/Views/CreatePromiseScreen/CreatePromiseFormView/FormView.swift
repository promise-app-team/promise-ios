//
//  FormView.swift
//  Promise
//
//  Created by dylan on 2023/08/28.
//

import Foundation
import UIKit

class FormView: UIScrollView {
    private var createPromiseVM: CreatePromiseVM
    
    private lazy var formTitleView = FormTitleView(vm: createPromiseVM)
    private lazy var formDateView = FormDateView(vm: createPromiseVM)
    private lazy var formThemeView = FormThemeView(vm: createPromiseVM)
    private lazy var formPlaceView = FormPlaceView(vm: createPromiseVM)
    private lazy var formshareLocationStartTimeView = FormShareLocationStartTimeView(vm: createPromiseVM)
    private lazy var formshareLocationEndTimeView = FormShareLocationEndTimeView(vm: createPromiseVM)
    
    private lazy var formStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            formTitleView,
            formDateView,
            formThemeView,
            formPlaceView,
            formshareLocationStartTimeView,
            formshareLocationEndTimeView,
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let contentView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(vm: CreatePromiseVM) {
        self.createPromiseVM = vm
        super.init(frame: .null)
        configureFormView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFormView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        [contentView].forEach { addSubview($0) }
        [formStackView].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // MARK: 중요! 스크롤 뷰에서 높이는 설정하지 않고 넒이만 설정
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            formStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            formStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            formStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            formStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
