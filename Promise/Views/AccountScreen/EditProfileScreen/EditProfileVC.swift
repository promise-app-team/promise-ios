//
//  EditProfileVC.swift
//  Promise
//
//  Created by zzee22su on 2023/10/14.
//

import UIKit

class EditProfileVC: UIViewController {
    
    let editView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        return view
    }()
    
    let profileEditlabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Account.EditProfile.editProfile
        label.textColor = .black
        label.font = UIFont.pretendard(style: .H2_B)
        label.textAlignment = .center
        return label
    }()
    
    lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 76, height: 76)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        if let user = UserService.shared.getUser() {
            if let profileUrl = user.profileUrl {
                print(profileUrl)
                DispatchQueue.global().async {
                    if let url = URL(string: profileUrl), let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            self.userImage.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
        return imageView
    }()

    lazy var cameraIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Group 26086357")
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAccountVC()
        render()
        clickBackgroud()
    }

    func configureAccountVC() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    func render() {
        [editView, profileEditlabel, userImage, cameraIcon].forEach { view.addSubview($0) }
        [editView, profileEditlabel, userImage, cameraIcon].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        setupAutoLayout()
    }
    
    func clickBackgroud() {
        let backgroundGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        view.addGestureRecognizer(backgroundGesture)
        
        let editViewGesture = UITapGestureRecognizer(target: self, action: #selector(editViewTapped))
           editView.addGestureRecognizer(editViewGesture)
    }

    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            editView.topAnchor.constraint(equalTo: view.topAnchor, constant: 259),
            editView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            editView.widthAnchor.constraint(equalToConstant: 345),
            editView.heightAnchor.constraint(equalToConstant: 334),
            profileEditlabel.leadingAnchor.constraint(equalTo: editView.leadingAnchor, constant: 24),
            profileEditlabel.topAnchor.constraint(equalTo: editView.topAnchor, constant: 24),
            profileEditlabel.widthAnchor.constraint(equalToConstant: 297),
            profileEditlabel.heightAnchor.constraint(equalToConstant: 30),
            userImage.topAnchor.constraint(equalTo: editView.topAnchor, constant: 70),
            userImage.leadingAnchor.constraint(equalTo: editView.leadingAnchor, constant: 134),
            userImage.widthAnchor.constraint(equalToConstant: 76),
            userImage.heightAnchor.constraint(equalToConstant: 76),
            cameraIcon.topAnchor.constraint(equalTo: editView.topAnchor, constant: 114),
            cameraIcon.leadingAnchor.constraint(equalTo: editView.leadingAnchor, constant: 178),
            cameraIcon.widthAnchor.constraint(equalToConstant: 32),
            cameraIcon.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @objc func backgroundTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func editViewTapped() {

    }

}
