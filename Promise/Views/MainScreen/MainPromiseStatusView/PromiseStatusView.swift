//
//  PromiseStatusView.swift
//  Promise
//
//  Created by dylan on 2023/08/15.
//

import Foundation
import UIKit
import FloatingPanel

class PromiseStatusView: CommonFloatingContainerVC {
    // MARK: properties
    private let parentVC: UIViewController
    private let mainVM: MainVM
    
    private let promiseStatusContent: CommonFloatingContentVC
    
    // MARK: initialize
    
    init(parentVC: UIViewController, vm: MainVM) {
        self.parentVC = parentVC
        self.mainVM = vm
        
        let contentVC = CommonFloatingContentVC()
        contentVC.halfView = PromiseStatusWithUserView(vm: mainVM)
        contentVC.fullView = PromiseStatusWithAllAttendeesView(vm: mainVM)
        self.promiseStatusContent = contentVC
        
        super.init(contentVC: promiseStatusContent, currentVC: parentVC)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.readyToParent()
        self.setDelegate(self)
    }
}

extension PromiseStatusView: FloatingPanelControllerDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        guard let contentVC = fpc.contentViewController as? CommonFloatingContentVC else {
            return
        }
        
        switch fpc.state {
        case .full:
            // 패널이 전체 화면일 때 컨텐츠 변경
            UIView.animate(withDuration: 0.3) {
                promiseStatusContent.updateHalfViewHeight(0)
            }
        case .half:
            // 패널이 반 화면일 때 컨텐츠 변경
            break;
        case .tip:
            // 패널이 최소 상태일 때 컨텐츠 변경
            break;
        default:
            break
        }
    }
}
