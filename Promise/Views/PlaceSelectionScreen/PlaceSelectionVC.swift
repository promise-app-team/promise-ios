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
    weak var delegate: PlaceSelectionDelegate?
    
    let screenTitle = {
        let label = UILabel()
        label.text = "장소 선택 화면을 구현해주세요."
        label.font = UIFont(font: FontFamily.Pretendard.semiBold, size: 15)
        label.textColor = .black
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            screenTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            screenTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
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
    
    func configureAccountVC() {
        view.backgroundColor = .white
    }
    
    func render() {
        [screenTitle].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
}
