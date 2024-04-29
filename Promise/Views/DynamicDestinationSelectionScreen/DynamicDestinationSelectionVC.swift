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

class AttendeeCellForDeparturesSelection: UICollectionViewCell {
    static let identifier = "AttendeeCellForDeparturesSelection"
    
    private lazy var attendeeProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: adjustedValue(46, .width)).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: adjustedValue(46, .height)).isActive = true
        imageView.layer.cornerRadius = adjustedValue(23, .width)
        imageView.layer.borderWidth = adjustedValue(2, .width)
        imageView.layer.borderColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor
        
        return imageView
    }()
    
    private let attendeeNickname = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(12, .width))
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var attendee = {
        let stackView = UIStackView(arrangedSubviews: [
            attendeeProfileImage,
            attendeeNickname
        ])
        
        stackView.axis = .vertical
        stackView.spacing = adjustedValue(4, .height)
        stackView.alignment = .center
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(attendee)
        
        NSLayoutConstraint.activate([
            attendee.topAnchor.constraint(equalTo: contentView.topAnchor),
            attendee.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            attendee.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            attendee.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func updateCell(with attendee: SelectableAttendee) {
        if !attendee.info.hasStartLocation {
             self.attendee.alpha = 0.2
            self.attendeeProfileImage.layer.borderColor = UIColor.clear.cgColor
            return
        }
        
        if attendee.isSelected {
            self.attendeeProfileImage.layer.borderColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor
        } else {
            self.attendeeProfileImage.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        }
    }
    
    func configureCell(with attendee: SelectableAttendee) {
        let image = attendeeProfileImage.image
        let text = attendeeNickname.text
        
        guard image == nil, text == nil else {
            updateCell(with: attendee)
            return
        }
        
        guard let profileUrl = attendee.info.profileUrl, let imageUrl = URL(string: profileUrl) else {
            // TODO: 이미지 url이 없을 경우 디폴트 이미지
            return
        }
        
        // MARK: 프로필 이미지 구성
        attendeeProfileImage.load(url: imageUrl)
        
        // MARK: 닉네임 구성
        attendeeNickname.text = attendee.info.username ?? ""
        
        // MARK: 선택, 출발지 여부에 따른 UI 업데이트
        updateCell(with: attendee)
    }
}

class DynamicDestinationSelectionVC: UIViewController {
    // MARK: properties
    private let createPromiseVM: CreatePromiseVM
    private let dynamicDestinationSelectionVM: DynamicDestinationSelectionVM
    
    private let state: DynamicDestinationState
    private var mapDefaultZoomLevel: Double = 16
    
    private var dynamicConstraintAreaByKeypadBottomConstraint: NSLayoutConstraint!
    
    private let selectAttendeeDeparturesHeightForTwoLines = adjustedValue(144, .height)
    private let selectAttendeeDeparturesHeightForOneLine = adjustedValue(68, .height)
    private lazy var selectAttendeeDeparturesHeight = 5 < dynamicDestinationSelectionVM.attendees.count ? selectAttendeeDeparturesHeightForTwoLines : selectAttendeeDeparturesHeightForOneLine
    
    private let bottomAreaHeightForTwoLines = adjustedValue(326, .height)
    private let bottomAreaHeightForOneLine = adjustedValue(250, .height)
    
    private lazy var bottomAreaMaxHeight = 5 < dynamicDestinationSelectionVM.attendees.count ? bottomAreaHeightForTwoLines : bottomAreaHeightForOneLine
    private let bottomAreaMinHeight: CGFloat = adjustedValue(170, .height)
    
    private var bottomAreaHeightConstraint: NSLayoutConstraint!
    private var originalY: CGFloat = 0
    
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
    
    private lazy var selectAttendeeDepartures: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AttendeeCellForDeparturesSelection.self, forCellWithReuseIdentifier: AttendeeCellForDeparturesSelection.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: selectAttendeeDeparturesHeight).isActive = true
        
        return collectionView
    }()
    
    private lazy var detailAddressInput = {
        let textField = UITextField()
        
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1),
            NSAttributedString.Key.font: UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(16, .width)) ?? UIFont.systemFont(ofSize: adjustedValue(16, .width))
        ]
        
        textField.attributedPlaceholder = NSAttributedString(
            string: L10n.DynamicDestinationSelection.DetailAddress.placeholder,
            attributes: placeholderAttributes
        )
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(onChangedDetailAddress), for: .editingChanged)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.topAnchor, constant: adjustedValue(8, .height)),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(16, .height)),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(16, .height)),
            textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -adjustedValue(8, .height))
        ])
        
        view.layer.borderWidth = adjustedValue(1, .width)
        view.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        view.layer.cornerRadius = adjustedValue(8, .width)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: adjustedValue(40, .height)).isActive = true
        return view
    }()
    
    private lazy var detailAddressWrapper = {
        let label = UILabel()
        label.text = L10n.DynamicDestinationSelection.DetailAddress.label
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(12, .width))
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView(arrangedSubviews: [
            label,
            detailAddressInput
        ])
        
        stackView.axis = .vertical
        stackView.spacing = adjustedValue(8, .height)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var confirmButton = {
        let button = Button()
        button.initialize(title: L10n.DynamicDestinationSelection.confirm, style: .primary)
        button.addTarget(self, action: #selector(onConfirm), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: Button.Height).isActive = true
        return button
    }()
    
    private lazy var dynamicConstraintAreaByKeypad = {
        let stackView = UIStackView(arrangedSubviews: [
            detailAddressWrapper,
            confirmButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = adjustedValue(24, .height)
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(
            top: adjustedValue(8, .width),
            left: adjustedValue(24, .width),
            bottom: 0,
            right: adjustedValue(24, .width)
        )
        
        stackView.backgroundColor = .white
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bottomArea = {
        let grabber = UIView()
        grabber.translatesAutoresizingMaskIntoConstraints = false
        grabber.widthAnchor.constraint(equalToConstant: adjustedValue(80, .width)).isActive = true
        grabber.heightAnchor.constraint(equalToConstant: adjustedValue(4, .height)).isActive = true
        grabber.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        grabber.layer.cornerRadius = adjustedValue(2, .height)
        
        let grabArea = UIView()
        grabArea.translatesAutoresizingMaskIntoConstraints = false
        grabArea.heightAnchor.constraint(equalToConstant: adjustedValue(36, .height)).isActive = true
        grabArea.backgroundColor = .white
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGrabArea(_:)))
        grabArea.addGestureRecognizer(panGesture)
        
        grabArea.addSubview(grabber)
        NSLayoutConstraint.activate([
            grabber.centerXAnchor.constraint(equalTo: grabArea.centerXAnchor),
            grabber.centerYAnchor.constraint(equalTo: grabArea.centerYAnchor)
        ])
        
        let view = UIView()
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = adjustedValue(20, .width)
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        [
            grabArea,
            selectAttendeeDepartures
        ].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            grabArea.topAnchor.constraint(equalTo: view.topAnchor),
            grabArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grabArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            selectAttendeeDepartures.topAnchor.constraint(equalTo: grabArea.bottomAnchor),
            selectAttendeeDepartures.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(24, .width)),
            selectAttendeeDepartures.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(24, .width))
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        bottomAreaHeightConstraint = view
            .heightAnchor
            .constraint(equalToConstant: bottomAreaMaxHeight)
        
        bottomAreaHeightConstraint.isActive = true
        
        return view
    }()
    
    // MARK: handler
    @objc private func onConfirm() {
        // TODO: vm에 submit 연결
    }
    
    @objc private func onChangedDetailAddress() {
        // TODO: 상세주소 vm과 연결
    }
    
    @objc private func onTapKeyboardDismissBackdrop() {
        detailAddressInput.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.height
        let options = UIView.AnimationOptions(rawValue: curve.uintValue << 16)

        UIView.animate(withDuration: animationDuration.doubleValue, delay: 0, options: options, animations: {
            self.dynamicConstraintAreaByKeypadBottomConstraint.constant = -keyboardHeight
            self.dynamicConstraintAreaByKeypad.layoutMargins = UIEdgeInsets(
                top: adjustedValue(16, .height),
                left: adjustedValue(24, .width),
                bottom: adjustedValue(16, .height),
                right: adjustedValue(24, .width)
            )
            self.keyboardDismissBackdrop.isHidden = false
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else { return }

        let options = UIView.AnimationOptions(rawValue: curve.uintValue << 16)

        UIView.animate(withDuration: animationDuration.doubleValue, delay: 0, options: options, animations: {
            self.dynamicConstraintAreaByKeypadBottomConstraint.constant = 0
            self.dynamicConstraintAreaByKeypad.layoutMargins = UIEdgeInsets(
                top: adjustedValue(8, .width),
                left: adjustedValue(24, .width),
                bottom: 0,
                right: adjustedValue(24, .width)
            )
            self.keyboardDismissBackdrop.isHidden = true
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func updateDetailAddressInput(isFocused: Bool) {
        let animationColor = isFocused
        ? UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1).cgColor
        : UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        
        let borderColorAnimation = CABasicAnimation(keyPath: "borderColor")
        borderColorAnimation.fromValue = detailAddressInput.layer.borderColor
        borderColorAnimation.toValue = animationColor
        borderColorAnimation.duration = 0.1
        detailAddressInput.layer.add(borderColorAnimation, forKey: "borderColor")
        detailAddressInput.layer.borderColor = animationColor
    }
    
    @objc private func handlePanGrabArea(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            originalY = gesture.location(in: self.view).y
        case .changed:
            let translation = gesture.translation(in: self.view)
            let newY = translation.y + originalY
            
            // Calculate new height based on the drag amount
            let newHeight = bottomAreaHeightConstraint.constant - (newY - originalY)
            bottomAreaHeightConstraint.constant = max(min(newHeight, bottomAreaMaxHeight), bottomAreaMinHeight)
            
            gesture.setTranslation(.zero, in: self.view)
            view.layoutIfNeeded()
            
        case .ended, .cancelled:
            // Snap logic: snap to the closest boundary
            let currentHeight = bottomAreaHeightConstraint.constant
            let middleHeight = (bottomAreaMaxHeight + bottomAreaMinHeight) / 2
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                if currentHeight > middleHeight {
                    self.bottomAreaHeightConstraint.constant = self.bottomAreaMaxHeight
                    
                } else {
                    self.bottomAreaHeightConstraint.constant = self.bottomAreaMinHeight
                }
                
                self.view.layoutIfNeeded()
            })
            
        default:
            break
        }
    }
    
    // MARK: initialize
    
    init(vm: CreatePromiseVM, state: DynamicDestinationState) {
        self.createPromiseVM = vm
        self.dynamicDestinationSelectionVM = DynamicDestinationSelectionVM(promise: vm.editingPromise)
        self.state = state
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
    
    private func configure() {
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    private func render() {
        [
            header,
            map,
            keyboardDismissBackdrop,
            bottomArea,
            dynamicConstraintAreaByKeypad
        ].forEach { view.addSubview($0) }
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        dynamicConstraintAreaByKeypadBottomConstraint = dynamicConstraintAreaByKeypad
            .bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            header.heightAnchor.constraint(equalToConstant: adjustedValue(56, .height)),
            header.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            map.topAnchor.constraint(equalTo: header.bottomAnchor),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: bottomArea.topAnchor, constant: adjustedValue(36, .height)),
            
            keyboardDismissBackdrop.topAnchor.constraint(equalTo: header.bottomAnchor),
            keyboardDismissBackdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardDismissBackdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardDismissBackdrop.bottomAnchor.constraint(equalTo: bottomArea.topAnchor, constant: adjustedValue(36, .height)),
            
            bottomArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomArea.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor),
            
            dynamicConstraintAreaByKeypad.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dynamicConstraintAreaByKeypad.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dynamicConstraintAreaByKeypadBottomConstraint
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

extension DynamicDestinationSelectionVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateDetailAddressInput(isFocused: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateDetailAddressInput(isFocused: false)
    }
}

extension DynamicDestinationSelectionVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dynamicDestinationSelectionVM.attendees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AttendeeCellForDeparturesSelection.identifier,
            for: indexPath) as? AttendeeCellForDeparturesSelection else {
            return UICollectionViewCell()
        }
        
        let attendee = dynamicDestinationSelectionVM.attendees[indexPath.row]
        cell.configureCell(with: attendee)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: adjustedValue(52, .width), height: adjustedValue(68, .height))
    }
    
    // 섹션당 상하 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return adjustedValue(8, .height)
    }
    
    // 섹션당 좌우 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return adjustedValue(21, .width)
    }
    
    // 섹션의 여백 설정
    // func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // return UIEdgeInsets(top: adjustedValue(3, .height), left: 0, bottom: 0, right: 0)
    // }
    
    // 셀을 클릭했을 때의 로직
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let attendee = dynamicDestinationSelectionVM.attendees[indexPath.row]
        guard attendee.info.hasStartLocation else { return }
        
        dynamicDestinationSelectionVM.attendees[indexPath.row].isSelected = !attendee.isSelected
        
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: [indexPath])
        }
    }
}
