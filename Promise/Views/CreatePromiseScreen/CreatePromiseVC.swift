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
    func onDidUpdatePromise(updatedPromise: Components.Schemas.PromiseDTO)
}

extension CreatePromiseDelegate {
    func onDidCreatePromise(createdPromise: Components.Schemas.PromiseDTO) {
        // 기본적으로 아무 작업도 수행하지 않음
    }

    func onDidUpdatePromise(updatedPromise: Components.Schemas.PromiseDTO) {
        // 기본적으로 아무 작업도 수행하지 않음
    }
}

class CreatePromiseVC: UIViewController {
    weak var delegate: CreatePromiseDelegate?
    
    private lazy var createPromiseVM = CreatePromiseVM(currentVC: self)
    
    var editingPromise: Components.Schemas.PromiseDTO? = nil

    private lazy var header = {
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
        
        button.heightAnchor.constraint(equalToConstant: Button.Height).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func onTapCreatePromiseButton() {
        createPromiseVM.submit { [weak self] promise in
            guard let promise else { return }
            
            if let _ = self?.editingPromise {
                self?.delegate?.onDidUpdatePromise(updatedPromise: promise)
            } else {
                self?.delegate?.onDidCreatePromise(createdPromise: promise)
                
                DispatchQueue.main.async {
                    let completedCreatePromiseVC = CompletedCreatePromiseVC()
                    completedCreatePromiseVC.createdPromiseId = Int(promise.pid)
                    self?.navigationController?.pushViewController(completedCreatePromiseVC, animated: true)
                }
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
            header,
            formView,
            createPromiseButton,
        ].forEach { view.addSubview($0) }
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            formView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: adjustedValue(16, .height)),
            formView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            formView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            formView.bottomAnchor.constraint(equalTo: createPromiseButton.topAnchor, constant: -adjustedValue(24, .height))
        ])
        
        NSLayoutConstraint.activate([
            createPromiseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            createPromiseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            createPromiseButton.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -adjustedValue(16, .height))
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
