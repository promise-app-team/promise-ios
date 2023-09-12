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
        
        //프로필 수정하기 버튼
        let button = Button()
        button.initialize(title: "프로필 수정하기", style: .primary, iconTitle: "", disabled: false)
        
        //사용자 이름과 버튼을 묶는 버티컬스택뷰
        let verticalStackView = UIStackView(arrangedSubviews: [label, button])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.spacing = 8
        
        //프로필 사진과 버티컬스택뷰(사용자이름, 버튼)을 묶는 스택뷰
        let stackView = UIStackView(arrangedSubviews: [imageView, verticalStackView])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 16
        
        //테이블뷰
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = 96
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(stackView)
        view.addSubview(tableView)
   
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
             imageView.widthAnchor.constraint(equalToConstant: 76),
             imageView.heightAnchor.constraint(equalToConstant: 76),
             label.widthAnchor.constraint(equalToConstant: 253),
             label.heightAnchor.constraint(equalToConstant: 36),
             button.widthAnchor.constraint(equalToConstant: 253),
             button.heightAnchor.constraint(equalToConstant: 36),
             verticalStackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -24),
             stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 103),
             stackView.heightAnchor.constraint(equalToConstant: 128),
             tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 4),
             tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -393)
        ])
    }
    
    
    @objc private func backBtnTapped() {
        print("뒤로가기 버튼")
    }
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 섹션당 행의 개수를 반환
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // 각 행에 텍스트와 " > " 표시 추가
        let options = ["지난 약속", "자주 묻는 질문", "환경설정", "로그아웃"]
        cell.textLabel?.text = options[indexPath.row]
        cell.accessoryType = .disclosureIndicator // " > " 표시
        
        // 텍스트 레이블 위 아래 여백 설정
        let topInset: CGFloat = 16
        let bottomInset: CGFloat = 16
        cell.contentView.layoutMargins = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        cell.contentView.preservesSuperviewLayoutMargins = false
        
        return cell
    }
    
    // 각 행의 높이를 설정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 각 행의 높이를 원하는 크기로 반환 (예: 96 포인트)
        return 56
    }
    
    // 테이블 뷰의 행을 선택했을 때 실행할 동작을 정의 (예: 다른 페이지로 이동)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택한 행에 따라 적절한 동작 수행
        switch indexPath.row {
        case 0:
            // "지난 약속" 선택 시 실행할 동작
            break
        case 1:
            // "자주 묻는 질문" 선택 시 실행할 동작
            break
        case 2:
            // "환경설정" 선택 시 실행할 동작
            break
        case 3:
            // "로그아웃" 선택 시 실행할 동작
            break
        default:
            break
        }
    }
}

