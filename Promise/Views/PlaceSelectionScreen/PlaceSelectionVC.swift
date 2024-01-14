//
//  PlaceSelectionVC.swift
//  Promise
//
//  Created by dylan on 2023/09/26.
//

import UIKit
import NMapsMap

@objc protocol PlaceSelectionDelegate: AnyObject {
    @objc optional func onWillShow()
    @objc optional func onWillHide()
    @objc optional func onDidShow()
    @objc optional func onDidHide()
}

class PlaceSelectionVC: UIViewController {
    
    enum SearchStatus {
        case idle, searching, searchFail, searchResult, map
    }
    
    // MARK: Public Property
    
    weak var delegate: PlaceSelectionDelegate?
    
//    var viewState: SearchStatus = .map {
    var viewState: SearchStatus! {
        didSet {
            switch self.viewState {
            case .idle:
                tipView.isHidden = false
                tableView.isHidden = true
//                mapView.isHidden = true
                DispatchQueue.main.async {
                    self.mapView.isHidden = true
                }
            case .searching:
                break
            case .searchFail:
                break
            case .searchResult:
                tipView.isHidden = true
                tableView.isHidden = false
//                mapView.isHidden = true
                DispatchQueue.main.async {
                    self.mapView.isHidden = true
                }
            case .map:
                print("->.map")
//                tipView.isHidden = true
//                tableView.isHidden = true
//                mapView.isHidden = false
                DispatchQueue.main.async {
                    print("dispatchqueue")
                    self.tipView.isHidden = true
                    self.tableView.isHidden = true
                    self.mapView.isHidden = false
                    self.mapView.forceRefresh()
                    self.mapView.reloadInputViews()
                }
            case .none:
                break
            }
        }
    }
    
    var place: KakaoPlaceMDL?
    
    // MARK: Private Property
    
    private lazy var headerView: HeaderView = {
        let headerView = HeaderView(navigationController: nil, title: "약속장소 설정")
        headerView.delegate = self
        return headerView
    }()
    
    lazy var textField: TextField = {
        let textField = TextField()
        textField.initialize(placeHolder: "도로명, 지번, 건물명 검색", showSearchIcon: true)
        textField.delegate = self
        return textField
    }()
    
    private let tipView = PlaceSelectionTipView()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PlaceSelectionTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let mapView: NMFMapView = {
        let naverMapView = NMFNaverMapView()
        naverMapView.showCompass = true
        naverMapView.showZoomControls = true
        
        let mapView =  naverMapView.mapView
        mapView.latitude = 37.4222864409138
        mapView.longitude = 126.687581340746
        
//        mapView.isHidden = true
//        return mapView
        return naverMapView.mapView
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAccountVC()
        render()
        viewState = .idle
//        viewState = .map
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onWillShow?()
        let _ = textField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.onDidShow?()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.onWillHide?()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.onDidHide?()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if textField.isFirstResponder {
            let _ = textField.resignFirstResponder()
        }
    }
    
    // MARK: Private Function
    
    private func configureAccountVC() {
        view.backgroundColor = .white
    }
    
    private func render() {
        [headerView, textField, tipView, tableView, mapView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),
            
            textField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            tipView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            tipView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tipView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tipView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mapView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: HeaderViewDelegate

extension PlaceSelectionVC: HeaderViewDelegate {
    
    func onTapCustomBackAction() {
        if viewState == .map {
            viewState = .searchResult
        } else {
            dismiss(animated: true)
        }
    }
}

extension UIViewController {
    

}
