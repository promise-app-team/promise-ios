//
//  ViewController.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import UIKit

final class MainVC: UIViewController {
    // 메인화면에 진입할때 MainVC(invitedPromiseId:)로 초기화 하면 참여 팝업을 띄워야함.
    var invitedPromise: Components.Schemas.OutputPromiseListItem?
    
    lazy var mainVM = MainVM(currentVC: self)
    
    private lazy var headerView = NavigationView(mainVM: mainVM)
    
    private lazy var promiseListEmptyView = {
        let emptyView = PromiseListEmptyView(mainVM: mainVM)
        emptyView.isHidden = true
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        return emptyView
    }()
    
    private lazy var promiseListView = {
        let layout = PromiseListLayout()
        layout.delegate = self
        
        let promiseListView = PromiseListView(dataSource: self, delegate: self, layout: layout)
        promiseListView.isHidden = true
        
        promiseListView.translatesAutoresizingMaskIntoConstraints = false
        return promiseListView
    }()
    
    private lazy var promiseAddButton = {
        let button = Button()
        button.initialize(title: L10n.Main.addNewPromise, style: .primary, iconTitle: Asset.circleOutlinePlusWhite.name)
        
        button.addTarget(self, action: #selector(onTapPromiseAddButton), for: .touchUpInside)
        
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let probee = {
        let imageView = UIImageView(image: Asset.probeeAll.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let probeeGuidance = {
        let paragraphStyle = NSMutableParagraphStyle()
        
        let fontSize: CGFloat = 12.0
        let text = L10n.Main.Probee.Guidance.share
        let font = UIFont(font: FontFamily.Pretendard.regular, size: fontSize)!
        
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes([
            .paragraphStyle: paragraphStyle,
            .font: font,
            .foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1),
        ], range: NSMakeRange(0, attributedString.length))
        
        let textHighlight = L10n.Main.Probee.Guidance.Share.highlight
        let highlightFont = UIFont(font: FontFamily.Pretendard.bold, size: fontSize)!
        
        attributedString.addAttribute(
            .font,
            value: highlightFont,
            range: (text as NSString).range(of: textHighlight)
        )
        
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1),
            range: (text as NSString).range(of: textHighlight)
        )
        
        let insetLabel = InsetLabel()
        
        insetLabel.attributedText = attributedString
        insetLabel.backgroundColor = .white
        
        insetLabel.topInset = 7
        insetLabel.leftInset = 9
        insetLabel.bottomInset = 7
        insetLabel.rightInset = 9
        
        insetLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03).cgColor
        insetLabel.layer.shadowOpacity = 1
        insetLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        insetLabel.layer.shadowRadius = 16
        
        insetLabel.translatesAutoresizingMaskIntoConstraints = false
        return insetLabel
    }()
    
