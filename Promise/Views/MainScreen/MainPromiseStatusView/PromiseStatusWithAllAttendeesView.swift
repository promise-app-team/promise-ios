//
//  PromiseStatusWithAllAttendees.swift
//  Promise
//
//  Created by kwh on 2/3/24.
//

import Foundation
import UIKit

class PromiseStatusWithAllAttendeesView: UIScrollView {
    // MARK: properties
    
    let mainVM: MainVM
    
    // MARK: initialize
    
    init(vm: MainVM) {
        mainVM = vm
        super.init(frame: .null)
        configure()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .blue
    }
    
    private func render() {
        [].forEach { addSubview($0) }
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
        
        ])
    }
}

extension PromiseStatusWithAllAttendeesView {
    public func updatePromiseStatusWithAllAttendees(with promise: Components.Schemas.OutputPromiseListItem) {
        // TODO: 
    }
}
