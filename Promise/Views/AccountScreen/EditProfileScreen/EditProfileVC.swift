//
//  EditProfileVC.swift
//  Promise
//
//  Created by zzee22su on 2023/10/14.
//

import UIKit

class EditProfileVC: UIViewController, UITextFieldDelegate {
    
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

    let cameraIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Group 26086357")
        return imageView
    }()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Account.EditProfile.nickname
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        label.font = UIFont.pretendard(style: .C_B)
        label.textAlignment = .center
        return label
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.text = UserService.shared.getUser()?.nickname
        textField.placeholder = L10n.Account.EditProfile.inputNickname
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
        return textField
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        label.font = UIFont.pretendard(style: .C_R)
        label.textAlignment = .right
        return label
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let maxLength = 10
        if updatedText.count <= maxLength {
            let attributedString = NSMutableAttributedString(string: "\(updatedText.count)/\(maxLength)")
            attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1), 
                                          range: NSRange(location: 0, length: "\(updatedText.count)".count))
            countLabel.attributedText = attributedString
            return true
        } else {
            return false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAccountVC()
        render()
        clickBackgroud()
        nicknameTextField.delegate = self
    }

    func configureAccountVC() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    func render() {
        [editView, profileEditlabel, userImage, cameraIcon, nickNameLabel, nicknameTextField, countLabel].forEach { view.addSubview($0) }
        [editView, profileEditlabel, userImage, cameraIcon, nickNameLabel, nicknameTextField, countLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
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
            cameraIcon.heightAnchor.constraint(equalToConstant: 32),
            nickNameLabel.topAnchor.constraint(equalTo: editView.topAnchor, constant: 162),
            nickNameLabel.leadingAnchor.constraint(equalTo: editView.leadingAnchor, constant: 24),
            nickNameLabel.widthAnchor.constraint(equalToConstant: 32),
            nickNameLabel.heightAnchor.constraint(equalToConstant: 18),
            nicknameTextField.topAnchor.constraint(equalTo: editView.topAnchor, constant: 188),
            nicknameTextField.leadingAnchor.constraint(equalTo: editView.leadingAnchor, constant: 24),
            nicknameTextField.widthAnchor.constraint(equalToConstant: 297),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 40),
            countLabel.topAnchor.constraint(equalTo: editView.topAnchor, constant: 236),
            countLabel.leadingAnchor.constraint(equalTo: editView.leadingAnchor, constant: 281),
            countLabel.widthAnchor.constraint(equalToConstant: 40),
            countLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    @objc func backgroundTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func editViewTapped() {
        view.endEditing(true)
    }
    
}
