//
//  AccountVC.swift
//  Promise
//
//  Created by dylan on 2023/08/14.
//

import Foundation
import UIKit

class AccountVC: UIViewController, HeaderViewDelegate {
    
    private lazy var signInVM = SignInVM(currentVC: self)
    
    //바탕뷰(회색)
    let backgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        return view
    }()
    
    //헤더
     lazy var headerView: HeaderView = {
        let navigationController = self.navigationController
        let title = L10n.Account.headerTitle
        let headerView = HeaderView(navigationController: navigationController, title: title)
        headerView.backgroundColor = .white
        return headerView
    }()

    //프로필사진
    lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 76, height: 76)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "profile")
        return imageView
    }()
    
    lazy var statusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "Ellipse 3")
        return imageView
    }()
    
    //사용자 이름
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "김지수"
        label.textColor = .black
        label.font = UIFont.pretendard(style: .H1_B)
        label.textAlignment = .left
        return label
    }()
    
    //프로필 수정 버튼
    lazy var button: Button = {
        let button = Button()
        button.initialize(title: L10n.Account.editProfile, style: .primary, iconTitle: "", disabled: false)
        button.addTarget(self, action: #selector(profileEditButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //사용자 이름과 버튼을 묶은 스택뷰
    lazy var labelBtnStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.label, self.button])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        return stackView
    }()
    
    //프로필 사진과 스택뷰(사용자 이름, 버튼)를 묶은 스택뷰
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.userImage, self.labelBtnStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.backgroundColor = .white
        return stackView
    }()
    
    //테이블 뷰
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = 96
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    //"앱 버전" 텍스트
    lazy var appLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Account.appVer
        label.textColor = UIColor(hexCode: "#CCCCCC", alpha: 1)
        label.font = UIFont.pretendard(style: .B1_R)
        label.textAlignment = .left
        return label
    }()
    
    //앱 버전
    lazy var verLabel: UILabel = {
        let label = UILabel()
        label.text = "1.0.0(3088)"
        label.textColor = UIColor(hexCode: "#CCCCCC", alpha: 1)
        label.font = UIFont.pretendard(style: .B1_R)
        label.textAlignment = .left
        return label
    }()
    
    //앱 버전 텍스트와 앱 버전을 묶은 스택뷰
    lazy var appVerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.appLabel, self.verLabel])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.delegate = self
        configureAccountVC()
        render()
    }
    
    @objc func profileEditButtonTapped() {
        if let navigationController = navigationController {
            navigationController.pushViewController(EditProfileVC(), animated: true)
        }
    }
    
    func configureAccountVC() {
        view.backgroundColor = .white
    }
    
    func render() {
        [backgroundView, headerView, statusImage, stackView, tableView, appVerStackView].forEach { view.addSubview($0) }
        [backgroundView, headerView, statusImage, stackView, tableView, appVerStackView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        view.bringSubviewToFront(statusImage)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        setupAutoLayout()
    }
    
    func setupAutoLayout() {
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 76),
            userImage.heightAnchor.constraint(equalToConstant: 76),
            userImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            label.widthAnchor.constraint(equalToConstant: 253),
            label.heightAnchor.constraint(equalToConstant: 36),
            button.widthAnchor.constraint(equalToConstant: 253),
            button.heightAnchor.constraint(equalToConstant: 36),
            labelBtnStackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -24),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            stackView.heightAnchor.constraint(equalToConstant: 128),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusImage.widthAnchor.constraint(equalToConstant: 20),
            statusImage.heightAnchor.constraint(equalToConstant: 20),
            statusImage.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 86),
            statusImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 80),
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(4 * 56)),//행 개수 * 행 높이
            appLabel.widthAnchor.constraint(equalToConstant: 254),
            appVerStackView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 16),
            appVerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
    }
    
}

extension AccountVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //행 개수 리터
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let options = [L10n.Account.lastPromise, L10n.Account.faq, L10n.Account.setting, L10n.Account.logout]
        cell.textLabel?.text = options[indexPath.row]
        
        let nextImgView = UIImageView(image: UIImage(named: "Navigate next"))
        nextImgView.frame = CGRect(x: 353, y: 20, width: 16, height: 16)
        cell.accessoryView = nextImgView

        cell.selectionStyle = .none
        
        //레이블 위, 왼쪽 여백 설정
        let leftInset: CGFloat = 24
        if let label = cell.textLabel {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: leftInset).isActive = true
            label.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
       }
        return cell
    }
    
    //각 행의 높이 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    //테이블뷰 각 행의 따른 페이지로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var viewController: UIViewController;
        switch indexPath.row {
        case 0:
            // "지난 약속"
            viewController = LastPromiseVC()
            if let navigationController = self.navigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
            break
        case 1:
            // "자주 묻는 질문"
            let viewController = FAQVC()
            if let navigationController = self.navigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
            break
        case 2:
            // "환경설정"
            let viewController = SettingsVC()
            if let navigationController = self.navigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
            break
        case 3:
            // "로그아웃"
            UserService.shared.signOut(currentVC: self)
            break
        default:
            break
        }
    }
}

