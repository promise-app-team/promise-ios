//
//  LaunchScreenViewController.swift
//  Promise
//
//  Created by zzee22su on 2023/06/12.
//

import UIKit
import Lottie

class LaunchVC: UIViewController {
    
    private lazy var launchScreenView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        return view
    }()

    private lazy var lottieAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "logo")
        return animationView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        lottieAnimationView.play()
    }
    
    func makeUI() {
        launchScreenView.addSubview(lottieAnimationView)
        view.addSubview(launchScreenView)
        
        lottieAnimationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lottieAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lottieAnimationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            lottieAnimationView.widthAnchor.constraint(equalToConstant: 106),
            lottieAnimationView.heightAnchor.constraint(equalToConstant: 106)
        ])
    }
}
