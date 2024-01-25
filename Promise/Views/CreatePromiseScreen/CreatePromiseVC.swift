//
//  CreatePromiseVC.swift
//  Promise
//
//  Created by dylan on 2023/08/15.
//

import Foundation
import UIKit

protocol CreatePromiseDelegate: AnyObject {
    func onDidCreatePromise(createdPromise: Components.Schemas.OutputCreatePromise)
}

class CreatePromiseVC: UIViewController {
    weak var delegate: CreatePromiseDelegate?
    
    private lazy var createPromiseVM = CreatePromiseVM(currentVC: self)
    
    private lazy var headerView = HeaderView(navigationController: createPromiseVM.currentVC?.navigationController, title: L10n.CreatePromise.headerTitle)
    
    private lazy var formView = FormView(vm: createPromiseVM)
    
    private lazy var createPromiseButton = {
        let button = Button()
        button.initialize(
            title: L10n.CreatePromise.createPromiseButtonTitle,
            style: .primary,
            iconTitle: "",
            disabled: true //TODO: 폼 입력 여부에 따라 활성화
        )
        
        button.addTarget(self, action: #selector(onTapCreatePromiseButton), for: .touchUpInside)
        return button
    }()
    
    @objc func onTapCreatePromiseButton() {
        createPromiseVM.submit { [weak self] createdPromise in
            guard let createdPromise else { return }
            self?.delegate?.onDidCreatePromise(createdPromise: createdPromise)
            
            DispatchQueue.main.async {
                let completedCreatePromiseVC = CompletedCreatePromiseVC()
                completedCreatePromiseVC.createdPromiseId = Int(createdPromise.pid)
                self?.navigationController?.pushViewController(completedCreatePromiseVC, animated: true)
            }
        }
    }
    
    func setupAutoLayout() {
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 56),
            headerView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            formView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            formView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            formView.bottomAnchor.constraint(equalTo: createPromiseButton.topAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            createPromiseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            createPromiseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            createPromiseButton.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -20),
            createPromiseButton.heightAnchor.constraint(equalToConstant: Button.Height + 3),
        ])
    }
    
    func assignOnVaildateForm() {
        createPromiseVM.assignOnVaildateForm = { [weak self] isVaild in
            guard let self else { return }
            
            DispatchQueue.main.async {
                if(isVaild) {
                    self.createPromiseButton.isDisabled = false
                } else {
                    self.createPromiseButton.isDisabled = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assignOnVaildateForm()
        configureCreatePromiseVC()
        render()
    }
    
    func configureCreatePromiseVC() {
        view.backgroundColor = .white
        KeyboardManager.shared.delegate = self
        KeyboardManager.shared.registerVC(self)
    }
    
    func render() {
        [
            headerView,
            formView,
            createPromiseButton,
        ].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
}

extension CreatePromiseVC: KeyboardManagerDelegate {}
