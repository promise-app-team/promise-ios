//
//  GuideAttendeeVC.swift
//  Promise
//
//  Created by kwh on 1/17/24.
//

import Foundation
import UIKit

class GuideAttendeeVC: UIViewController {
    let promiseId: String
    let numberOfPages = 3
    
    private lazy var scrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(numberOfPages), height: view.frame.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        // 각 페이지 내용을 설정하는 로직을 추가합니다.
        for i in 0..<numberOfPages {
            let pageFrame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            let pageView = UIView(frame: pageFrame)
            // pageView에 컨텐츠를 추가합니다.
            scrollView.addSubview(pageView)
        }
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var customPageControl: CustomPageControl?
    
    required init(promiseId: String) {
        self.promiseId = promiseId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainVC()
        render()
    }
    
//    private func setupCustomPageControl() {
//        customPageControl = CustomPageControl(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50))
//        customPageControl.numberOfPages = numberOfPages
//        view.addSubview(customPageControl)
//    }
    
    private func configureMainVC() {
        view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ToastView(message: "참여할 약속 id: \(promiseId)").showToast()
    }
    
    private func render() {
        [
            scrollView,
        ].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
}

extension GuideAttendeeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
//        customPageControl.currentPage = Int(pageIndex)
    }
}

class CustomPageControl: UIView {
    var dotViews = [UIView]()
    var numberOfPages: Int = 0 {
        didSet {
            setupDotViews()
        }
    }
    var currentPage: Int = 0 {
        didSet {
            updateDotViews()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDotViews() {
        dotViews.forEach { $0.removeFromSuperview() }
        dotViews = [UIView]()
        
        let dotSize: CGSize = CGSize(width: 8, height: 8)
        let selectedDotSize: CGSize = CGSize(width: 12, height: 8)
        let spacing: CGFloat = 10
        let totalWidth: CGFloat = CGFloat(numberOfPages - 1) * dotSize.width + CGFloat(numberOfPages - 1) * spacing + selectedDotSize.width
        var startX: CGFloat = (frame.width - totalWidth) / 2
        
        for i in 0..<numberOfPages {
            let dotView = UIView(frame: CGRect(x: startX, y: (frame.height - dotSize.height) / 2, width: dotSize.width, height: dotSize.height))
            dotView.backgroundColor = (i == currentPage) ? .blue : .lightGray
            dotView.layer.cornerRadius = dotSize.height / 2
            addSubview(dotView)
            dotViews.append(dotView)
            startX += dotSize.width + spacing
        }
    }
    
    private func updateDotViews() {
        let selectedDotSize: CGSize = CGSize(width: 12, height: 8)
        let dotSize: CGSize = CGSize(width: 8, height: 8)
        
        for (index, dotView) in dotViews.enumerated() {
            UIView.animate(withDuration: 0.3) {
                if index == self.currentPage {
                    dotView.backgroundColor = .blue
                    dotView.frame.size = selectedDotSize
                } else {
                    dotView.backgroundColor = .lightGray
                    dotView.frame.size = dotSize
                }
                dotView.layer.cornerRadius = dotView.frame.height / 2
                dotView.center.y = self.frame.height / 2
            }
        }
        
        // 마지막 페이지에 도달하면 모든 도트를 숨깁니다.
        if currentPage == numberOfPages - 1 {
            self.isHidden = true
        } else {
            self.isHidden = false
        }
    }
}
