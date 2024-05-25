//
//  PlaceSelectionVC.swift
//  Promise
//
//  Created by dylan on 2023/09/26.
//

import UIKit
import NMapsMap

@objc protocol PlaceSelectionDelegate: AnyObject{
    @objc optional func onWillShow()
    @objc optional func onWillHide()
    @objc optional func onDidShow()
    @objc optional func onDidHide()
}
protocol PlaceSelectionDataDelegate: AnyObject {
    func handlePlaceResult(place: PlaceLocationMDL)
}

struct PlaceSelection {
    var city: String = ""
    var district: String = ""
    var buildingName: String = ""
    var lotNumberAddress: String = ""
    var roadNameAddress: String = ""
    var userInputAddress: String = ""
    var lat: Double = 37.5664056 // 시청
    var lon: Double = 126.9778222
}

class PlaceSelectionVC: UIViewController {
    enum SearchStatus {
        case idle
        case onSearch
        case searchFail
        case searchResult
        case searchMap
    }
    
    // MARK: Public Property
    let debouncer = Debouncer()
    weak var delegate: PlaceSelectionDelegate?
    weak var dataDelegate: PlaceSelectionDataDelegate?
    
    var isSearchBarFocused: Bool
    var viewState: SearchStatus = .idle {
        didSet {
            DispatchQueue.main.async {
                self.headerView.isUserInteractionEnabled = (self.viewState == .onSearch) ? false : true
            }
            switch self.viewState {
            case .idle:
                DispatchQueue.main.async {
                    self.searchFailView.isHidden = true
                    self.naverMapView.mapView.allowsScrolling = true
                    self.tipView.isHidden = true
                    self.tableView.isHidden = true
                    self.naverMapView.isHidden = false
                    self.confirmView.isHidden = false
                    self.probee.isHidden = false
                }
                let location = LocationService.shared.currentLocation
                moveMap(to: location)
                clearData()
            case .onSearch:
                DispatchQueue.main.async {
                    self.searchFailView.isHidden = true
                    self.tipView.isHidden = false
                    self.tableView.isHidden = true
                    self.naverMapView.isHidden = true
                    self.confirmView.isHidden = true
                    self.probee.isHidden = true
                }
                let _ = self.searchTextField.becomeFirstResponder()
                marker = nil
            case .searchFail:
                DispatchQueue.main.async {
                    self.searchFailView.isHidden = false
                    self.tipView.isHidden = false
                    self.tableView.isHidden = true
                    self.naverMapView.isHidden = true
                    self.confirmView.isHidden = true
                    self.probee.isHidden = true
                }
            case .searchResult:
                DispatchQueue.main.async {
                    self.searchFailView.isHidden = true
                    self.tipView.isHidden = true
                    self.tableView.isHidden = false
                    self.naverMapView.isHidden = true
                    self.confirmView.isHidden = true
                    self.probee.isHidden = true
                }
            case .searchMap:
                DispatchQueue.main.async {
                    self.searchFailView.isHidden = true
                    self.naverMapView.mapView.allowsScrolling = false
                    self.tipView.isHidden = true
                    self.tableView.isHidden = true
                    self.naverMapView.isHidden = false
                    self.confirmView.isHidden = false
                    self.probee.isHidden = true
                }
            }
        }
    }
    
    var marker: NMFMarker? = nil {
        didSet {
            oldValue?.mapView = nil
            marker?.mapView = naverMapView.mapView
        }
    }
    
    var place: KakaoPlaceMDL?
    
    // MARK: Private Property
    
    var currentPlace = PlaceSelection() {
        didSet {
            DispatchQueue.main.async {
                self.confirmView.updateLabel(to: self.currentPlace)
            }
        }
    }
    
    // MARK: - Initialize
    
    init(isSearchBarFocused: Bool) {
        self.isSearchBarFocused = isSearchBarFocused
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View
    
    private lazy var headerView: HeaderView = {
        let headerView = HeaderView(navigationController: nil, title: "약속장소 설정")
        headerView.delegate = self
        return headerView
    }()
    
    private let probee: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ProbeeOnMap"))
        return imageView
    }()
    
    lazy var searchTextField: TextField = {
        let textField = TextField()
        textField.initialize(placeHolder: "도로명, 지번, 건물명 검색", showSearchIcon: true)
        textField.delegate = self
        return textField
    }()
    
