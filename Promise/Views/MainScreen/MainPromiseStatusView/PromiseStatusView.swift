//
//  PromiseStatusView.swift
//  Promise
//
//  Created by dylan on 2023/08/15.
//

import Foundation
import UIKit

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
        
        self.promiseStatusWithUserView = PromiseStatusWithUserView(vm: mainVM)
        self.promiseStatusWithAllAttendeesView = PromiseStatusWithAllAttendeesView(vm: mainVM)
        
        self.promiseStatusContent = CommonFloatingContentVC(
            halfView: promiseStatusWithUserView,
            fullView: promiseStatusWithAllAttendeesView
        )
        
        super.init(contentVC: self.promiseStatusContent, currentVC: vc)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.readyToParent()
    }
}

extension PromiseStatusView {
    public func updatePromiseStatus(with promise: Components.Schemas.OutputPromiseListItem) {
        promiseStatusWithUserView.updatePromiseStatusWithUser(with: promise)
        promiseStatusWithAllAttendeesView.updatePromiseStatusWithAllAttendees(with: promise)
    }
}


