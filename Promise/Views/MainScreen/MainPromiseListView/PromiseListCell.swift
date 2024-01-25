//
//  PromiseListCell.swift
//  Promise
//
//  Created by dylan on 2023/08/04.
//

import Foundation
import UIKit
import SkeletonView


class AttendeeCell: UICollectionViewCell {
    static let identifier = "AttendeeCell"
    
    private let attendeeProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // TODO: 임시
    private let attendeeTitle = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 12)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // TODO: 임시
    private lazy var attendeeTitleWrap = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        view.layer.cornerRadius = 18
        
        view.addSubview(attendeeTitle)
        NSLayoutConstraint.activate([
            attendeeTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            attendeeTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAttendeeCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureAttendeeCell() {
        contentView.addSubview(attendeeTitleWrap)
        
        NSLayoutConstraint.activate([
            attendeeTitleWrap.topAnchor.constraint(equalTo: contentView.topAnchor),
            attendeeTitleWrap.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            attendeeTitleWrap.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            attendeeTitleWrap.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func configureAttendeeCell(with attendee: Components.Schemas.Attendee) {
        // TODO:
        // attendeeProfileImage.load(url: <#T##URL#>)
        
        // 임시:
        attendeeTitle.text = attendee.username
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
            imageView.widthAnchor.constraint(equalToConstant: 22),
            imageView.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapShareButton))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        imageView.isHidden = true
        
        return imageView
    }()
    
    private let createTaggedTheme = { (themeTitle: String) in
        let insetLabel = InsetLabel()
        insetLabel.topInset = 3
        insetLabel.bottomInset = 3
        insetLabel.leftInset = 7
        insetLabel.rightInset = 7
        
        insetLabel.text = themeTitle
        insetLabel.font = UIFont(font: FontFamily.Pretendard.light, size: 11)
        insetLabel.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        insetLabel.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1)
        
        insetLabel.layer.masksToBounds = true
        insetLabel.layer.cornerRadius = 10
        insetLabel.sizeToFit()
        
        insetLabel.translatesAutoresizingMaskIntoConstraints = false
        return insetLabel
    }
    
    private let taggedThemes = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
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
        
        let font = UIFont(font: FontFamily.Pretendard.regular, size: 14)
        label.font = font
        
        label.isSkeletonable = true
        label.linesCornerRadius = 4
        label.lastLineFillPercent = 80
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let lineHeight = font?.lineHeight
        label.heightAnchor.constraint(equalToConstant: lineHeight ?? 0).isActive = true
        
        return label
    }()
    
    private let title = {
        let label = UILabel()
        
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        let font = UIFont(font: FontFamily.Pretendard.bold, size: 18)
        label.font = font
        
        label.isSkeletonable = true
        label.linesCornerRadius = 4
        label.lastLineFillPercent = 90
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let lineHeight = font?.lineHeight
        label.heightAnchor.constraint(equalToConstant: lineHeight ?? 0).isActive = true
        
        return label
    }()
    
    private let placeLabel = {
        let label = UILabel()
        label.text = L10n.Common.place
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 10)
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
            
            divider.topAnchor.constraint(equalTo: view.topAnchor, constant: 2),
            divider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1.2),
            divider.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 3.2),
            divider.widthAnchor.constraint(equalToConstant: 1.8),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let hostLabel = {
        let label = UILabel()
        label.text = L10n.Common.host
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 10)
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
            
            divider.topAnchor.constraint(equalTo: view.topAnchor, constant: 2),
            divider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1),
            divider.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 3),
            divider.widthAnchor.constraint(equalToConstant: 2),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var attendeesLabel = {
        let label = UILabel()
        label.text = L10n.Common.attendees
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let view = UIView()
        [label, attendeesCount].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            attendeesCount.topAnchor.constraint(equalTo: view.topAnchor),
            attendeesCount.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            attendeesCount.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 2),
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let place = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 10)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let host = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.regular, size: 10)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let attendeesCount = {
        let label = UILabel()
        label.text = "(0)"
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 10)
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
        collectionView.register(AttendeeCell.self, forCellWithReuseIdentifier: AttendeeCell.identifier)
        
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
    
    private func configureCell() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
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
            shareButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            
            themesScrollWrap.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            themesScrollWrap.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            themesScrollWrap.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -10),
            themesScrollWrap.heightAnchor.constraint(equalToConstant: 22),
            
            promisedAt.topAnchor.constraint(equalTo: themesScrollWrap.bottomAnchor, constant: 6),
            promisedAt.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            promisedAt.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            title.topAnchor.constraint(equalTo: promisedAt.bottomAnchor, constant: 4),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            placeLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 7),
            placeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            placeLabel.widthAnchor.constraint(equalToConstant: 26),
            
            place.topAnchor.constraint(equalTo: placeLabel.topAnchor),
            place.leadingAnchor.constraint(equalTo: placeLabel.trailingAnchor),
            place.bottomAnchor.constraint(equalTo: placeLabel.bottomAnchor),
            
            hostLabel.topAnchor.constraint(equalTo: placeLabel.bottomAnchor, constant: 7),
            hostLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            hostLabel.widthAnchor.constraint(equalToConstant: 35),
            
            host.topAnchor.constraint(equalTo: hostLabel.topAnchor),
            host.leadingAnchor.constraint(equalTo: hostLabel.trailingAnchor),
            host.bottomAnchor.constraint(equalTo: hostLabel.bottomAnchor),
            
            attendeesLabel.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 7),
            attendeesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            attendeesView.topAnchor.constraint(equalTo: attendeesLabel.bottomAnchor, constant: 10),
            attendeesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            attendeesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            attendeesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    func configureCell(with promise: Components.Schemas.OutputPromiseListItem?) {
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
        let date = Date(timeIntervalSince1970: Double(promise.promisedAt))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy.MM.dd a hh시 mm분"
        promisedAt.text = dateFormatter.string(from: date)
        
        title.text = promise.title
        
        if let destination = promise.destination {
            place.text = destination.value1.address
        }
        
        host.text = promise.host.username
        attendeesCount.text = "(\(promise.attendees.count))"
        
        // attendees = promise.attendees
        // TODO: 임시
        attendees = [
            Components.Schemas.Attendee(id: 1, username: "프"),
            Components.Schemas.Attendee(id: 2, username: "로"),
            Components.Schemas.Attendee(id: 3, username: "미"),
            Components.Schemas.Attendee(id: 4, username: "스"),
            Components.Schemas.Attendee(id: 5, username: "참"),
            Components.Schemas.Attendee(id: 6, username: "여"),
            Components.Schemas.Attendee(id: 7, username: "자"),
            Components.Schemas.Attendee(id: 8, username: "들"),
            Components.Schemas.Attendee(id: 9, username: "임"),
            Components.Schemas.Attendee(id: 10, username: "시")
        ]
        
        //TODO: username은 조금 애매하다... userId로 비교하는게 좋을듯
        // 서버에 host의 userId도 요청후에 UserService의 userId와 비교
        isOwner = promise.host.username == UserService.shared.getUser()?.nickname
        if(isOwner && promise.attendees.count == 0) {
            //TODO: 프로비 가이드 툴팁 show!!
        }
        
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AttendeeCell.identifier, for: indexPath) as? AttendeeCell else {
            return UICollectionViewCell()
        }
        
        let attendee = attendees[indexPath.row]
        cell.configureAttendeeCell(with: attendee)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 36, height: 36)
    }
    
    // 섹션당 상하 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    // 섹션당 좌우 간격 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // 섹션의 여백 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 셀을 클릭했을 때의 로직
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
