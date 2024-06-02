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
    var lat: Double
    var lng: Double
}

enum PlaceSelectionMode {
    case destination
    case departure
}

class PlaceSelectionVC: UIViewController {
    private var isPushedVC: Bool = false
    private var mode: PlaceSelectionMode = .destination
    
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
    
    private var confirmViewBottomAnchorConstraint: NSLayoutConstraint!
    
    private var confirmViewMaxHeight = adjustedValue(270, .height)
    private var confirmViewMinHeight = adjustedValue(254, .height)
    private var confirmViewHeightAnchorConstraint: NSLayoutConstraint!
    
    var activeSearchTextField: UITextField?
    
    var viewState: SearchStatus = .idle {
        didSet {
            
            switch self.viewState {
            case .idle:
                DispatchQueue.main.async {
                    self.headerView.isHiddenLeftView = !self.isPushedVC
                    self.headerView.isHiddenRightView = self.isPushedVC
                    
                    self.searchFailView.isHidden = true
                    self.map.allowsScrolling = true
                    self.tipView.isHidden = true
                    self.tableView.isHidden = true
                    self.map.isHidden = false
                    self.confirmView.isHidden = false
                    self.probee.isHidden = false
                }
                
                let location = LocationService.shared.currentLocation
                moveMap(to: location)
                clearData()
                
            case .onSearch:
                DispatchQueue.main.async {
                    self.headerView.isHiddenLeftView = !self.isPushedVC
                    self.headerView.isHiddenRightView = self.isPushedVC
                    
                    self.searchFailView.isHidden = true
                    self.tipView.isHidden = false
                    self.tableView.isHidden = true
                    self.map.isHidden = true
                    self.confirmView.isHidden = true
                    self.probee.isHidden = true
                }
                let _ = self.searchTextField.becomeFirstResponder()
                marker = nil
                
            case .searchFail:
                DispatchQueue.main.async {
                    self.headerView.isHiddenLeftView = false
                    self.headerView.isHiddenRightView = self.isPushedVC
                    
                    self.searchFailView.isHidden = false
                    self.tipView.isHidden = false
                    self.tableView.isHidden = true
                    self.map.isHidden = true
                    self.confirmView.isHidden = true
                    self.probee.isHidden = true
                }
                
            case .searchResult:
                DispatchQueue.main.async {
                    self.headerView.isHiddenLeftView = false
                    self.headerView.isHiddenRightView = self.isPushedVC
                    
                    self.searchFailView.isHidden = true
                    self.tipView.isHidden = true
                    self.tableView.isHidden = false
                    self.map.isHidden = true
                    self.confirmView.isHidden = true
                    self.probee.isHidden = true
                }
                
            case .searchMap:
                DispatchQueue.main.async {
                    self.headerView.isHiddenLeftView = false
                    self.headerView.isHiddenRightView = self.isPushedVC
                    
                    self.searchFailView.isHidden = true
                    self.map.allowsScrolling = false
                    self.tipView.isHidden = true
                    self.tableView.isHidden = true
                    self.map.isHidden = false
                    self.confirmView.isHidden = false
                    self.probee.isHidden = true
                }
                
            }
        }
    }
    
    var marker: NMFMarker? = nil {
        didSet {
            oldValue?.mapView = nil
            marker?.mapView = map
        }
    }
    
    var place: KakaoPlaceMDL?
    
    // MARK: Private Property
    
    var currentPlace: PlaceSelection? = nil {
        didSet {
            guard let currentPlace else { return }
            
            DispatchQueue.main.async {
                self.confirmView.updateLabel(to: currentPlace)
            }
            
        }
    }
    
    // MARK: - View
    
    private lazy var headerView = {
        var headerTitle = ""
        
        switch mode {
        case .departure:
            headerTitle = L10n.PlaceSelection.HeaderTitle.departure
        case .destination:
            headerTitle = L10n.PlaceSelection.HeaderTitle.destination
        }
        
        let headerView = HeaderView(
            navigationController: self.navigationController,
            title: headerTitle,
            isHiddenLeftView: false,
            isHiddenRightView: false
        )
        
        headerView.delegate = self
        return headerView
    }()
    
