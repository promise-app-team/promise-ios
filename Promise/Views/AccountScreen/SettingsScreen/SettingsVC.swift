//
//  SettingsVC.swift
//  Promise
//
//  Created by zzee22su on 2023/10/14.
//

import UIKit

class SettingsVC: UIViewController {
    
    //헤더
     lazy var headerView: HeaderView = {
        let navigationController = self.navigationController
        let title = L10n.Account.setting
        let headerView = HeaderView(navigationController: navigationController, title: title)
        return headerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAccountVC()
        render()
    }
           
    func configureAccountVC() {
        view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
    }
    
    func render() {
        [headerView].forEach { view.addSubview($0) }
        [headerView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        setupAutoLayout()
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 56),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
}
