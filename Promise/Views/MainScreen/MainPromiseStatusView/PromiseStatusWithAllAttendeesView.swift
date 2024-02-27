//
//  PromiseStatusWithAllAttendees.swift
//  Promise
//
//  Created by kwh on 2/3/24.
//

import Foundation
import UIKit
import NMapsMap

class AttendeeCellForDetail: UICollectionViewCell {
    static let identifier = "AttendeeCellForDetail"
    
    private lazy var attendeeProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = contentView.frame.size.height / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(attendeeProfileImage)
        
        NSLayoutConstraint.activate([
            attendeeProfileImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            attendeeProfileImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            attendeeProfileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            attendeeProfileImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func configureAttendeeCellForDetail(with attendee: Components.Schemas.Attendee) {
        guard let profileUrl = attendee.profileUrl, let imageUrl = URL(string: profileUrl) else {
            // TODO: 이미지 url이 없을 경우 디폴트 이미지
            return
        }
        
        attendeeProfileImage.load(url: imageUrl)
    }
}

class PromiseStatusWithAllAttendeesView: UIView {
    // MARK: properties
    
    let mainVM: MainVM
    
    private var isCollapsedAttendeesStatusView = false
    private let attendeesStatusViewMaxHeight = adjustedValue(320, .height)
    private let attendeesStatusViewMinHeight = adjustedValue(90, .height)
    private var attendeesStatusViewHeightConstraint: NSLayoutConstraint!
    
    private let themesScrollWrapTopMaxSpacing = adjustedValue(16 * 4, .height)
    private let themesScrollWrapTopMinSpacing = adjustedValue(16, .height)
    private var themesScrollWrapTopConstraint: NSLayoutConstraint!
    
    private var shareUrl: URL? = nil
    private let attendeesViewHeight = 32.0
    private var attendees: [Components.Schemas.Attendee] = []
    
    private var isOwner = false {
        didSet {
            if(isOwner) {
                self.shareButton.isHidden = false
                self.moreMenuContentView.updateMenus(menus: [
                    .edit,
                    .delegate,
                    .leave
                ])
            } else {
                self.shareButton.isHidden = true
                self.shareUrl = nil
                self.moreMenuContentView.updateMenus(menus: [
                    .leave
                ])
            }
        }
    }
    
    private let mapHelper = MapHelper()
    private var mapDefaultZoomLevel: Double = 16
    
    private lazy var promiseDestinationMarker = {
        let maker = NMFMarker()
        maker.iconImage = NMF_MARKER_IMAGE_RED
        maker.mapView = map
        return maker
    }()
    
    private lazy var userLocationMarker = {
        let maker = NMFMarker()
        maker.iconImage = NMF_MARKER_IMAGE_BLUE
        maker.mapView = map
        return maker
    }()
    
    private var userLocation: CLLocation? {
        didSet {
            guard let userLocation else { return }
            mapHelper.animateMarker(marker: userLocationMarker, to: NMGLatLng(lat: userLocation.coordinate.latitude, lng: userLocation.coordinate.longitude), duration: 0.5, animationEffect: .easeIn)
            
            
            // 지도에 마커를 다시 추가하여 위치를 업데이트
//             userLocationMarker.mapView = map
        }
    }
    
    private var authorizationStatus: CLAuthorizationStatus? {
        didSet {
            if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
                // MARK: 인증 상태가 바뀌어 위치정보가 업데이트 되면 userLocation이 있기 때문에 실행 가능
                setUserLocationMarkerOnMap()
                
                // MARK: 내장 location overlay 세팅
                // setUserLocationOverlayOnMap()
            }
        }
    }
    
    // MARK: subviews
    
    let spacingView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: adjustedValue(34, .height)).isActive = true
        view.backgroundColor = .white
        view.layer.zPosition = 1
        return view
    }()
    
    private lazy var collapseButton = {
        let imageView = UIImageView(image: Asset.arrowDown.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapCollapseButton))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let headerTitle = {
        let label = UILabel()
        
        label.text = L10n.PromiseStatusWithAllAttendeesView.Header.title
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width))
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var shareButton = {
        let imageView = UIImageView(image: Asset.share.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: adjustedValue(24, .width)),
            imageView.heightAnchor.constraint(equalToConstant: adjustedValue(24, .height))
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapShareButton))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        imageView.isHidden = true
        
        return imageView
    }()
    
    private lazy var moreButton = {
        let imageView = UIImageView(image: Asset.more.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: adjustedValue(24, .width)),
            imageView.heightAnchor.constraint(equalToConstant: adjustedValue(24, .height))
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapMoreButton))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private lazy var menuWrapper = {
        let stackView = UIStackView(arrangedSubviews: [
            shareButton,
            moreButton
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = adjustedValue(16, .width)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var moreMenuContentView = PromiseStatusMoreMenuContentView(mv: mainVM)
    
    
    private lazy var header = {
        let view = UIView()
        
        [headerTitle, menuWrapper].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            headerTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            menuWrapper.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            menuWrapper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(16, .width))
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: adjustedValue(56, .height)).isActive = true
        return view
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
    
    private lazy var map = {
        let mapView = NMFMapView()
        
        mapView.isIndoorMapEnabled = true // 실내 지도 활성화(역사 내부 지도 등)
        mapView.touchDelegate = self
        mapView.zoomLevel = mapDefaultZoomLevel
        
        // MARK: NMFMapView 내장 locationOverlay 사용 할 때
        // mapView.locationOverlay.hidden = false
        // mapView.positionMode = NMFMyPositionMode.compass
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private let promisedAt = {
        let label = UILabel()
        
        label.textColor =  UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        
        let font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(13, .width))
        label.font = font
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let lineHeight = font?.lineHeight
        label.heightAnchor.constraint(equalToConstant: lineHeight ?? 0).isActive = true
        
        return label
    }()
    
    private let title = {
        let label = UILabel()
        
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        let font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(18, .width))
        label.font = font
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let lineHeight = font?.lineHeight
        label.heightAnchor.constraint(equalToConstant: lineHeight ?? 0).isActive = true
        
        return label
    }()
    
    private let createTaggedTheme = { (themeTitle: String) in
        let insetLabel = InsetLabel()
        insetLabel.topInset = adjustedValue(3, .height)
        insetLabel.bottomInset = adjustedValue(3, .height)
        insetLabel.leftInset = adjustedValue(7, .width)
        insetLabel.rightInset = adjustedValue(7, .width)
        
        insetLabel.lineBreakMode = .byClipping
        insetLabel.numberOfLines = 1
        
        insetLabel.text = themeTitle
        insetLabel.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(13, .width))
        insetLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        insetLabel.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        
        insetLabel.layer.masksToBounds = true
        insetLabel.layer.cornerRadius = adjustedValue(11, .width)
        insetLabel.sizeToFit()
        
        insetLabel.translatesAutoresizingMaskIntoConstraints = false
        return insetLabel
    }
    
    private let taggedThemes = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = adjustedValue(4, .width)
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var themesScrollWrap = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(taggedThemes)
        NSLayoutConstraint.activate([
            taggedThemes.topAnchor.constraint(equalTo: scrollView.topAnchor),
            taggedThemes.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            taggedThemes.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            taggedThemes.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            taggedThemes.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let placeLabel = {
        let label = UILabel()
        label.text = L10n.Common.place
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(13, .width))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let place = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(17, .width))
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hostLabel = {
        let label = UILabel()
        label.text = L10n.Common.host
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(13, .width))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let host = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(17, .width))
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let attendeesCount = {
        let label = UILabel()
        label.text = "(0)"
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(13, .width))
        label.textColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var attendeesLabel = {
        let label = UILabel()
        label.text = L10n.Common.attendees
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(13, .width))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        [label, attendeesCount].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            attendeesCount.topAnchor.constraint(equalTo: view.topAnchor),
            attendeesCount.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            attendeesCount.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: adjustedValue(2, .width)),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var attendeesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AttendeeCellForDetail.self, forCellWithReuseIdentifier: AttendeeCellForDetail.identifier)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var attendeesStatusView = {
        let view = UIView()
        
        [
            collapseButton,
            promisedAt,
            title,
            themesScrollWrap,
            placeLabel,
            place,
            hostLabel,
            host,
            attendeesLabel,
            attendeesView
        ].forEach { view.addSubview($0) }
        
        // MARK: collapse 될 때 늘어남
        themesScrollWrapTopConstraint = themesScrollWrap.topAnchor.constraint(equalTo: title.bottomAnchor, constant: themesScrollWrapTopMinSpacing)
        themesScrollWrapTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            collapseButton.topAnchor.constraint(equalTo: view.topAnchor, constant: adjustedValue(30, .height)),
            collapseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            
            promisedAt.topAnchor.constraint(equalTo: view.topAnchor, constant: adjustedValue(24, .height)),
            promisedAt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            promisedAt.trailingAnchor.constraint(equalTo: collapseButton.leadingAnchor, constant: -adjustedValue(12, .width)),
            
            title.topAnchor.constraint(equalTo: promisedAt.bottomAnchor, constant: adjustedValue(4, .height)),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            title.trailingAnchor.constraint(equalTo: collapseButton.leadingAnchor, constant: -adjustedValue(12, .width)),
            
            themesScrollWrap.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            themesScrollWrap.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            
            placeLabel.topAnchor.constraint(equalTo: themesScrollWrap.bottomAnchor, constant: adjustedValue(16, .height)),
            placeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            placeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            
            place.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: adjustedValue(6, .height)),
            place.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            place.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            
            hostLabel.topAnchor.constraint(equalTo: place.bottomAnchor, constant: adjustedValue(16, .height)),
            hostLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            hostLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            
            host.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: adjustedValue(6, .height)),
            host.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            host.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            
            attendeesLabel.topAnchor.constraint(equalTo: host.bottomAnchor, constant: adjustedValue(16, .height)),
            attendeesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            attendeesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            
            attendeesView.topAnchor.constraint(equalTo: attendeesLabel.bottomAnchor, constant: adjustedValue(10, .height)),
            attendeesView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            attendeesView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width)),
            attendeesView.heightAnchor.constraint(equalToConstant: adjustedValue(attendeesViewHeight, .height))
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: handler
    
    private func assignThemesToTaggedThemes(with themes: [String]) {
        // 기존의 뷰들을 스택 뷰에서 제거
        taggedThemes.arrangedSubviews.forEach {
            taggedThemes.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        themes.forEach { themeTitle in
            let taggedTheme = createTaggedTheme(themeTitle)
            taggedThemes.addArrangedSubview(taggedTheme)
        }
    }
    
    @objc private func onTapCollapseButton() {
        if isCollapsedAttendeesStatusView {
            UIView.animate(withDuration: 0.2) {
                self.collapseButton.transform = CGAffineTransform(rotationAngle: -(.pi * 2))
                self.attendeesStatusViewHeightConstraint.constant = self.attendeesStatusViewMaxHeight
                self.themesScrollWrapTopConstraint.constant = self.themesScrollWrapTopMinSpacing
                self.layoutIfNeeded()
                self.isCollapsedAttendeesStatusView = false
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.collapseButton.transform = CGAffineTransform(rotationAngle: .pi)
                self.attendeesStatusViewHeightConstraint.constant = self.attendeesStatusViewMinHeight
                self.themesScrollWrapTopConstraint.constant = self.themesScrollWrapTopMaxSpacing
                self.layoutIfNeeded()
                self.isCollapsedAttendeesStatusView = true
            }
        }
    }
    
    
    @objc private func onTapFocusMyLoaction() {
        guard let location = userLocation else { return }
        focusMapOnLocation(location: location)
    }
    
    @objc private func onTapShareButton() {
        guard let shareUrl else { return }
        guard let topVC = parentViewController() else { return }
        
        // UIActivityViewController 초기화
        let activityViewController = UIActivityViewController(activityItems: [shareUrl], applicationActivities: nil)
        
        // iPad에서는 popover로 표시해야 할 수 있음
        activityViewController.popoverPresentationController?.sourceView = self
        
        // UIActivityViewController 표시
        topVC.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func onTapMoreButton() {
        guard let topVC = parentViewController() else { return }
        CommonModalManager.shared.show(content: moreMenuContentView, from: topVC)
    }
    
    
    
    private func focusMapOnLocation(location: CLLocation) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: location.coordinate.latitude, lng: location.coordinate.longitude))
        cameraUpdate.animation = .linear
        map.moveCamera(cameraUpdate)
    }
    
    private func setDestinationMarkerOnMap(destination: Components.Schemas.OutputDestination?) {
        guard let destination else { return }

        promiseDestinationMarker.position = NMGLatLng(
            lat: destination.latitude,
            lng: destination.longitude
        )
        
        promiseDestinationMarker.mapView = map
        
        focusMapOnLocation(location: CLLocation(
            latitude: destination.latitude,
            longitude: destination.longitude
        ))
        
    }
    
    // MARK: userlocation이 있어야 마커 등록 가능
    private func setUserLocationMarkerOnMap() {
        guard let location = userLocation else { return }
        
        userLocationMarker.position = NMGLatLng(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        )
        
        userLocationMarker.mapView = map
    }
    
    private func setUserLocationOverlayOnMap() {
        let user = UserService.shared.getUser()
        if let profileUrl = user?.profileUrl, let imageUrl = URL(string: profileUrl) {
            
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: imageUrl)
                    guard let image = UIImage(data: data) else {
                        // TODO: 데이터로 이미지 변환 실패, fallback image
                        return
                    }
                    
                    guard let resizedImage = image
                        .resize(newSize: CGSize(width: adjustedWidth(36), height: adjustedHeight(36)))
                        .withRoundedCorners(radius: adjustedWidth(18), borderWidth: 5, borderColor: UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1))
                    else {
                        // TODO: 이미지 리사이즈 및 레이어 변환 실패, fallback image
                        return
                    }
                    
                    DispatchQueue.main.async {
                        self.map.locationOverlay.hidden = false
                        
                        self.map.locationOverlay.icon = NMFOverlayImage(image: resizedImage)
                        self.map.locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
                        
                        self.map.locationOverlay.subIcon = NMFOverlayImage(image: Asset.subMarkerPrimary.image)
                        self.map.locationOverlay.subIconWidth = adjustedWidth(36)
                        self.map.locationOverlay.subIconHeight = adjustedWidth(20)
                        self.map.locationOverlay.subAnchor = CGPoint(x: 0.5, y: 0.65)
                        
                        self.map.locationOverlay.circleColor = UIColor.clear
                        self.map.locationOverlay.circleRadius = 0
                    }
                    
                } catch {
                    // TODO: 이미지 요청 실패, fallback image
                }
            }
            
        }
    }
    
    // MARK: self 초기화 시 실행됨
    private func setPromiseStatusForMap(with promise: Components.Schemas.OutputPromiseListItem) {
        
        setDestinationMarkerOnMap(destination: promise.destination?.value1)
        
        // MARK: 내장 location overlay 세팅
        // setUserLocationOverlayOnMap()
    }
    
    // MARK: self 초기화 시 실행됨
    private func setPromiseDetailInfo(with promise: Components.Schemas.OutputPromiseListItem) {
        // TimeInterval을 Date 객체로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd a hh시 mm분"
        
        promisedAt.text = dateFormatter.string(from: promise.promisedAt)
        
        title.text = promise.title
        
        assignThemesToTaggedThemes(with: promise.themes)
        
        // 공유 링크 세팅
        let sharePromiseId = promise.pid
        if(!sharePromiseId.isEmpty) {
            self.shareUrl = URL(string: "\(Config.universalLinkDomain)/share/\(sharePromiseId)")
        }
        
        switch promise.destinationType {
        case .DYNAMIC:
            place.text = L10n.Main.PromiseList.DynamicPlace.placeholder
            place.textColor = UIColor(red: 1, green: 0.408, blue: 0.304, alpha: 1)
        case .STATIC:
            if let destination = promise.destination {
                place.text = destination.value1.address
                place.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
        
        
        host.text = promise.host.username
        
        attendeesCount.text = "(\(promise.attendees.count))"
        attendees = promise.attendees
        
        // MARK: 중요! cell이 재사용되면서 내부 attendeesView(collectionView)가 같이 재사용될 수 있음. reloadData or prepareForReuse override 로 해결.
        attendeesView.reloadData()
        
        self.isOwner = String(Int(promise.host.id)) == UserService.shared.getUser()?.userId
    }
    
    // MARK: initialize
    
    init(vm: MainVM) {
        self.mainVM = vm
        super.init(frame: .null)
        configure()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let initialPromise = mainVM.currentFocusedPromise {
            setPromiseDetailInfo(with: initialPromise)
            setPromiseStatusForMap(with: initialPromise)
        }
    }
    
    private func render() {
        [spacingView, header, map, focusMyLoactionButton, attendeesStatusView].forEach { addSubview($0) }
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        
        attendeesStatusViewHeightConstraint = attendeesStatusView.heightAnchor.constraint(equalToConstant: attendeesStatusViewMaxHeight)
        attendeesStatusViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            spacingView.topAnchor.constraint(equalTo: topAnchor),
            spacingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            spacingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            header.topAnchor.constraint(equalTo: spacingView.bottomAnchor),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            map.topAnchor.constraint(equalTo: header.bottomAnchor),
            map.leadingAnchor.constraint(equalTo: leadingAnchor),
            map.trailingAnchor.constraint(equalTo: trailingAnchor),
            map.bottomAnchor.constraint(equalTo: attendeesStatusView.topAnchor),
            
            focusMyLoactionButton.bottomAnchor.constraint(equalTo: map.bottomAnchor, constant: -adjustedValue(15, .height)),
            focusMyLoactionButton.trailingAnchor.constraint(equalTo: map.trailingAnchor, constant: -adjustedValue(10, .width)),
            
            attendeesStatusView.leadingAnchor.constraint(equalTo: leadingAnchor),
            attendeesStatusView.trailingAnchor.constraint(equalTo: trailingAnchor),
            attendeesStatusView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension PromiseStatusWithAllAttendeesView {
    public func updatePromiseStatusWithAllAttendees(with promise: Components.Schemas.OutputPromiseListItem) {
        setPromiseDetailInfo(with: promise)
    }
    
    public func updateUserLocation(location: CLLocation) {
        userLocation = location
    }
    
    public func updateAuthorizationStatus(status: CLAuthorizationStatus) {
        authorizationStatus = status
    }
    
}

extension PromiseStatusWithAllAttendeesView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attendees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendeeCellForDetail.identifier, for: indexPath) as? AttendeeCellForDetail else {
            return UICollectionViewCell()
        }
        
        let attendee = attendees[indexPath.row]
        cell.configureAttendeeCellForDetail(with: attendee)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: adjustedValue(attendeesViewHeight, .width), height: adjustedValue(attendeesViewHeight, .height))
    }

//    // 섹션당 상하 간격 설정
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return adjustedValue(8, .height)
//    }
//    
//    // 섹션당 좌우 간격 설정
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return adjustedValue(8, .width)
//    }
//    
//    // 섹션의 여백 설정
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: adjustedValue(3, .height), left: 0, bottom: 0, right: 0)
//    }
//    
//    // 셀을 클릭했을 때의 로직
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//    }
}

extension PromiseStatusWithAllAttendeesView: NMFMapViewTouchDelegate {
    
}
