//
//  DynamicDestinationSelectionVC.swift
//  Promise
//
//  Created by kwh on 4/28/24.
//

import Foundation
import UIKit
import NMapsMap

protocol DynamicDestinationSelectionDelegate: AnyObject {
    
}

class DynamicDestinationSelectionVC: UIViewController {
    // MARK: properties
    private let createPromiseVM: CreatePromiseVM
    private let state: DynamicDestinationState
    private var mapDefaultZoomLevel: Double = 16
    
    weak var delegate: DynamicDestinationSelectionDelegate?
    
    // MARK: subviews
    private lazy var header = {
        let headerTitle = L10n.DynamicDestinationSelection.headerTitle
        
        let headerView = HeaderView(
            navigationController: createPromiseVM.currentVC?.navigationController,
            title: headerTitle,
            isHiddenLeftView: true,
            isHiddenRightView: false
        )
        
        headerView.delegate = self
        return headerView
    }()
    
    private lazy var map = {
        let mapView = NMFMapView()
        
        mapView.isIndoorMapEnabled = true // 실내 지도 활성화(역사 내부 지도 등)
        mapView.touchDelegate = self
        mapView.zoomLevel = mapDefaultZoomLevel
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var confirmButton = {
        let button = Button()
        button.initialize(title: L10n.DynamicDestinationSelection.confirm, style: .primary)
        button.addTarget(self, action: #selector(onConfirm), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: Button.Height).isActive = true
        return button
    }()
    
    // MARK: handler
    @objc private func onConfirm() {
        
    }
    
    // MARK: initialize
    
    init(vm: CreatePromiseVM, state: DynamicDestinationState) {
        self.createPromiseVM = vm
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        render()
    }
    
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func render() {
        [
            header,
            map,
            confirmButton
        ].forEach { view.addSubview($0) }
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            header.heightAnchor.constraint(equalToConstant: adjustedValue(56, .height)),
            header.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            map.topAnchor.constraint(equalTo: header.bottomAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -adjustedValue(24, .height)),
            
            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            confirmButton.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor, constant: -adjustedValue(16, .height))
        ])
    }
}

extension DynamicDestinationSelectionVC: HeaderViewDelegate {
    func onTapRightView() {
        dismiss(animated: true)
    }
}

extension DynamicDestinationSelectionVC: NMFMapViewTouchDelegate {
    
}
