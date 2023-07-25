//
//  WebsocketVC.swift
//  Promise
//
//  Created by 신동오 on 2023/07/22.
//

import UIKit
import CoreLocation

enum Status {
    case connect
    case disconnect
}

class WebsocketVC: UIViewController {
    
    var labelCount = 1
    
    private var websocketStatus: Status = .disconnect {
        didSet {
            switch websocketStatus {
            case .connect:
                toTextField.isEnabled = false
                toTextField.backgroundColor = .lightGray
                segmentedControl.isEnabled = false
                statusImageView.tintColor = UIColor.green
            case .disconnect:
                switch self.segmentedControl.selectedSegmentIndex {
                case 0:
                    toTextField.isEnabled = false
                    toTextField.backgroundColor = .lightGray
                case 1:
                    toTextField.isEnabled = true
                    toTextField.backgroundColor = .white
                default:
                    break
                }
                segmentedControl.isEnabled = true
                statusImageView.tintColor = UIColor.red
            }
        }
    }
    
    // MARK: - Labels
    
    let settingInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let logInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "로그"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let connectInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "연결"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let toLabel: UILabel = {
        let label = UILabel()
        label.text = "to"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "연결 상태"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Image
    
    let statusImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "circle.fill")
        imageView.tintColor = UIColor.red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - TextFields
    
    lazy var toTextField = UITextField(defaultValue: "broadcast", isEnabled: false)
    lazy var sendMessageTextField = UITextField(defaultValue: "기본 메세지 입니다")
    
