//
//  PlaceSelectionVC.swift
//  Promise
//
//  Created by dylan on 2023/09/26.
//

import Foundation
import UIKit

@objc protocol PlaceSelectionDelegate: AnyObject {
    @objc optional func onWillShow()
    @objc optional func onWillHide()
    @objc optional func onDidShow()
    @objc optional func onDidHide()
}

class PlaceSelectionVC: UIViewController {
    // MARK: - Public Property
    
    weak var delegate: PlaceSelectionDelegate?
    
    // MARK: - Private Property
    
    private lazy var headerView: HeaderView = {
        let view = HeaderView(navigationController: nil, title: "약속장소 설정")
        view.delegate = self
        return view
    }()
    private let textField: TextField = {
        let textField = TextField()
        textField.initialize(placeHolder: "도로명, 지번, 건물명 검색", showSearchIcon: true)
        return textField
    }()
    
    private let screenTitle = {
        let label = UILabel()
        label.text = "장소 선택 화면을 구현해주세요."
        label.font = UIFont(font: FontFamily.Pretendard.semiBold, size: 15)
        label.textColor = .black
        return label
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAccountVC()
        render()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onWillShow?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.onDidShow?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.onWillHide?()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.onDidHide?()
    }
    
    // MARK: - Overide Function
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Private Function
    
    private func configureAccountVC() {
        view.backgroundColor = .white
    }
    
    private func render() {
        [headerView, textField, screenTitle].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),
            
            textField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - HeaderViewDelegate

extension PlaceSelectionVC: HeaderViewDelegate {
    func onTapCustomBackAction() {
        self.dismiss(animated: true)
    }
}
