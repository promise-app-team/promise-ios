//
//  PopupVC.swift
//  Promise
//
//  Created by Sun on 2023/07/28.
//

import UIKit

class PopupVC : UIViewController {
    
    var isPresented = false
    
    private var titleText: String?
    private var messageText: String?
    private var contentView: UIView?
    
    private var rightBtnTitle: String?
    private var leftBtnTitle: String?
    
    private var rightBtnAction: (() -> Void)?
    private var leftBtnAction: (() -> Void)?
    
    var disableBackgroundTap = false
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        
        view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 12.0
        view.alignment = .center
        
        return view
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 14.0
        view.distribution = .fillEqually
        
        return view
    }()
    
    private lazy var titleLabel: UILabel? = {
        let label = UILabel()
        label.text = titleText
        label.textAlignment = .center
        label.font = UIFont.pretendard(style: .H2_B)
        label.numberOfLines = 0
        label.textColor = .black
        
        return label
    }()
    
    private lazy var messageLabel: UILabel? = {
        guard let message = messageText else { return nil}
        
        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.font = UIFont.pretendard(style: .B1_R)
        label.numberOfLines = 4
        label.textColor = .gray
        
        let attrString = NSMutableAttributedString(string: label.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        
        return label
    }()
    
    private lazy var rightBtn: Button = {
        let btnTitle = rightBtnTitle != nil ? rightBtnTitle! : "확인"
        
        let btn = Button()
        btn.initialize(title: btnTitle, style: .primary)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStackView.addArrangedSubview(btn)
        
        return btn
    }()
    
    private lazy var leftBtn: Button? = {
        guard let btnTitle = leftBtnTitle else { return nil }
        
        let btn = Button()
        btn.initialize(title: btnTitle, style: .secondary)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStackView.addArrangedSubview(btn)
        
        return btn
    }()
    
    func initialize(titleText: String,
                    messageText: String,
                    rightBtnTitle: String, rightBtnHandelr: @escaping (() -> Void),
                    leftBtnTitle: String? = nil, leftBtnHandler: (() -> Void)? = nil) {
        self.titleText = titleText
        self.messageText = messageText
        
        self.leftBtnTitle = leftBtnTitle
        self.leftBtnAction = leftBtnHandler
        self.leftBtn?.addTarget(self, action: #selector(leftBtnTapped), for: .touchUpInside)
        
        self.rightBtnTitle = rightBtnTitle
        self.rightBtnAction = rightBtnHandelr
        self.rightBtn.addTarget(self, action: #selector(rightBtnTapped), for: .touchUpInside)
        
        setupViews()
        addSubviews()
        makeConstraints()
    }
    
    func initialize(
        contentView: UIView,
        leftBtnTitle: String? = nil,
        leftBtnHandler: (() -> Void)? = nil,
        rightBtnTitle: String,
        rightBtnHandelr: @escaping (() -> Void))
    {
        self.contentView = contentView
        self.rightBtnTitle = rightBtnTitle
        self.rightBtnAction = rightBtnHandelr
        self.leftBtnTitle = leftBtnTitle
        self.leftBtnAction = leftBtnHandler
        
        if leftBtnHandler != nil {
            self.leftBtn?.addTarget(self, action: #selector(leftBtnTapped), for: .touchUpInside)
        }
        
        self.rightBtn.addTarget(self, action: #selector(rightBtnTapped), for: .touchUpInside)
        
        setupViews()
        addSubviews()
        makeConstraints()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .overFullScreen
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.containerView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        self.containerStackView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.view.alpha = 1
            self.containerView.transform = .identity
            
            self.containerStackView.transform = .identity
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.isPresented = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.isPresented = false
    }
    
    @objc private func backgroundTapped() {
        if disableBackgroundTap { return }
        close()
    }
    
    public func close(completion: @escaping () -> Void = {}){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.alpha = 0
            self.containerView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            self.containerStackView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }){(complete) in
            self.dismiss(animated: false)
            self.removeFromParent()
            completion()
        }
        
    }
    
    private func setupViews() {
        view.alpha = 0
        
        view.addSubview(containerView)
        containerView.addSubview(containerStackView)
        view.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    private func addSubviews() {
        view.addSubview(containerStackView)
        
        if let contentView = contentView {
            
            let backgroundView = UIView()
            backgroundView.backgroundColor = contentView.backgroundColor
            backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerStackView.addSubview(backgroundView)
            
            containerStackView.addArrangedSubview(contentView)
            
            if let lastView = containerStackView.subviews.last {
                containerStackView.setCustomSpacing(16.0, after: lastView)
            }
            
            containerStackView.addArrangedSubview(buttonStackView)
            
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                backgroundView.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor),
                backgroundView.topAnchor.constraint(equalTo: containerStackView.topAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
            
        } else {
            if let titleLabel = titleLabel {
                containerStackView.addArrangedSubview(titleLabel)
            }
            
            if let messageLabel = messageLabel {
                containerStackView.addArrangedSubview(messageLabel)
            }
            
            if let lastView = containerStackView.subviews.last {
                containerStackView.setCustomSpacing(16.0, after: lastView)
            }
            
            containerStackView.addArrangedSubview(buttonStackView)
        }
        
        
    }
    
    private func makeConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 24),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -24),
            
            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: Button.Height),
            buttonStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor)
        ])
    }
    
    
    @objc
    private func rightBtnTapped(){
        rightBtnAction?()
    }
    
    @objc
    private func leftBtnTapped(){
        leftBtnAction?()
    }
    
}