    // MARK: - Segmented control
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["broadcast", "직접입력"])
        control.tintColor = .white
        control.backgroundColor = .lightGray
        
        control.selectedSegmentTintColor = .black
        control.selectedSegmentIndex = 0
        control.addTarget(nil, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    // MARK: - Buttons
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("전송", for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(nil, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let connectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("connect()", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(nil, action: #selector(connectButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let disconnectButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("disconnect()", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.addTarget(nil, action: #selector(disconnectButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - ScrollView
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemGray6
        scrollView.contentInsetAdjustmentBehavior = .always
        scrollView.backgroundColor = .black
        return scrollView
    }()
    
    // MARK: - Services
    
    let locationService = LocationService()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        
        // configure CLLocation
        locationService.mgr.delegate = self
        locationService.start()
        
        super.viewDidLoad()
        setupUI()
        
        toTextField.delegate = self
        sendMessageTextField.delegate = self
        
        
        
        // 터치 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        // NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivedStatus(_:)), name: .receivedStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivedText(_:)), name: .receivedText, object: nil)
        
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(settingInfoLabel)
        view.addSubview(segmentedControl)
        view.addSubview(toLabel)
        view.addSubview(toTextField)
        
        view.addSubview(logInfoLabel)
        view.addSubview(connectButton)
        view.addSubview(sendMessageTextField)
        
        view.addSubview(scrollView)
        
        view.addSubview(connectInfoLabel)
        view.addSubview(statusImageView)
        view.addSubview(statusLabel)
        view.addSubview(sendButton)
        view.addSubview(disconnectButton)
        
        
        NSLayoutConstraint.activate([
            
            settingInfoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            segmentedControl.centerYAnchor.constraint(equalTo: settingInfoLabel.centerYAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 25),
            
            toLabel.topAnchor.constraint(equalTo: settingInfoLabel.bottomAnchor, constant: 15),
            toLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            toTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toTextField.widthAnchor.constraint(equalToConstant: 160),
            toTextField.centerYAnchor.constraint(equalTo: toLabel.centerYAnchor),
            
            logInfoLabel.topAnchor.constraint(equalTo: toTextField.bottomAnchor, constant: 20),
            logInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            scrollView.topAnchor.constraint(equalTo: logInfoLabel.bottomAnchor, constant: 15),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 160),
            
            sendMessageTextField.topAnchor.constraint(equalTo:scrollView.bottomAnchor, constant: 15),
            sendMessageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sendMessageTextField.widthAnchor.constraint(equalToConstant: 280),
            
            sendButton.topAnchor.constraint(equalTo: sendMessageTextField.topAnchor),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            
            connectInfoLabel.topAnchor.constraint(equalTo: sendMessageTextField.bottomAnchor, constant: 20),
            connectInfoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            statusImageView.topAnchor.constraint(equalTo: connectInfoLabel.topAnchor),
            statusImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            statusLabel.topAnchor.constraint(equalTo: connectInfoLabel.bottomAnchor, constant: 15),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            connectButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 15),
            connectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            connectButton.widthAnchor.constraint(equalToConstant: 170),
            connectButton.heightAnchor.constraint(equalToConstant: 30),
            
            disconnectButton.topAnchor.constraint(equalTo: connectButton.topAnchor),
            disconnectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            disconnectButton.widthAnchor.constraint(equalToConstant: 170),
            disconnectButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    // MARK: - @objc methods
    
    @objc func didReceivedStatus(_ notification: Notification) {
        // 전달받은 메시지를 가져오기
        if let message = notification.userInfo?["message"] as? String {
            self.statusLabel.text = message
        }
        if let status = notification.userInfo?["status"] as? Status {
            switch status {
            case .connect:
                self.websocketStatus = .connect
            case .disconnect:
                self.websocketStatus = .disconnect
                addLabel(text: "연결 종료")
            }
        }
    }
    
    @objc func didReceivedText(_ notification: Notification) {
        if let text = notification.userInfo?["text"] as? String {
            var labelText = ""
            let currentDate = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute, .second], from: currentDate)
            if let hour = components.hour, let minute = components.minute, let second = components.second {
                labelText += String(hour)
                labelText += ":"
                labelText += String(minute)
                labelText += ":"
                labelText += String(second)
                labelText += " "
            }
            labelText += text
            addLabel(text: labelText)
        }
        else {
            addLabel(text: "데이터 수신 오류")
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true) // 뷰를 탭하면 키보드가 닫힘
    }
    
    @objc func sendButtonTapped() {
        WebSocketService.shared.sendDataToServer(message: sendMessageTextField.text ?? "client-message")
    }
    
    @objc func connectButtonTapped() {
        let textWithoutSpace = toTextField.text?.replacingOccurrences(of: " ", with: "") ?? ""
        let clientID = textWithoutSpace != "" ? textWithoutSpace : "broadcast"
        WebSocketService.shared.connect(to: clientID)
    }
    
    @objc func disconnectButtonTapped() {
        WebSocketService.shared.disconnect()
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
            if sender.selectedSegmentIndex == 0 {
                toTextField.isEnabled = false
                toTextField.backgroundColor = .lightGray
                toTextField.text = "broadcast"
            }
            else if sender.selectedSegmentIndex == 1 {
                toTextField.text = ""
                toTextField.backgroundColor = .white
                toTextField.isEnabled = true
            }
    }
    
    func addLabel(text: String) {
        let label = UILabel()
        
        label.textColor = .white
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        
        scrollView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
//            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            label.heightAnchor.constraint(equalToConstant: 20),
            label.topAnchor.constraint(
                equalTo: scrollView.topAnchor,
                constant: CGFloat(120 + (labelCount - 1) * 20) + CGFloat((labelCount - 1) * 10)
            )
        ])
        
        scrollView.contentSize = CGSize(
            width: view.frame.width * 1.5,
            height: CGFloat(120 + labelCount * 20 + (labelCount) * 10)
        )
        
        scrollView.scrollRectToVisible(CGRect(x: scrollView.contentOffset.x, y: CGFloat(labelCount*30), width: scrollView.bounds.size.width - 40, height: scrollView.bounds.size.height), animated: true)
        
        labelCount += 1
    }
}

// MARK: - Extension: UITextFieldDelegate

extension WebsocketVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Extension: UITextField

extension UITextField {
    convenience init(defaultValue: String, isEnabled: Bool = true) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 6
        
        tintColor = .blue
        font = UIFont.systemFont(ofSize: 12)
        layer.cornerRadius = 5
        
        // text
        text = defaultValue
        textAlignment = .center
        textColor = .black
        
        heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.isEnabled = isEnabled
        if isEnabled == false {
            self.backgroundColor = .lightGray
        }
    }
    
}

extension WebsocketVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var text = ""
        switch UIApplication.shared.applicationState {
        case .active:
           text = "active"
        case .background:
            text = "background"
        case .inactive:
            text = "inactive"
        @unknown default:
            text = "unknown default"
        }
            WebSocketService.shared.sendDataToServer(message: text)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 요청 실패", error)
    }
}
