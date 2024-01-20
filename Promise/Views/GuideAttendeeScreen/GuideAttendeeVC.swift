//
//  GuideAttendeeVC.swift
//  Promise
//
//  Created by kwh on 1/17/24.
//

import Foundation
import UIKit

class GuideAttendeeVC: UIViewController {
    let promiseId: String
    
    private lazy var directAttendPromiseButton = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 16)
        label.text = L10n.GuideAttendee.directAttend
        label.textColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 1)
        
        let imageView = UIImageView(image: Asset.arrowRight.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        let view = UIView()
        
        [label, imageView].forEach{ view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 1),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4),
            imageView.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 2),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapDirectAttendPromiseButton))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var carouselData = {
        var data = [CarouselView.CarouselData]()
        data.append(
            .init(
                image: Asset.guideAttendeeImage1.image,
                title: L10n.GuideAttendee.title1,
                bulletPoints: [L10n.GuideAttendee.Title1.bulletPoint1, L10n.GuideAttendee.Title1.bulletPoint2]
            )
        )
        data.append(
            .init(
                image: Asset.guideAttendeeImage2.image,
                title: L10n.GuideAttendee.title2,
                bulletPoints: [L10n.GuideAttendee.Title2.bulletPoint1, L10n.GuideAttendee.Title2.bulletPoint2]
            )
        )
        data.append(
            .init(
                image: Asset.guideAttendeeImage3.image,
                title: L10n.GuideAttendee.title3,
                bulletPoints: [L10n.GuideAttendee.Title3.bulletPoint1, L10n.GuideAttendee.Title3.bulletPoint2, L10n.GuideAttendee.Title3.bulletPoint3]
            )
        )
        return data
    }()
    
    private lazy var carouselView = {
        let carousel = CarouselView(with: carouselData, delegate: self)
        carousel.translatesAutoresizingMaskIntoConstraints = false
        return carousel
    }()
    
    // MARK: handler
    
    @objc private func onTapDirectAttendPromiseButton() {
        let mainVC = MainVC(invitedPromiseId: promiseId)
        navigationController?.pushViewController(mainVC, animated: true)
    }
    
    // MARK: initialize
    
    init(promiseId: String) {
        self.promiseId = promiseId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainVC()
        render()
    }
    
    private func configureMainVC() {
        view.backgroundColor = .white
    }
    
    private func render() {
        [
            directAttendPromiseButton,
            carouselView
        ].forEach { view.addSubview($0) }
        setupAutoLayout()
    }
    
    private func setupAutoLayout() {
        let safeLayoutGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            directAttendPromiseButton.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor, constant: 16),
            directAttendPromiseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            carouselView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor, constant: 88),
            carouselView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor),
            carouselView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension GuideAttendeeVC: CarouselViewDelegate {
    func currentPageDidChange(to page: Int) {
        let isLastPage = page == carouselData.count - 1
        
        UIView.animate(withDuration: 0.3) {
            self.directAttendPromiseButton.alpha = isLastPage ? 0 : 1
        }
    }
    
    func onTapAttendPromiseButton() {
        // MARK: 캐러셀의 마지막 가이드에 나타나는 버튼을 클릭했을때 로컬스토리지에 가이드를 봤다는 플래그 저장
        UserDefaults.standard.set(true, forKey: UserDefaultConstants.Attendee.HAS_SEEN_GUIDE_ATTENDEE)
        
        let mainVC = MainVC(invitedPromiseId: promiseId)
        navigationController?.pushViewController(mainVC, animated: true)
    }
}
