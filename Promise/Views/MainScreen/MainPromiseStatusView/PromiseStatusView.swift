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
    private let mainVC: MainVC
    private let mainVM: MainVM
    
    private let promiseStatusContent: CommonFloatingContentVC
    private let promiseStatusWithUserView: PromiseStatusWithUserView
    private let promiseStatusWithAllAttendeesView: PromiseStatusWithAllAttendeesView
    
    // MARK: initialize
    
    init(vc: MainVC, vm: MainVM) {
        self.mainVC = vc
        self.mainVM = vm
        
        self.promiseStatusContent = CommonFloatingContentVC()
        
        self.promiseStatusWithUserView = PromiseStatusWithUserView(vm: mainVM)
        self.promiseStatusWithAllAttendeesView = PromiseStatusWithAllAttendeesView(vm: mainVM)
        
        self.promiseStatusContent.halfView = self.promiseStatusWithUserView
        self.promiseStatusContent.fullView = self.promiseStatusWithAllAttendeesView
        
        super.init(contentVC: self.promiseStatusContent, currentVC: vc)
        
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
        guard let _ = fpc.contentViewController as? CommonFloatingContentVC else {
            return
        }
        
        switch fpc.state {
        case .full:
            // 패널이 전체 화면일 때 컨텐츠 변경
            self.promiseStatusContent.updateHalfViewHeight(height: 0, opacity: 0)
            
        case .half:
            // 패널이 반 화면일 때 컨텐츠 변경
            self.promiseStatusContent.updateHalfViewHeight(height: CommonFloatingContainerVC.minHeight, opacity: 1)
        case .tip:
            // 패널이 최소 상태일 때 컨텐츠 변경
            break;
        default:
            break
        }
    }
}

extension PromiseStatusView {
    public func updatePromiseStatus(with promise: Components.Schemas.OutputPromiseListItem) {
        promiseStatusWithUserView.updatePromiseStatusWithUser(with: promise)
        promiseStatusWithAllAttendeesView.updatePromiseStatusWithAllAttendees(with: promise)
    }
}
