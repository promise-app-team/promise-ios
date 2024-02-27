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
    
    private var probeeGuidanceTask: Task<Void, Never>? = nil
    private var shouldShowProbeeGuidance = false
    private var isFlyingProbee = false
    
    private var focusRatioInfo: (CGFloat?, CGFloat?, IndexPath?)
    
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
        
        let fontSize: CGFloat = adjustedValue(12, .width)
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
        
        insetLabel.topInset = adjustedValue(7, .height)
        insetLabel.leftInset = adjustedValue(9, .width)
        insetLabel.bottomInset = adjustedValue(7, .height)
        insetLabel.rightInset = adjustedValue(9, .width)
        
        insetLabel.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.03).cgColor
        insetLabel.layer.shadowOpacity = 1
        insetLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
        insetLabel.layer.shadowRadius = 16
        insetLabel.layer.opacity = 0
        
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
            probee.widthAnchor.constraint(equalToConstant: adjustedValue(51, .width)),
            probee.heightAnchor.constraint(equalToConstant: adjustedValue(35, .height)),
            
            probeeGuidance.topAnchor.constraint(equalTo: view.topAnchor, constant: -adjustedValue(4, .height)),
            probeeGuidance.leadingAnchor.constraint(equalTo: probee.trailingAnchor)
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
    
    private var promiseStatusView: PromiseStatusView? = nil
    
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
    
    private func scrollToPreviousFocusedPromise(indexPath: IndexPath) {
        if indexPath == mainVM.currentFocusedPromiseIndexPath {
            
            if let previousFocusedPromiseIndex = mainVM.promises?.firstIndex(where: { $0?.pid == mainVM.currentFocusedPromise?.pid }) {
                
                let previousFocusedPromiseIndexPath = IndexPath(
                    item: previousFocusedPromiseIndex,
                    section: 0
                )
                
                promiseListView.scrollToItem(
                    at: previousFocusedPromiseIndexPath,
                    at: .centeredHorizontally,
                    animated: false
                )
                
            }
        }
    }
    
    public func focusPromiseById(id: String) {
        if let index = mainVM.promises?.firstIndex(where: { $0?.pid == id }) {
            let indexPath = IndexPath(item: index, section: 0)
            
            // MARK: 스크롤(포커스) 할 indexPath가 이미 포커스된 indexPath라면 선행
            scrollToPreviousFocusedPromise(indexPath: indexPath)
            
            promiseListView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            focusedCellChanged(to: indexPath)
        }
    }
    
    private func focusPromiseById() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            
            // MARK: id가 mainVM에 맴버 플레그로 있는 경우
            if let shouldFocusPromiseId = self?.mainVM.shouldFocusPromiseId, !shouldFocusPromiseId.isEmpty {
                
                if let index = self?.mainVM.promises?.firstIndex(where: { $0?.pid == shouldFocusPromiseId }) {
                    let indexPath = IndexPath(item: index, section: 0)
                    
                    // MARK: 스크롤(포커스) 할 indexPath가 이미 포커스된 indexPath라면 선행
                    self?.scrollToPreviousFocusedPromise(indexPath: indexPath)
                    
                    self?.promiseListView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                    self?.focusedCellChanged(to: indexPath)
                }
                
                // 포커스 스크롤 동작 후에 리셋
                self?.mainVM.shouldFocusPromiseId = nil
                
            }
            
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
                self?.focusPromiseById()
                
            }
        }
    }
    
    private func showPromiseStatusView() {
        if let isPresentedPromiseStatusView = promiseStatusView?.isPresented, isPresentedPromiseStatusView {
            return
        }
        
        Task {
            try await Task.sleep(seconds: 0.5)
            
            CommonFloatingContainerVC.minHeight = promiseStatusViewArea.frame.height
            self.promiseStatusView = PromiseStatusView(vc: self, vm: mainVM)
            self.promiseStatusView?.show()
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
        
        if let shouldLazyFocusPromiseId = mainVM.shouldLazyFocusPromiseId, !shouldLazyFocusPromiseId.isEmpty {
            focusPromiseById(id: shouldLazyFocusPromiseId)
            mainVM.shouldLazyFocusPromiseId = nil
        } else {
            focusPromiseById()
        }
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
            headerView.heightAnchor.constraint(equalToConstant: adjustedValue(68, .height)),
        ])
        
        NSLayoutConstraint.activate([
            promiseListEmptyView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            promiseListEmptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            promiseListEmptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            promiseListEmptyView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            promiseListView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: adjustedValue(46, .height)),
            promiseListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            promiseListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            promiseListView.heightAnchor.constraint(equalToConstant: adjustedValue(338, .height))
        ])
        
        NSLayoutConstraint.activate([
            probeeWrap.leadingAnchor.constraint(equalTo: promiseListView.leadingAnchor, constant: adjustedValue(60, .width)),
            probeeWrap.bottomAnchor.constraint(equalTo: promiseListView.topAnchor, constant: adjustedValue(3, .height)),
        ])
        
        NSLayoutConstraint.activate([
            promiseAddButton.topAnchor.constraint(equalTo: promiseListView.bottomAnchor, constant: adjustedValue(16, .height)),
            promiseAddButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: adjustedValue(40, .width)),
            promiseAddButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -adjustedValue(40, .width)),
            promiseAddButton.heightAnchor.constraint(equalToConstant: Button.Height),
        ])
        
        NSLayoutConstraint.activate([
            promiseStatusViewArea.topAnchor.constraint(equalTo: promiseAddButton.bottomAnchor, constant: adjustedValue(38, .height)),
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
            promiseStatusView?.dismiss()
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
        
        guard let promises = mainVM.promises else { return cell }
        
        let promise = promises[indexPath.row]
        cell.configureCell(with: promise, at: indexPath)
        
        // MARK: 최초에 한 번만 실행, cell 재사용시는 focusRatio가 initRaio와 다르기 때문에 실행되지 않고 layoutAttributesForElements 부분이 실행됨.
        if indexPath.row == 0,
           let initFocusRatio = focusRatioInfo.0,
           let focusRatio = focusRatioInfo.1,
           initFocusRatio == focusRatio
        {
            focusedCellChanged(to: indexPath)
            cell.updateBorder(focusRatio: focusRatio)
        } else {
            cell.updateBorder(focusRatio: 0)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
}

extension MainVC: PromiseListLayoutDelegate {
    func updateFocusRatio(_ initFocusRatio: CGFloat, _ focusRatio: CGFloat, _ indexPath: IndexPath) {
        self.focusRatioInfo = (initFocusRatio, focusRatio, indexPath)
        
        // MARK: for probee
        if(initFocusRatio <= focusRatio) {
            // MARK: 포커스 완료시, 프로비가 앉는 경우
            
            UIView.animate(withDuration: 0.3) {
                self.probeeWrap.transform = CGAffineTransform(translationX: 0, y: 0)
            } completion: { _ in
                self.isFlyingProbee = false
                
                self.probeeGuidanceTask?.cancel()
                self.probeeGuidanceTask = Task {
                    do {
                        try await Task.sleep(seconds: 2)
                        
                        if self.shouldShowProbeeGuidance, !self.isFlyingProbee {
                            UIView.animate(withDuration: 0.3) {
                                self.probeeGuidance.layer.opacity = 1
                            }
                        }
                        
                    } catch {
                        // Task가 취소되어 sleep이 중단될 경우 처리
                    }
                }
            }

            
        } else {
            // MARK: 프로비가 날아다니는 경우
            
            UIView.animate(withDuration: 0.2) {
                self.probeeWrap.transform = CGAffineTransform(translationX: 0, y: -(focusRatio * 10))
                self.probeeGuidance.layer.opacity = 0
                self.isFlyingProbee = true
                self.probeeGuidanceTask?.cancel()
            }
            
        }
        
    }
    
    func focusedCellChanged(to indexPath: IndexPath) {
        guard let promises = mainVM.promises else { return }
        let promise = promises[indexPath.row]
        guard let promise else { return }
        
        mainVM.currentFocusedPromise = promise
        mainVM.currentFocusedPromiseIndexPath = indexPath
        
        let isEmptyAttendees = promise.attendees.isEmpty
        let isOwner = String(Int(promise.host.id)) == UserService.shared.getUser()?.userId
        
        // MARK: for promise status (is not called init mount)
        self.promiseStatusView?.updatePromiseStatus(with: promise)
        
        // MARK: for probee
        self.shouldShowProbeeGuidance = isOwner && isEmptyAttendees
        
    }
}



