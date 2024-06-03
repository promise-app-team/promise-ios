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
    var address1: String = ""
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
    
    private let editingPlace: PlaceLocationMDL?
    
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
            
            print("cur: ", currentPlace)
            
            switch viewState {
            case .idle:
                
                self.headerView.isHiddenLeftView = !self.isPushedVC
                self.headerView.isHiddenRightView = self.isPushedVC
                
                self.searchFailView.isHidden = true
                self.tipView.isHidden = true
                self.tableView.isHidden = true
                
                self.map.allowsScrolling = true
                // self.map.isHidden = false
                // self.confirmView.isHidden = false
                // self.probee.isHidden = false
                // self.focusMyLoactionButton.isHidden = false
                
                clearData()
                
            case .onSearch:
                
                self.headerView.isHiddenLeftView = !self.isPushedVC
                self.headerView.isHiddenRightView = self.isPushedVC
                
                self.searchFailView.isHidden = true
                self.tipView.isHidden = false
                self.tableView.isHidden = true
                
                // self.map.isHidden = true
                // self.confirmView.isHidden = true
                // self.probee.isHidden = true
                // self.focusMyLoactionButton.isHidden = true
                
                let _ = self.searchTextField.becomeFirstResponder()
                self.marker = nil
                
            case .searchFail:
                
                self.headerView.isHiddenLeftView = !self.isPushedVC
                self.headerView.isHiddenRightView = self.isPushedVC
                
                self.searchFailView.isHidden = false
                self.tipView.isHidden = true
                self.tableView.isHidden = true
                
                // self.map.isHidden = true
                // self.confirmView.isHidden = true
                // self.probee.isHidden = true
                // self.focusMyLoactionButton.isHidden = true
                
            case .searchResult:
                
                self.headerView.isHiddenLeftView = !self.isPushedVC
                self.headerView.isHiddenRightView = self.isPushedVC
                
                self.searchFailView.isHidden = true
                self.tipView.isHidden = true
                self.tableView.isHidden = false
                
                // self.map.isHidden = true
                // self.confirmView.isHidden = true
                // self.probee.isHidden = true
                // self.focusMyLoactionButton.isHidden = true
                
            case .searchMap:
                
                self.headerView.isHiddenLeftView = false
                self.headerView.isHiddenRightView = self.isPushedVC
                
                self.searchFailView.isHidden = true
                self.tipView.isHidden = true
                self.tableView.isHidden = true
                
                self.map.allowsScrolling = false
                // self.map.isHidden = false
                // self.confirmView.isHidden = false
                // self.probee.isHidden = true
                self.focusMyLoactionButton.isHidden = true
                
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
    
    lazy var searchTextField: TextField = {
        let textField = TextField()
        
        textField.initialize(placeHolder: L10n.PlaceSelection.SearchInput.placeholder, showSearchIcon: true)
        textField.returnKeyType = .search
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(onChangedSearchTextField), for: .editingChanged)
        
        textField.heightAnchor.constraint(equalToConstant: adjustedValue(40, .height)).isActive = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let tipView = {
        let placeSelectionTipView = PlaceSelectionTipView()
        placeSelectionTipView.isHidden = true
        placeSelectionTipView.translatesAutoresizingMaskIntoConstraints = false
        return placeSelectionTipView
    }()
    
    private let searchFailView = {
        let placeSelectionSearchFailView = PlaceSelectionSearchFailView()
        placeSelectionSearchFailView.isHidden = true
        placeSelectionSearchFailView.translatesAutoresizingMaskIntoConstraints = false
        return placeSelectionSearchFailView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            PlaceSelectionTableViewCell.self,
            forCellReuseIdentifier: PlaceSelectionTableViewCell.identifier
        )
        
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var map = {
        let mapView = NMFMapView()
        mapView.isIndoorMapEnabled = true
        mapView.addCameraDelegate(delegate: self)
        
        let height = isPushedVC ? adjustedValue(407, .height) : adjustedValue(397, .height)
        mapView.heightAnchor.constraint(equalToConstant: height).isActive = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let probee: UIImageView = {
        let imageView = UIImageView(image: Asset.probeeOnMap.image)
        imageView.widthAnchor.constraint(equalToConstant: adjustedValue(256, .width)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(89, .height)).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
            
            let address2 = self.confirmView.addressTextField.text ?? ""
            
            let result = PlaceLocationMDL(
                city: place.city,
                disctrict: place.district,
                address1: place.address1,
                address2: address2,
                latitude: String(place.lat),
                longitude: String(place.lng)
            )
            
            self.dataDelegate?.handlePlaceResult(place: result)
            
            if isPushedVC {
                navigationController?.popViewController(animated: true)
            } else {
                self.dismiss(animated: true)
            }
            
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    // MARK: handler
    
    private func checkViewControllerPresentationStyle() {
        if let _ = self.navigationController {
            isPushedVC = true
        } else {
            isPushedVC = false
        }
    }
    
    @objc private func onChangedSearchTextField(_ textField: UITextField) {
        let text = textField.text ?? ""
        if text.isEmpty {
            viewState = .onSearch
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
        DispatchQueue.main.async { [weak self] in
            let target = NMGLatLng(lat: location.latitude, lng: location.longitude)
            let position = NMFCameraPosition(target, zoom: 17)
            let update = NMFCameraUpdate(position: position)
            update.animation = .linear
            self?.map.moveCamera(update)
        }
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
    
    init(mode: PlaceSelectionMode, editingPlace: PlaceLocationMDL? = nil) {
        self.mode = mode
        self.editingPlace = editingPlace
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
        
        LocationService.shared.start()
        
        checkViewControllerPresentationStyle()
        confirmView.configureAddressTextfieldDelegate(self)
        listenKeyboardNotification()
        
        switch mode {
        case .departure:
            viewState = .idle
        case .destination:
            viewState = .onSearch
        }
        
    }
    
    private func render() {
        [
            headerView,
            searchTextField,
            
            map,
            probee,
            focusMyLoactionButton,
            confirmView,
            
            // MARK: 아래 3개 view는 위 view들 보다 위에 있어야함. (순서 바꾸면 zPosition으로 해결해야함)
            tipView,
            searchFailView,
            tableView,
            // ==========================================================================
            
            keyboardDismissBackdrop
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
            
            searchTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: adjustedValue(16, .height)),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: adjustedValue(24, .width)),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -adjustedValue(24, .width)),
            
            map.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: adjustedValue(16, .height)),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            probee.centerXAnchor.constraint(equalTo: map.centerXAnchor),
            probee.centerYAnchor.constraint(equalTo: map.centerYAnchor),
            
            focusMyLoactionButton.bottomAnchor.constraint(equalTo: map.bottomAnchor, constant: -adjustedValue(15, .height)),
            focusMyLoactionButton.trailingAnchor.constraint(equalTo: map.trailingAnchor, constant: -adjustedValue(10, .width)),
            
            confirmView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            confirmView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            confirmViewBottomAnchorConstraint,
            confirmViewHeightAnchorConstraint,
            
            tipView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: adjustedValue(16, .height)),
            tipView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tipView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tipView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            searchFailView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: adjustedValue(16, .height)),
            searchFailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchFailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchFailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: adjustedValue(16, .height)),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            keyboardDismissBackdrop.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: adjustedValue(16, .height)),
            keyboardDismissBackdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardDismissBackdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardDismissBackdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
