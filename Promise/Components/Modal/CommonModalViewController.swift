//
//  CommonModalViewController.swift
//  Promise
//
//  Created by Sun on 2023/06/11.
//

import UIKit

class CommonModalViewConroller : UIViewController {
    
    private lazy var modalDelegate = ModalPresentationDelegator()
    
    // MARK: Custom Header View
    private var headerView: UIView?
    
    // MARK: Default Header View
    private lazy var defaultHeaderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        view.addSubview(self.confirmBtn)
        
        confirmBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            confirmBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            confirmBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 4)
        ])
        
        return view
    }()
    
    private lazy var confirmBtn: UIButton! = {
        let btn = UIButton()
        btn.setTitle("확인", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitleColor(UIColor.black.withAlphaComponent(0.5), for: .highlighted)
        btn.addTarget(self, action: #selector(touchConfirmBtn), for: .touchUpInside)
        
        return btn
    }()
    
    // MARK: Content View
    private var contentView: UIView
    
    // MARK: 생성자
    init (contentView: UIView, headerView: UIView) {
        self.contentView = contentView
        self.headerView = headerView
        super.init(nibName: nil, bundle: nil)

        initCustomModal()
    }
    
    init (contentView: UIView, needHeader: Bool = true) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
        
        self.headerView = needHeader ? self.defaultHeaderView : nil
        
        initCustomModal()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Loading
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.dismiss(animated: true)
    }
    
    private func initCustomModal() {
        self.transitioningDelegate = modalDelegate
        self.modalPresentationStyle = .custom
    }
    
    // MARK: UI SetUp
    private func setup() {
        self.view.backgroundColor = .white
        
        var contentViewTopAnchor = view.topAnchor
        var contentViewHeight = view.bounds.height
        
        if let header = headerView {
            setupHeaderView(header, contentViewTopAnchor: &contentViewTopAnchor, contentViewHeight: &contentViewHeight)
        } else {
            setViewCornerRaius(view: contentView)
        }
        
        setupContentView(contentView, contentViewTopAnchor: contentViewTopAnchor, contentViewHeight: contentViewHeight)
        
        setViewCornerRaius(view: self.view)
    }
    
    private func setupHeaderView(_ headerView: UIView, contentViewTopAnchor: inout NSLayoutYAxisAnchor, contentViewHeight: inout CGFloat) {
        setViewCornerRaius(view: headerView)
        
        view.addSubview(headerView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            headerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            headerView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            headerView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.05)
        ])
        
        contentViewTopAnchor = headerView.bottomAnchor
        contentViewHeight = view.bounds.height * 0.95
    }
    
    private func setupContentView(_ contentView: UIView, contentViewTopAnchor: NSLayoutYAxisAnchor, contentViewHeight: CGFloat) {
        contentView.backgroundColor = .darkGray
        
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            contentView.topAnchor.constraint(equalTo: contentViewTopAnchor, constant: 0),
            contentView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            contentView.heightAnchor.constraint(equalToConstant: contentViewHeight)
        ])
    }
    
    private func setViewCornerRaius(view: UIView){
        view.layer.cornerRadius = 25
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @objc
    private func touchConfirmBtn(){
        self.dismiss(animated: true)
    }
    
}
