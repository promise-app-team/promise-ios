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
//        makeNavigationBar()
        makeProfileUI()
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
    
    func makeProfileUI() {
        //사용자 프로필
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 76, height: 76))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "profile")
        
        //사용자 이름
        let label = UILabel()
        label.text = "김지수"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.pretendard(style: .H1_B)
        label.textAlignment = .left
        
        let button = Button()
        button.initialize(title: "프로필 수정하기", style: .primary, iconTitle: "", disabled: false)
        
        let verticalStackView = UIStackView(arrangedSubviews: [label, button])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.spacing = 8
        
        let stackView = UIStackView(arrangedSubviews: [imageView, verticalStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 이미지 뷰의 크기 설정
             imageView.widthAnchor.constraint(equalToConstant: 76),
             imageView.heightAnchor.constraint(equalToConstant: 76),
             label.widthAnchor.constraint(equalToConstant: 253),
             label.heightAnchor.constraint(equalToConstant: 36),
             button.widthAnchor.constraint(equalToConstant: 253),
             button.heightAnchor.constraint(equalToConstant: 36),
             stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 103)
        ])
    }
    
    @objc private func backBtnTapped() {
        print("뒤로가기 버튼")
    }
}
