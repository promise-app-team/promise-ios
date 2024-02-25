//
//  PromiseListCell.swift
//  Promise
//
//  Created by dylan on 2023/08/04.
//

import Foundation
import UIKit
import SkeletonView


class AttendeeCellForCard: UICollectionViewCell {
    static let identifier = "AttendeeCellForCard"
    
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
    
    func configureAttendeeCellForCard(with attendee: Components.Schemas.Attendee) {
        guard let profileUrl = attendee.profileUrl, let imageUrl = URL(string: profileUrl) else {
            // TODO: 이미지 url이 없을 경우 디폴트 이미지
            return
        }
        
        attendeeProfileImage.load(url: imageUrl)
    }
}

class PromiseListCell: UICollectionViewCell {
    private var attendees: [Components.Schemas.Attendee] = []
    private var isOwner = false {
        didSet {
            if(isOwner) {
                self.shareButton.isHidden = false
            } else {
                self.shareButton.isHidden = true
                self.shareUrl = nil
            }
        }
    }
    private var shareUrl: URL? = nil
    
    private lazy var shareButton = {
        let imageView = UIImageView(image: Asset.share.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: adjustedValue(20, .width)),
            imageView.heightAnchor.constraint(equalToConstant: adjustedValue(20, .height))
        ])
        
        let view = UIView()
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: adjustedValue(30, .width)),
            view.heightAnchor.constraint(equalToConstant: adjustedValue(20, .height))
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapShareButton))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        // view.layer.zPosition = 1
        
        view.isHidden = true
        
        return view
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
        insetLabel.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(10, .width))
        insetLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        insetLabel.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        
        insetLabel.layer.masksToBounds = true
        insetLabel.layer.cornerRadius = adjustedValue(9, .width)
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
    
    private let promisedAt = {
        let label = UILabel()
        
        label.textColor =  UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        
        let font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(14, .width))
        label.font = font
        
        label.isSkeletonable = true
        label.linesCornerRadius = Int(adjustedValue(4, .width))
        label.lastLineFillPercent = 80
        
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
        
        label.isSkeletonable = true
        label.linesCornerRadius = Int(adjustedValue(4, .width))
        label.lastLineFillPercent = 90
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let lineHeight = font?.lineHeight
        label.heightAnchor.constraint(equalToConstant: lineHeight ?? 0).isActive = true
        
        return label
    }()
    
    private let placeLabel = {
        let label = UILabel()
        label.text = L10n.Common.place
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(13, .width))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        [label, divider].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            divider.topAnchor.constraint(equalTo: view.topAnchor, constant: 2.8),
            divider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3),
            divider.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4),
            divider.widthAnchor.constraint(equalToConstant: 2),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let hostLabel = {
        let label = UILabel()
        label.text = L10n.Common.host
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: adjustedValue(13, .width))
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        divider.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        [label, divider].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            divider.topAnchor.constraint(equalTo: view.topAnchor, constant: 3.2),
            divider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2),
            divider.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 4),
            divider.widthAnchor.constraint(equalToConstant: 2.5),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var attendeesLabel = {
        let label = UILabel()
        label.text = L10n.Common.attendees
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
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
    
    private let place = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(13, .width))
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let host = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: adjustedValue(13, .width))
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
    
    private lazy var attendeesView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AttendeeCellForCard.self, forCellWithReuseIdentifier: AttendeeCellForCard.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    override func prepareForReuse() {
    //        super.prepareForReuse()
    //        // attendees 데이터를 초기화하거나 관련 뷰를 초기 상태로 설정
    //        attendees = []
    //        attendeesView.reloadData() // 내부 UICollectionView
    //    }
    
    private func configureCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = adjustedValue(20, .width)
        contentView.isSkeletonable = true
        
        [
            shareButton,
            themesScrollWrap,
            promisedAt,
            title,
            placeLabel,
            place,
            hostLabel,
            host,
            attendeesLabel,
            attendeesView
        ].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            shareButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adjustedValue(22, .height)),
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -adjustedValue(20, .width)),
            
            themesScrollWrap.topAnchor.constraint(equalTo: contentView.topAnchor, constant: adjustedValue(22, .height)),
            themesScrollWrap.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: adjustedValue(22, .width)),
            themesScrollWrap.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor),
            themesScrollWrap.heightAnchor.constraint(equalToConstant: adjustedValue(20, .height)),
            
            promisedAt.topAnchor.constraint(equalTo: themesScrollWrap.bottomAnchor, constant: adjustedValue(6, .height)),
            promisedAt.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: adjustedValue(22, .width)),
            promisedAt.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -adjustedValue(22, .width)),
            
            title.topAnchor.constraint(equalTo: promisedAt.bottomAnchor, constant: adjustedValue(1, .height)),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: adjustedValue(22, .width)),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -adjustedValue(22, .width)),
            
            placeLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: adjustedValue(8, .height)),
            placeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: adjustedValue(22, .width)),
            placeLabel.widthAnchor.constraint(equalToConstant: adjustedValue(29, .width)),
            
            place.topAnchor.constraint(equalTo: placeLabel.topAnchor),
            place.leadingAnchor.constraint(equalTo: placeLabel.trailingAnchor, constant: adjustedValue(4, .width)),
            place.bottomAnchor.constraint(equalTo: placeLabel.bottomAnchor),
            
            hostLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: adjustedValue(8, .height)),
            hostLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: adjustedValue(22, .width)),
            hostLabel.widthAnchor.constraint(equalToConstant: adjustedValue(40, .width)),
            
            host.topAnchor.constraint(equalTo: hostLabel.topAnchor),
            host.leadingAnchor.constraint(equalTo: hostLabel.trailingAnchor, constant: adjustedValue(4, .width)),
            host.bottomAnchor.constraint(equalTo: hostLabel.bottomAnchor),
            
            attendeesLabel.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: adjustedValue(8, .height)),
            attendeesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: adjustedValue(22, .width)),
            
            attendeesView.topAnchor.constraint(equalTo: attendeesLabel.bottomAnchor, constant: adjustedValue(8, .height)),
            attendeesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: adjustedValue(22, .width)),
            attendeesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -adjustedValue(22, .width)),
            attendeesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -adjustedValue(22, .height))
        ])
    }
    
    func configureCell(with promise: Components.Schemas.OutputPromiseListItem?, at indexPath: IndexPath) {
        guard let promise else {
            contentView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
            return
        }
        
        contentView.hideSkeleton(transition: .crossDissolve(0.25))
        
        assignThemesToTaggedThemes(with: promise.themes)
        
        // 공유 링크 세팅
        let sharePromiseId = promise.pid
        if(!sharePromiseId.isEmpty) {
            self.shareUrl = URL(string: "\(Config.universalLinkDomain)/share/\(sharePromiseId)")
        }
        
        // TimeInterval을 Date 객체로 변환
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd a hh시 mm분"
        
        promisedAt.text = dateFormatter.string(from: promise.promisedAt)
        
        title.text = promise.title
        
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
    
    func updateBorder(focusRatio: CGFloat) {
        
        let borderWidth: CGFloat = 1
        let focusedColor: UIColor = UIColor(red: 0.02, green: 0.75, blue: 0.62, alpha: 1)
        let unfocusedColor: UIColor = .clear
        
        contentView.layer.borderWidth = borderWidth * focusRatio
        contentView.layer.borderColor = UIColor.transition(from: unfocusedColor, to: focusedColor, with: focusRatio).cgColor
    }
}

extension PromiseListCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attendees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendeeCellForCard.identifier, for: indexPath) as? AttendeeCellForCard else {
            return UICollectionViewCell()
        }
        
        let attendee = attendees[indexPath.row]
        cell.configureAttendeeCellForCard(with: attendee)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: adjustedValue(34, .width), height: adjustedValue(34, .height))
    }
    
    // 섹션당 상하 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return adjustedValue(8, .height)
    }
    
    // 섹션당 좌우 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return adjustedValue(8, .width)
    }
    
    // 섹션의 여백 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: adjustedValue(3, .height), left: 0, bottom: 0, right: 0)
    }
    
    // 셀을 클릭했을 때의 로직
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
