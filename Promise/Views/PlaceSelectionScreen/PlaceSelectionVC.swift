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
    
    // MARK: Public Property
    
    weak var delegate: PlaceSelectionDelegate?
    
    // MARK: Private Property
    
    private let textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private lazy var headerView: HeaderView = {
        let headerView = HeaderView(navigationController: nil, title: "약속장소 설정")
        headerView.delegate = self
        return headerView
    }()
    
    // MARK: View Life Cycle
    
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
    
    // MARK: Private Function
    
    private func configureAccountVC() {
        view.backgroundColor = .white
    }
    
    private func render() {
        [headerView].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
}

// MARK: HeaderViewDelegate

extension PlaceSelectionVC: HeaderViewDelegate {
    
    func onTapCustomBackAction() {
        dismiss(animated: true)
    }
}
