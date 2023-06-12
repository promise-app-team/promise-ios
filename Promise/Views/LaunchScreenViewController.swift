//
//  LaunchScreenViewController.swift
//  Promise
//
//  Created by zzee22su on 2023/06/12.
//

import UIKit
import Lottie

class LaunchScreenViewController: UIViewController {
    
    private lazy var launchScreenView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let logoImage = UIImage(named: "LaunchScreenImage")
        let imageView = UIImageView(image: logoImage)
        return imageView
    }()
    
    private lazy var lottieAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "_primary-gps-lottie")
            animationView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            animationView.layer.shadowOpacity = 1
            animationView.layer.shadowRadius = 4
            animationView.layer.shadowOffset = CGSize(width: 4, height: 4)
        return animationView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        lottieAnimationView.play()
    }
    
    func makeUI() {
        launchScreenView.addSubview(logoImageView)
        launchScreenView.addSubview(lottieAnimationView)
        view.addSubview(launchScreenView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 프로미스앱 로고 이미지 오토레이아웃 설정
            logoImageView.widthAnchor.constraint(equalToConstant: 236),
            logoImageView.heightAnchor.constraint(equalToConstant: 71),
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 77),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -77),
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 381),
            
            // 프로미스앱 로고 로티 이미지 오토레이아웃 설정
            lottieAnimationView.widthAnchor.constraint(equalToConstant: 80),
            lottieAnimationView.heightAnchor.constraint(equalToConstant: 80),
            lottieAnimationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 189),
            lottieAnimationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -121),
            lottieAnimationView.topAnchor.constraint(equalTo: view.topAnchor, constant: 301)
        ])
    }
}
