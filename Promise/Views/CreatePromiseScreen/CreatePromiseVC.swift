//
//  CreatePromiseVC.swift
//  Promise
//
//  Created by dylan on 2023/08/15.
//

import Foundation
import UIKit

protocol CreatePromiseDelegate: AnyObject {
    func onDidCreatePromise(createdPromise: Components.Schemas.PromiseDTO)
}

class CreatePromiseVC: UIViewController {
    weak var delegate: CreatePromiseDelegate?
    
    private lazy var createPromiseVM = CreatePromiseVM(currentVC: self)
    
    var editingPromise: Components.Schemas.PromiseDTO? = nil

    private lazy var headerView = {
        var headerTitle = ""
        
        if let editingPromise {
            headerTitle = L10n.CreatePromise.Edit.headerTitle
        } else {
            headerTitle = L10n.CreatePromise.Create.headerTitle
        }
        
        return HeaderView(
            navigationController: createPromiseVM.currentVC?.navigationController,
            title: headerTitle
        )
    }()
    
    
    private lazy var formView = FormView(vm: createPromiseVM)
    
    private lazy var createPromiseButton = {
        var buttonTitle = ""
        
        if let editingPromise {
            buttonTitle = L10n.CreatePromise.Edit.submitButtonTitle
        } else {
            buttonTitle = L10n.CreatePromise.Create.submitButtonTitle
        }
        
        let button = Button()
        button.initialize(
            title: buttonTitle,
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
    
    init(with promise: Components.Schemas.PromiseDTO? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.editingPromise = promise
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        render()
    }
    
    func configure() {
        view.backgroundColor = .white
        
        assignOnVaildateForm()
        
        KeyboardManager.shared.delegate = self
        KeyboardManager.shared.registerVC(self)
    }
    
    func render() {
        [
            headerView,
            formView,
            createPromiseButton,
        ].forEach { view.addSubview($0) }
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: adjustedValue(56, .height)),
            headerView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            formView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            formView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            formView.bottomAnchor.constraint(equalTo: createPromiseButton.topAnchor, constant: -adjustedValue(24, .height))
        ])
        
        NSLayoutConstraint.activate([
            createPromiseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            createPromiseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            createPromiseButton.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -adjustedValue(20, .height)),
            createPromiseButton.heightAnchor.constraint(equalToConstant: Button.Height + adjustedValue(3, .height)),
        ])
        
        // MARK: subviews가 모두 초기화 된 이후 실행
        lazyConfigureAfterInitializeSubviews()
    }
    
    func lazyConfigureAfterInitializeSubviews() {
        // MARK: 수정할 약속 세팅
        createPromiseVM.editingPromise = editingPromise

        
        Task {
            // MARK: 수정할 약속의 선택된 themes를 모든 테마를 가져올 때 초기화
            // 전체 테마를 가져오기 전에 editingPromise가 있어야 하는데
            // getSupportedTheme 내부에서 editingPromise 참조해도 되지만
            // 여기서 직접 paramater로 전달
            await createPromiseVM.getSupportedTheme(initSelectedThemes: editingPromise?.themes)
        }
        
    }
}

extension CreatePromiseVC: KeyboardManagerDelegate {}