    private lazy var probeeWrap = {
        let view = UIView()
        
        [probee, probeeGuidance].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            probee.topAnchor.constraint(equalTo: view.topAnchor),
            probee.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            probee.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            probee.widthAnchor.constraint(equalToConstant: 51),
            probee.heightAnchor.constraint(equalToConstant: 35),
            
            probeeGuidance.topAnchor.constraint(equalTo: view.topAnchor, constant: -4),
            probeeGuidance.leadingAnchor.constraint(equalTo: probee.trailingAnchor, constant: 4)
        ])
        
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var promiseStatusViewArea = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var promiseStatusView = {
        let commonFloatingContainerVC = PromiseStatusView(parentVC: self, vm: mainVM)
        CommonFloatingContainerVC.minHeight = promiseStatusViewArea.frame.height
        return commonFloatingContainerVC
    }()
    
    // MARK: handler
    
    public func showInvitationPopUp(promise: Components.Schemas.OutputPromiseListItem? = nil) {
        if let promise {
            let popup = InvitationPopUp(invitedPromise: promise, currentVC: self)
            popup.delegate = mainVM
            popup.showInvitationPopUp()
            return
        }
        
        if let invitedPromise = self.invitedPromise {
            let popup = InvitationPopUp(invitedPromise: invitedPromise, currentVC: self)
            popup.delegate = mainVM
            popup.showInvitationPopUp()
            
            // 참여 팝업 이후 리셋
            self.invitedPromise = nil
        }
    }
    
    
    public func focusPromiseById(id: String? = nil) {
        
        if let id {
            if let index = mainVM.promises?.firstIndex(where: { $0?.pid == id }) {
                promiseListView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
            
            return
        }
        
        
        if let shouldFocusPromiseId = mainVM.shouldFocusPromiseId, !shouldFocusPromiseId.isEmpty {
            
            if let index = mainVM.promises?.firstIndex(where: { $0?.pid == shouldFocusPromiseId }) {
                promiseListView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
            
            // 포커스 스크롤 동작 후에 리셋
            mainVM.shouldFocusPromiseId = nil
        }
        
    }
    
    private func assignPromisesDidChange() {
        mainVM.promisesDidChange = { [weak self] (promiseList) in
            DispatchQueue.main.async {
                guard let promiseList else { return }
                
                // MARK: 네트워크 요청중(로딩)
                if promiseList.count == 1, let first = promiseList.first, first == nil {
                    return
                }
                
                self?.renderAfterGettingPromises(isEmptyPromises: promiseList.isEmpty)
                self?.promiseListView.reloadData()
            }
        }
    }
    
    private func showPromiseStatusView() {
        Task {
            try await Task.sleep(seconds: 0.5)
            promiseStatusView.show()
        }
    }
    
    @objc private func onTapPromiseAddButton() {
        mainVM.navigateCreatePromiseScreen()
    }
    
    // MARK: initialize
    
    init(
        invitedPromise: Components.Schemas.OutputPromiseListItem? = nil,
        shouldFocusPromiseId: String? = nil
    ) {
        self.invitedPromise = invitedPromise
        super.init(nibName: nil, bundle: nil)
        
        mainVM.shouldFocusPromiseId = shouldFocusPromiseId
        
        Task {
            assignPromisesDidChange()
            await mainVM.getPromiseList()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainVC()
        render()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showInvitationPopUp()
        focusPromiseById()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // probeeGuidance이 화면에 추가된 후에 그림자 경로를 업데이트
        probeeGuidance.layer.shadowPath = UIBezierPath(
            roundedRect: probeeGuidance.bounds,
            cornerRadius: probeeGuidance.layer.cornerRadius
        ).cgPath
        
        probeeGuidance.applyCornerRadii(
            topLeft: 8,
            topRight: 8,
            bottomLeft: 4,
            bottomRight: 8,
            borderColor: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1),
            borderWidth: 1
        )
        
    }
    
    private func configureMainVC() {
        view.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
    }
    
    private func render() {
        [
            headerView,
            promiseListEmptyView,
            promiseListView,
            probeeWrap,
            promiseAddButton,
            promiseStatusViewArea,
        ].forEach { view.addSubview($0) }
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 8 + 8 + 36),
        ])
        
        NSLayoutConstraint.activate([
            promiseListEmptyView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            promiseListEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            promiseListEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            promiseListEmptyView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            promiseListView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            promiseListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            promiseListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            promiseListView.heightAnchor.constraint(equalToConstant: 320)
        ])
        
        NSLayoutConstraint.activate([
            probeeWrap.leadingAnchor.constraint(equalTo: promiseListView.leadingAnchor, constant: 60),
            probeeWrap.bottomAnchor.constraint(equalTo: promiseListView.topAnchor, constant: 3),
        ])
        
        NSLayoutConstraint.activate([
            promiseAddButton.topAnchor.constraint(equalTo: promiseListView.bottomAnchor, constant: 16),
            promiseAddButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            promiseAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            promiseAddButton.heightAnchor.constraint(equalToConstant: Button.Height),
        ])
        
        NSLayoutConstraint.activate([
            promiseStatusViewArea.topAnchor.constraint(equalTo: promiseAddButton.bottomAnchor, constant: 24),
            promiseStatusViewArea.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            promiseStatusViewArea.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            promiseStatusViewArea.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func renderAfterGettingPromises(isEmptyPromises: Bool) {
        if isEmptyPromises {
            promiseListView.isHidden = true
            probeeWrap.isHidden = true
            promiseStatusViewArea.isHidden = true
            promiseAddButton.isHidden = true
            headerView.disabledSortPromiseList = true
            
            promiseListEmptyView.isHidden = false
            
            promiseStatusView.dismiss()
            return
        }
        
        
        promiseListView.isHidden = false
        probeeWrap.isHidden = false
        promiseStatusViewArea.isHidden = false
        promiseAddButton.isHidden = false
        headerView.disabledSortPromiseList = false
        
        promiseListEmptyView.isHidden = true
        
        showPromiseStatusView()
    }
}

extension MainVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainVM.promises?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PromiseListCell
        let promise = mainVM.promises?[indexPath.row]
        cell.configureCell(with: promise)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let promiseCell = cell as? PromiseListCell {
            // 첫 번째로 표시되는 셀에 테두리 적용
            if indexPath.row == 0 {
                promiseCell.updateBorder(focusRatio: 1)
            }
        }
    }
    
}

extension MainVC: PromiseListLayoutDelegate {
    func updateFocusRatio(_ initRatio: CGFloat, _ ratio: CGFloat) {
        if(initRatio <= ratio) {
            UIView.animate(withDuration: 0.3) {
                self.probeeWrap.transform = CGAffineTransform(translationX: 0, y: 0)
            }
            
            UIView.animate(withDuration: 0.3, delay: 2) {
                self.probeeGuidance.layer.opacity = 1
            }
            
        } else {
            UIView.animate(withDuration: 0.2) {
                self.probeeWrap.transform = CGAffineTransform(translationX: 0, y: -(ratio * 10))
                self.probeeGuidance.layer.opacity = 0
            }
        }
    }
    
    func focusedCellChanged(to indexPath: IndexPath) {
        let promise = mainVM.promises?[indexPath.row]
        guard let promise else {
            probeeGuidance.isHidden = true
            return
        }
        
        let isEmptyAttendees = promise.attendees.isEmpty
        let isOwner = promise.host.username == UserService.shared.getUser()?.nickname
        let shouldShowProbeeGuidance = isOwner && isEmptyAttendees
        
        probeeGuidance.isHidden = !shouldShowProbeeGuidance
    }
}



