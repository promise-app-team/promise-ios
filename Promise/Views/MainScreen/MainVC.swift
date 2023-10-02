//
//  ViewController.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import UIKit

final class MainVC: UIViewController {
    private lazy var mainVM = MainVM(currentVC: self)
        
    private lazy var headerView = HeaderView(mainVM: mainVM)
    private lazy var promiseListView = PromiseListView(dataSource: mainVM, delegate: mainVM)
    
    private lazy var promiseAddButton = {
        let button = Button()
        button.initialize(title: L10n.Main.addNewPromise, style: .primary, iconTitle: Asset.circleOutlinePlusWhite.name)
        
        button.addTarget(self, action: #selector(onTapPromiseAddButton), for: .touchUpInside)
        return button
    }()
    
    private let probee = {
        let imageView = UIImageView(image: Asset.probee.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var promiseStatusViewArea = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let promiseStatusViewContent = PromiseStatusView()
    private lazy var promiseStatusViewController = CommonFloatingContainerVC(contentViewController: promiseStatusViewContent, currentViewController: self)
    
    private func showPromiseStatusView() {
        promiseStatusViewController.setDelegate(mainVM)
        promiseStatusViewController.readyToParent()
        promiseStatusViewController.show()
        
    }
    
    @objc private func onTapPromiseAddButton() {
        mainVM.navigateCreatePromiseScreen()
    }
    
    private func setupAutoLayout() {
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            headerView.heightAnchor.constraint(equalToConstant: 8 + 8 + 36)
        ])
        
        NSLayoutConstraint.activate([
            promiseListView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            promiseListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            promiseListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            promiseListView.bottomAnchor.constraint(equalTo: promiseAddButton.topAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            probee.widthAnchor.constraint(equalToConstant: 51),
            probee.heightAnchor.constraint(equalToConstant: 35),
            probee.leadingAnchor.constraint(equalTo: promiseListView.leadingAnchor, constant: 60),
            probee.bottomAnchor.constraint(equalTo: promiseListView.topAnchor, constant: 2),
            
        ])

        NSLayoutConstraint.activate([
            promiseAddButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            promiseAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            promiseAddButton.bottomAnchor.constraint(equalTo: promiseStatusViewArea.topAnchor, constant: -24),
            
            promiseAddButton.heightAnchor.constraint(equalToConstant: Button.Height),
        ])
        
        NSLayoutConstraint.activate([
            promiseStatusViewArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            promiseStatusViewArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            promiseStatusViewArea.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            promiseStatusViewArea.heightAnchor.constraint(equalToConstant: 270)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainVC()
        render()
        
        print(UserService.shared.getAccessToken())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPromiseStatusView()
    }
    
    private func configureMainVC() {
        view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
    }
    
    private func render() {
        [
         headerView,
         promiseListView,
         probee,
         promiseAddButton,
         promiseStatusViewArea,
        ].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
}

