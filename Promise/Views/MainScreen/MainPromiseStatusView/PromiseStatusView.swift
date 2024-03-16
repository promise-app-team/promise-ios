//
//  PromiseStatusView.swift
//  Promise
//
//  Created by dylan on 2023/08/15.
//

import Foundation
import UIKit
import CoreLocation
import FloatingPanel

class PromiseStatusView: CommonFloatingContainerVC {
    // MARK: properties
    private let mainVC: MainVC
    private let mainVM: MainVM
    
    private let promiseStatusContent: CommonFloatingContentVC
    private let promiseStatusWithUserView: PromiseStatusWithUserView
    private let promiseStatusWithAllAttendeesView: PromiseStatusWithAllAttendeesView
    
    private var isEnabledLocationServiceOnDevice = LocationService.shared.isEnabledLocationServiceOnDevice {
        didSet {
            promiseStatusWithUserView.updateStateForLocationServiceOnDevice(isEnabled: isEnabledLocationServiceOnDevice)
        }
    }
    
    private var userLocation: CLLocation? = nil {
        didSet {
            guard let location = userLocation else { return }
            promiseStatusWithAllAttendeesView.updateUserLocation(location: location)
        }
    }
    
    private var authorizationStatus = LocationService.shared.authorizationStatus {
        didSet {
            if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
                promiseStatusWithAllAttendeesView.updateAuthorizationStatus(status: authorizationStatus)
            }
        }
    }
    
    // MARK: initialize
    
    init(vc: MainVC, vm: MainVM) {
        self.mainVC = vc
        self.mainVM = vm
        
        self.promiseStatusWithUserView = PromiseStatusWithUserView(vm: mainVM)
        self.promiseStatusWithAllAttendeesView = PromiseStatusWithAllAttendeesView(
            vm: mainVM
        )
        
        self.promiseStatusContent = CommonFloatingContentVC(
            halfView: promiseStatusWithUserView,
            fullView: promiseStatusWithAllAttendeesView
        )
        
        super.init(contentVC: self.promiseStatusContent, currentVC: vc)
        
        mainVM.promiseStatusContainer = self
        mainVM.promiseStatusContent = self.promiseStatusContent
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.readyToParent()
        LocationService.shared.delegate = self
        self.promiseStatusContent.delegate = self
    }
}

extension PromiseStatusView {
    public func updatePromiseStatus(with promise: Components.Schemas.PromiseDTO) {
        promiseStatusWithUserView.updatePromiseStatusWithUser(with: promise)
        promiseStatusWithAllAttendeesView.updatePromiseStatusWithAllAttendees(with: promise)
    }
}

extension PromiseStatusView: LocationServiceDelegate {
    func onDidChangeAuthorization(manager: CLLocationManager) {
        userLocation = manager.location
        authorizationStatus = manager.authorizationStatus
    }
    
    func onDidChangeLocationServiceOnDeivce(isEnabled: Bool) {
        isEnabledLocationServiceOnDevice = isEnabled
    }
    
    func onDidUpdatedUserLocation(location: CLLocation) {
        userLocation = location
    }
}

extension PromiseStatusView: CommonFloatingContentVCDelegate {
    func floatingPanelDidChangeState(_ fpc: FloatingPanelController) {
        switch fpc.state {
        case .full:
            
            LocationService.shared.start()
            
            break;
        case .half:
            break;
        case .tip:
            break;
        default:
            break
        }
    }
}