    private lazy var keyboardDismissBackdrop = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapKeyboardDismissBackdrop))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        view.isHidden = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let probee: UIImageView = {
        let imageView = UIImageView(image: Asset.probeeOnMap.image)
        imageView.widthAnchor.constraint(equalToConstant: adjustedValue(256, .width)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(89, .height)).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var searchTextField: TextField = {
        let textField = TextField()
        
        textField.initialize(placeHolder: L10n.PlaceSelection.SearchInput.placeholder, showSearchIcon: true)
        textField.returnKeyType = .search
        
        textField.delegate = self
        
        textField.heightAnchor.constraint(equalToConstant: adjustedValue(40, .height)).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
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
        
        tableView.backgroundColor = .red
        return tableView
    }()
    
    lazy var map = {
        let mapView = NMFMapView()
        mapView.isIndoorMapEnabled = true
        mapView.addCameraDelegate(delegate: self)
        
        mapView.heightAnchor.constraint(equalToConstant: adjustedValue(407, .height)).isActive = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var focusMyLoactionButton = {
        let imageView = UIImageView(image: Asset.focusMyLocation.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: adjustedValue(28, .width)),
            imageView.heightAnchor.constraint(equalToConstant: adjustedValue(28, .height))
        ])
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: adjustedValue(44, .width)),
            view.heightAnchor.constraint(equalToConstant: adjustedValue(44, .height))
        ])
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.backgroundColor = .white
        view.layer.cornerRadius = adjustedValue(44, .height) / 2

        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 16
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapFocusMyLoaction))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    
    lazy var confirmView: PlaceSelectionConfirmView = {
        let view = PlaceSelectionConfirmView()
        
        view.handleTappedConfirmButton = { [weak self] in
            guard let self = self else { return }
            guard let place = self.currentPlace else { return }
            
            let city = place.city
            let district = place.district
            
            let address1 = place.roadNameAddress == ""
            ? place.lotNumberAddress
            : place.roadNameAddress
            
            let address2 = self.confirmView.addressTextField.text ?? ""
            
            let latitude = String(place.lat)
            let longitude = String(place.lng)
            
            let result = PlaceLocationMDL(
                city: city,
                disctrict: district,
                address1: address1,
                address2: address2,
                latitude: latitude,
                longitude: longitude
            )
            
            self.dataDelegate?.handlePlaceResult(place: result)
            self.dismiss(animated: true)
        }
        
        view.layer.zPosition = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: handler
    
    private func checkViewControllerPresentationStyle() {
        if let _ = self.navigationController {
            isPushedVC = true
        } else {
            isPushedVC = false
        }
    }
    
    @objc private func onTapKeyboardDismissBackdrop() {
        view.endEditing(true)
    }
    
    @objc private func onTapFocusMyLoaction() {
        let location = LocationService.shared.currentLocation
        moveMap(to: location)
    }
    
    private func moveMap(to location: CLLocationCoordinate2D) {
        let target = NMGLatLng(lat: location.latitude, lng: location.longitude)
        let position = NMFCameraPosition(target, zoom: 17)
        let update = NMFCameraUpdate(position: position)
        map.moveCamera(update)
    }
    
    private func clearData() {
        searchTextField.text = ""
        confirmView.clearLabel()
        
        let location = LocationService.shared.currentLocation
        moveMap(to: location)
    }
    
    private func listenKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        self.keyboardDismissBackdrop.isHidden = false
        
        if let activeSearchTextField, activeSearchTextField == searchTextField {
            return
        }
        
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height
        let options = UIView.AnimationOptions(rawValue: curve.uintValue << 16)
        
        UIView.animate(withDuration: animationDuration.doubleValue, delay: 0, options: options, animations: {
            
            self.confirmViewBottomAnchorConstraint.constant = -keyboardHeight
            self.confirmViewHeightAnchorConstraint.constant = self.confirmViewMinHeight
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.keyboardDismissBackdrop.isHidden = true
        
        if let activeSearchTextField, activeSearchTextField == searchTextField {
            return
        }
        
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else { return }

        let options = UIView.AnimationOptions(rawValue: curve.uintValue << 16)

        UIView.animate(withDuration: animationDuration.doubleValue, delay: 0, options: options, animations: {
            
            self.confirmViewBottomAnchorConstraint.constant = 0
            self.confirmViewHeightAnchorConstraint.constant = self.confirmViewMaxHeight
            
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    // MARK: initialize
    
    init(mode: PlaceSelectionMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        render()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onWillShow?()
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
    
    private func configure() {
        view.backgroundColor = .white
        
        switch mode {
        case .departure:
            viewState = .idle
        case .destination:
            viewState = .onSearch
        }
        
        LocationService.shared.start()
        checkViewControllerPresentationStyle()
        confirmView.configureAddressTextfieldDelegate(self)
        listenKeyboardNotification()
        
    }
    
    private func render() {
        [
            headerView,
         searchTextField,
         tipView,
         searchFailView,
         map,
         focusMyLoactionButton,
         probee,
         tableView,
         keyboardDismissBackdrop,
         confirmView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        confirmViewBottomAnchorConstraint = confirmView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        confirmViewHeightAnchorConstraint = confirmView.heightAnchor.constraint(equalToConstant: confirmViewMaxHeight)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            keyboardDismissBackdrop.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            keyboardDismissBackdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardDismissBackdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardDismissBackdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: adjustedValue(16, .height)),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: adjustedValue(24, .width)),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -adjustedValue(24, .width)),
            
            tipView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: adjustedValue(16, .height)),
            tipView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tipView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tipView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            searchFailView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: adjustedValue(16, .height)),
            searchFailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchFailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchFailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            map.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: adjustedValue(16, .height)),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            focusMyLoactionButton.bottomAnchor.constraint(equalTo: map.bottomAnchor, constant: -adjustedValue(15, .height)),
            focusMyLoactionButton.trailingAnchor.constraint(equalTo: map.trailingAnchor, constant: -adjustedValue(10, .width)),
            
            probee.centerXAnchor.constraint(equalTo: map.centerXAnchor),
            probee.centerYAnchor.constraint(equalTo: map.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: adjustedValue(16, .height)),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            confirmView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmViewBottomAnchorConstraint,
            confirmViewHeightAnchorConstraint
        ])
    }
}

extension PlaceSelectionVC: HeaderViewDelegate {
    func onTapRightView() {
        dismiss(animated: true)
    }
    
    func onTapLeftView() {
        switch viewState {
        case .onSearch:
            view.endEditing(true)
        case .searchMap:
            viewState = .searchResult
        case .searchResult:
            viewState = .idle
        case .searchFail:
            viewState = .idle
        case .idle:
            view.endEditing(true)
            navigationController?.popViewController(animated: true)
        }
    }
}
