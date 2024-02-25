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
    func handlePlaceResult(place: PlaceSelection)
}

struct PlaceSelection {
    var name: String = "주소"
    var lat: Double = 37.565643683342
    var lon: Double = 126.95524147826
}

class PlaceSelectionVC: UIViewController {
    
    enum SearchStatus {
        case idle, searching, searchFail, resultList, map
    }
    
    // MARK: Public Property
    
    weak var delegate: PlaceSelectionDelegate?
    weak var dataDelegate: PlaceSelectionDataDelegate?
    
    var viewState: SearchStatus! {
        didSet {
            switch self.viewState {
            case .idle:
                DispatchQueue.main.async {
                    self.tipView.isHidden = false
                    self.tableView.isHidden = true
                    self.naverMapView.isHidden = true
                    self.confirmView.isHidden = true
                }
                marker = nil
            case .searching:
                break
            case .searchFail:
                break
            case .resultList:
                DispatchQueue.main.async {
                    self.tipView.isHidden = true
                    self.tableView.isHidden = false
                    self.naverMapView.isHidden = true
                    self.confirmView.isHidden = true
                }
            case .map:
                DispatchQueue.main.async {
                    self.tipView.isHidden = true
                    self.tableView.isHidden = true
                    self.naverMapView.isHidden = false
                    self.confirmView.isHidden = false
                }
            case .none:
                break
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
    
    var currentPlace = PlaceSelection()
    
    private lazy var headerView: HeaderView = {
        let headerView = HeaderView(navigationController: nil, title: "약속장소 설정")
        headerView.delegate = self
        return headerView
    }()
    
    lazy var searchTextField: TextField = {
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
    
    let naverMapView: NMFNaverMapView = {
        let naverMapView = NMFNaverMapView()
        naverMapView.showCompass = true
        naverMapView.showZoomControls = true
        
        let mapView =  naverMapView.mapView
        mapView.latitude = 37.4222864409138
        mapView.longitude = 126.687581340746
        return naverMapView
    }()
    
    lazy var confirmView: PlaceSelectionConfirmView = {
        let view = PlaceSelectionConfirmView()
        view.handleTappedConfirmButton = {
            print("tapped confirm button")
            self.currentPlace.name = "\(view.titleLabel.text ?? "") \(view.addressTextField.text ?? "")"
            self.dataDelegate?.handlePlaceResult(place: self.currentPlace)
            self.dismiss(animated: true)
        }
        return view
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAccountVC()
        render()
        viewState = .idle
        confirmView.configureAddressTextfieldDelegate(self)
        
        addKeyboardNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.onWillShow?()
        let _ = searchTextField.becomeFirstResponder()
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
        [headerView, searchTextField, tipView, tableView, naverMapView, confirmView].forEach {
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
            
            searchTextField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            tipView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            tipView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tipView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tipView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            naverMapView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            naverMapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            naverMapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            naverMapView.bottomAnchor.constraint(equalTo: confirmView.topAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            confirmView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            confirmView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            confirmView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            confirmView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }
}

// MARK: HeaderViewDelegate

extension PlaceSelectionVC: HeaderViewDelegate {
    
    func onTapCustomBackAction() {
        if viewState == .map {
            viewState = .resultList
        } else {
            dismiss(animated: true)
        }
    }
}
