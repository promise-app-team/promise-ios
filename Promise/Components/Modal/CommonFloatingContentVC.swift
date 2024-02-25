//
//  CommonFloatingContentViewController.swift
//  Promise
//
//  Created by Sun on 2023/07/02.
//

import Foundation
import UIKit
import FloatingPanel

@objc protocol CommonFloatingContentVCDelegate: AnyObject {
    @objc optional func floatingPanelDidChangeState(_ fpc: FloatingPanelController)
}

class CommonFloatingContentVC: UIViewController {
    weak var delegate: CommonFloatingContentVCDelegate?
    
    let halfViewHeight: CGFloat = CommonFloatingContainerVC.minHeight
    var halfViewHeightConstraint: NSLayoutConstraint!
    
    let halfView: UIView
    let fullView: UIView

    init(halfView: UIView, fullView: UIView) {
        self.halfView = halfView
        self.fullView = fullView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setViewLayout()
    }
    
    private func setViewLayout(){
        fullView.translatesAutoresizingMaskIntoConstraints = false
        halfView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(halfView)
        view.addSubview(fullView)
        
        halfViewHeightConstraint = halfView.heightAnchor.constraint(equalToConstant: halfViewHeight)
        halfViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            halfView.topAnchor.constraint(equalTo: view.topAnchor),
            halfView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            fullView.topAnchor.constraint(equalTo: halfView.bottomAnchor),
            fullView.widthAnchor.constraint(equalTo: view.widthAnchor),
            fullView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
        ])
    }
    
}

extension CommonFloatingContentVC: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        let y = fpc.surfaceView.frame.minY
        let minY = fpc.surfaceLocation(for: .full).y // 패널이 .full일 때의 최소 Y값
        let maxY = fpc.surfaceLocation(for: .half).y // 패널이 .half일 때의 최대 Y값
        let loc = fpc.surfaceLocation
        
        // 패널이 움직이는 바운더리 설정 (바운스를 방지도 됨)
        if fpc.isAttracting == false {
            
            
            // 패널이 `full` 상태를 넘어서 위로 움직이려고 할 때, 이를 방지
            if loc.y < minY {
                fpc.surfaceLocation = CGPoint(x: loc.x, y: minY)
            }
            
            // 패널이 `tip` 상태 아래로 움직이려고 할 때, 이를 방지
            else if loc.y > maxY {
                fpc.surfaceLocation = CGPoint(x: loc.x, y: maxY)
            }
        }
        
        var progress = (y - minY) / (maxY - minY) // .full에서 .half로 이동하는 동안의 진행 비율
        
        
        
        // 임계값
        // let threshold: CGFloat = 0.01
        
        // // progress 값이 1에 매우 가깝다면 1로 처리
        // if abs(progress - 1) < threshold {
        //     progress = 1
        //  }
        //
        //  // progress 값이 0에 매우 가깝다면 0으로 처리
        //  if abs(progress) < threshold {
        //      progress = 0
        //  }
        
        
        // guard progress >= 0 else { return }
        // self.halfViewHeightConstraint.constant = self.halfViewHeight * progress
    }
    
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        guard let _ = fpc.contentViewController as? CommonFloatingContentVC else {
            return
        }
        
        delegate?.floatingPanelDidChangeState?(fpc)

        switch fpc.state {
        case .full:
            // 패널이 전체 화면일 때 컨텐츠 변경
            UIView.animate(withDuration: 0.2) {
                self.halfViewHeightConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        case .half:
            // 패널이 반 화면일 때 컨텐츠 변경
            UIView.animate(withDuration: 0.15) {
                self.halfViewHeightConstraint.constant = CommonFloatingContainerVC.minHeight
                self.view.layoutIfNeeded()
            }
        case .tip:
            // 패널이 최소 상태일 때 컨텐츠 변경
            UIView.animate(withDuration: 0.15) {
                self.halfViewHeightConstraint.constant = CommonFloatingContainerVC.minHeight
                self.view.layoutIfNeeded()
            }
        default:
            break
        }
    }
}
