//
//  CarouselView.swift
//  Promise
//
//  Created by kwh on 1/18/24.
//

import Foundation
import UIKit

protocol CarouselCellDelegate: AnyObject {
    func onTapAttendPromiseButton()
}

class CarouselCell: UICollectionViewCell {
    weak var delegate: CarouselCellDelegate?
    
    // MARK: - SubViews
    
    private lazy var imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var title = {
        let label = UILabel()
        label.font = UIFont(font: FontFamily.Pretendard.bold, size: 24)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var bulletPoints = UIStackView()
    
    private lazy var attendPromiseButton = {
        let button = Button()
        button.initialize(title: L10n.GuideAttendee.attend, style: .primary)
        
        button.addTarget(self, action: #selector(onTapAttendPromiseButton), for: .touchUpInside)
        button.alpha = 0
        button.isHidden = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    static let cellId = "CarouselCell"
    
    // MARK: handler
    @objc func onTapAttendPromiseButton() {
        delegate?.onTapAttendPromiseButton()
    }
    
    func showAttendButton() {
        attendPromiseButton.isHidden = false
        attendPromiseButton.alpha = 1
    }
    
    func hideAttendButton() {
        attendPromiseButton.isHidden = true
        attendPromiseButton.alpha = 0
    }
    
    // MARK: - Initializer
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configure(image: UIImage?, title: String, bulletPoints: [String]) {
        // MARK: image 세팅
        self.imageView.image = image
        
        // MARK: title 세팅
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        
        let attributedString = NSAttributedString(string: title, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        self.title.attributedText = attributedString
        
        // MARK: bullet point 세팅
        let bulletPointLabels = bulletPoints.map { str in
            let bulletPointLabel = UILabel()
            bulletPointLabel.text = str
            bulletPointLabel.font = UIFont(font: FontFamily.Pretendard.regular, size: 16)
            bulletPointLabel.textColor = .black
            bulletPointLabel.translatesAutoresizingMaskIntoConstraints = false
            
            return bulletPointLabel
        }
        
        let bulletPointsStackView = UIStackView(arrangedSubviews: bulletPointLabels)
        bulletPointsStackView.spacing = 8
        bulletPointsStackView.axis = .vertical
        bulletPointsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.bulletPoints = bulletPointsStackView
        
        render()
    }
    
    func render() {
        [
            imageView,
            title,
            bulletPoints,
            attendPromiseButton
        ].forEach { addSubview($0) }
        setupAutoLayout()
    }
    
    func setupAutoLayout() {
        let screenHeight = UIScreen.main.bounds.height
        let imageViewHeightRatio = CGFloat(394) / CGFloat(852)
        
        let imageViewHeight = screenHeight * imageViewHeightRatio
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageViewHeight),
            
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 48),
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            title.rightAnchor.constraint(equalTo: rightAnchor, constant: -24),
            
            bulletPoints.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 24),
            bulletPoints.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            bulletPoints.rightAnchor.constraint(equalTo: rightAnchor, constant: -24),
            
            attendPromiseButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            attendPromiseButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            attendPromiseButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            attendPromiseButton.heightAnchor.constraint(equalToConstant: Button.Height),
        ])
    }
}