    private let tipView = PlaceSelectionTipView()
    private let searchFailView = PlaceSelectionSearchFailView()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PlaceSelectionTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let naverMapView = NMFNaverMapView()
    
    lazy var confirmView: PlaceSelectionConfirmView = {
        let view = PlaceSelectionConfirmView()
        view.handleTappedConfirmButton = {
            let result = PlaceLocationMDL(
                city: self.currentPlace.city,
                disctrict: self.currentPlace.district,
                address1: self.currentPlace.roadNameAddress == "" ? self.currentPlace.lotNumberAddress : self.currentPlace.roadNameAddress,
                address2: self.confirmView.addressTextField.text ?? "",
                latitude: String(self.currentPlace.lat),
                longitude: String(self.currentPlace.lon))
            self.dataDelegate?.handlePlaceResult(place: result)
            print("result: ", result)
            self.dismiss(animated: true)
        }
        return view
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationService.shared.start()
        configureAccountVC()
        render()
        confirmView.configureAddressTextfieldDelegate(self)
        naverMapView.mapView.addCameraDelegate(delegate: self)
        naverMapView.showCompass = true
        naverMapView.showZoomControls = true
        naverMapView.mapView.latitude = 37.4222864409138
        naverMapView.mapView.longitude = 126.687581340746
        naverMapView.mapView.positionMode = .normal
        naverMapView.showLocationButton = true
        addKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onWillShow?()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewState = isSearchBarFocused ? .onSearch : .idle
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
    
    
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow),
          name: UIResponder.keyboardWillShowNotification,
          object: nil
        )
        
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide),
          name: UIResponder.keyboardWillHideNotification,
          object: nil
        )
      }
    
    func isKeyboardVisible() -> Bool {
        return view.window?.frame.origin.y ?? 0 < 0
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        guard
            confirmView.addressTextField.isFirstResponder
        else {
            return
        }
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
          let keybaordRectangle = keyboardFrame.cgRectValue
          let keyboardHeight = keybaordRectangle.height
//          confirmView.frame.origin.y -= keyboardHeight
            // view가 아닌 confirmView 만 올라가게 해야함
          view.frame.origin.y -= keyboardHeight
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        guard
            confirmView.addressTextField.isFirstResponder
        else {
            return
        }
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keybaordRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keybaordRectangle.height
//            confirmView.frame.origin.y += keyboardHeight
            view.frame.origin.y += keyboardHeight
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if searchTextField.isFirstResponder {
            let _ = searchTextField.resignFirstResponder()
        }
        else if confirmView.addressTextField.isFirstResponder {
            let _ = confirmView.addressTextField.resignFirstResponder()
        }
    }
    
    // MARK: Private Function
    
    private func configureAccountVC() {
        view.backgroundColor = .white
    }
    
    private func render() {
        [headerView, searchTextField, tipView, searchFailView, tableView, naverMapView, probee, confirmView].forEach {
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
            
            searchTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            tipView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            tipView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tipView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tipView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            searchFailView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            searchFailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchFailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchFailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            naverMapView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            naverMapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            naverMapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            naverMapView.bottomAnchor.constraint(equalTo: confirmView.topAnchor),
            
            probee.widthAnchor.constraint(equalToConstant: 256),
            probee.heightAnchor.constraint(equalToConstant: 89),
            probee.centerXAnchor.constraint(equalTo: naverMapView.centerXAnchor),
            probee.centerYAnchor.constraint(equalTo: naverMapView.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            confirmView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            confirmView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            confirmView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            confirmView.heightAnchor.constraint(equalToConstant: 250),
        ])
    }
}

extension PlaceSelectionVC {
    private func moveMap(to location: CLLocationCoordinate2D) {
        let target = NMGLatLng(lat: location.latitude, lng: location.longitude)
        let position = NMFCameraPosition(target, zoom: 17)
        let update = NMFCameraUpdate(position: position)
        naverMapView.mapView.moveCamera(update)
    }

    private func clearData() {
        searchTextField.text = ""
        confirmView.clearLabel()
        
        let location = LocationService.shared.currentLocation
        moveMap(to: location)
    }
}

