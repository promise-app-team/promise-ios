//
//  CommonFloatingViewController.swift
//  Promise
//
//  Created by Sun on 2023/06/27.
//

import UIKit
import FloatingPanel

class CommonFloatingContainerVC : UIViewController {
    
    static let minHeight: CGFloat = 270 // floating 뷰의 최소(tip,half 일 때의) 높이
    
    var fpc: FloatingPanelController!
    var contentVC: CommonFloatingContentVC!
    var currentVC: UIViewController!
    
    init(contentViewController: CommonFloatingContentVC, currentViewController: UIViewController){
        contentVC = contentViewController
        currentVC = currentViewController
        
        super.init(nibName: nil, bundle: nil)
        
        setupFPC()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func setupFPC(){
        fpc = FloatingPanelController()
        fpc.changePanelStyle() // panel 스타일 변경 (대신 bar UI가 사라지므로 따로 넣어주어야함)
        fpc.set(contentViewController: contentVC) // floating panel에 삽입할 것
        fpc.track(scrollView: contentVC.fullView)
        fpc.layout = CustomFloatingPanelLayout()
        fpc.behavior = CustomFloatingPanelBehavior()
    }
    
    func setDelegate(_ delegate: FloatingPanelControllerDelegate) {
        fpc.delegate = delegate
    }
    
    func addToParent() {
        fpc.addPanel(toParent: currentVC)
    }
    
    func readyToParent() {
        currentVC.view.addSubview(fpc.view)
        
        fpc.view.frame = currentVC.view.bounds
        fpc.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            fpc.view.topAnchor.constraint(equalTo: currentVC.view.topAnchor, constant: 0.0),
            fpc.view.leftAnchor.constraint(equalTo: currentVC.view.leftAnchor, constant: 0.0),
            fpc.view.rightAnchor.constraint(equalTo: currentVC.view.rightAnchor, constant: 0.0),
            fpc.view.bottomAnchor.constraint(equalTo: currentVC.view.bottomAnchor, constant: 0.0),
        ])
        
        currentVC.addChild(fpc)
    }
    
    func show() {
        fpc.show(animated: true) {
            self.fpc.didMove(toParent: self.currentVC)
        }
    }
    
    func dismiss() {
        fpc.dismiss(animated: true)
    }
}

extension FloatingPanelController {
    func changePanelStyle() {
        let appearance = SurfaceAppearance()
        let shadow = SurfaceAppearance.Shadow()
        
        shadow.color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        shadow.offset = CGSize(width: 0, height: 0)
        shadow.opacity = 1
        shadow.radius = 16
        
        appearance.shadows = [shadow]
        appearance.cornerRadius = 20
        appearance.backgroundColor = .clear
        appearance.borderColor = .clear
        appearance.borderWidth = 0
        
        surfaceView.appearance = appearance
        
        surfaceView.grabberHandle.isHidden = false
        surfaceView.grabberHandle.barColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        surfaceView.grabberHandleSize = .init(width: 80, height: 5)
        surfaceView.grabberHandlePadding = 16
    }
}


class CustomFloatingPanelLayout: FloatingPanelLayout {
    
    var position: FloatingPanelPosition = .bottom
    var initialState: FloatingPanelState = .tip
    
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(absoluteInset: 0, edge: .top, referenceGuide: .superview),
            .half: FloatingPanelLayoutAnchor(absoluteInset: CommonFloatingContainerVC.minHeight, edge: .bottom, referenceGuide: .superview),
            .tip: FloatingPanelLayoutAnchor(absoluteInset: CommonFloatingContainerVC.minHeight, edge: .bottom, referenceGuide: .superview),
        ]
    }
}

class CustomFloatingPanelBehavior: FloatingPanelBehavior {
    // 스프링 애니메이션 조절 값의 크기가 커질 수록 애니메이션이 느려진다.
    var springDecelerationRate: CGFloat {
        return UIScrollView.DecelerationRate.fast.rawValue - 0.02
    }
    var springResponseTime: CGFloat {
        return 0.2
    }
    var momentumProjectionRate: CGFloat {
        return UIScrollView.DecelerationRate.fast.rawValue
    }
    func shouldProjectMomentum(_ fpc: FloatingPanelController, to proposedTargetPosition: FloatingPanelState) -> Bool {
        return true
    }
}
