//
//  CommonFloatingViewController.swift
//  Promise
//
//  Created by Sun on 2023/06/27.
//

import UIKit
import FloatingPanel

class CommonFloatingContainerVC : UIViewController {
    
    static let minHeight: CGFloat = 200 // floating 뷰의 최소(tip,half 일 때의) 높이
    
    private var fpc: FloatingPanelController!
    var contentVC: CommonFloatingContentVC!
    
    init(contentViewController: CommonFloatingContentVC){
        contentVC = contentViewController
        
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
    
    func setDelegate(_ vc: FloatingPanelControllerDelegate) {
        fpc.delegate = vc
    }
    
    func addToParent(_ vc: UIViewController) {
        fpc.addPanel(toParent: vc)
    }
    
    func show() {
        fpc.show()
    }
    
    func dismiss() {
        fpc.dismiss(animated: true)
    }
}

extension FloatingPanelController {
    func changePanelStyle() {
        let appearance = SurfaceAppearance()
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = UIColor.black
        shadow.offset = CGSize(width: 0, height: -4.0)
        shadow.opacity = 0.15
        shadow.radius = 2
        appearance.shadows = [shadow]
        appearance.cornerRadius = 15.0
        appearance.backgroundColor = .clear
        appearance.borderColor = .clear
        appearance.borderWidth = 0
        
        surfaceView.grabberHandle.isHidden = false
        surfaceView.appearance = appearance
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
