//
//  SettingsVC.swift
//  Promise
//
//  Created by zzee22su on 2023/07/22.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationBar()
    }
    
    func makeNavigationBar() {
        view.backgroundColor = UIColor {
            traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : .white
        }

        title = "설정"
        navigationController?.navigationBar.titleTextAttributes = [
                    .font: UIFont.systemFont(ofSize: 16, weight: .regular)]

        // MARK: 네이게이션바 아이템 - 이미지 색상 변경
        let backButtonImage = UIImage(named: "Chevron left")?.withRenderingMode(.alwaysOriginal)
        
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backBtnTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backBtnTapped() {
        print("뒤로가기 버튼")
    }
}
