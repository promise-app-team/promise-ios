//
//  Popover.swift
//  Promise
//
//  Created by dylan on 2023/09/03.
//

import Foundation
import UIKit

struct PopoverTarget {
    let x: CGFloat?
    let y: CGFloat
    let target: UIView
}

@objc protocol PopoverViewDelegate {
    @objc optional func onWillShow()
    @objc optional func onWillHide()
    @objc optional func onDidShow()
    @objc optional func onDidHide()
}

class PopoverView: UIView {
    static var zPosition = 1.0
    
    var isEnableDimmingView = false
    var paddingHorizontal = 0.0
    var from: PopoverTarget?
    var vc: UIViewController
    var contentView: UIView
    
    weak var delegate: PopoverViewDelegate?
    
    private lazy var dimmingView = {
        let view = UIView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        
        if(isEnableDimmingView) {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let target = from?.target {
            frame.size = CGSize(
                width: target.frame.size.width,
                height: contentView.frame.size.height
            )
        } else {
            frame.size = self.frame.size
        }
    }
    
    init(from: PopoverTarget, in viewController: UIViewController, contentView: UIView, isEnableDimmingView: Bool, paddingHorizontal: CGFloat) {
        self.from = from
        self.vc = viewController
        self.contentView = contentView
        self.isEnableDimmingView = isEnableDimmingView
        self.paddingHorizontal = paddingHorizontal
        super.init(frame: .zero)
        configurePopoverView()
 
        // PopoverView를 부모 뷰 컨트롤러의 뷰에 추가
        [dimmingView, self].forEach { viewController.view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            dimmingView.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
        ])
        
        updatePopoverPosition(in: viewController)
    }
    
    func updatePopoverPosition(in viewController: UIViewController) {
        guard let from = self.from else { return }
        
        // 위치 설정
        let targetBounds = from.target.bounds
        let targetCenterX = from.target.center.x
        let popoverWidth = self.frame.width
        
        var newOriginX = targetCenterX - popoverWidth / 2
        if let x = from.x {
            newOriginX = targetBounds.minX + x
        }
        
        let startingFrame = from.target.convert(
            CGRect(
                x: newOriginX,
                y: targetBounds.maxY + from.y,
                width: targetBounds.width,
                height: targetBounds.height
            ),
            to: viewController.view
        )
        
        frame = startingFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configurePopoverView() {
        guard let from else { return }
        
        self.frame.size = CGSize(
            width: from.target.frame.size.width,
            height: contentView.frame.size.height
        )
        
        addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingHorizontal),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddingHorizontal)
        ])
        
        backgroundColor = .clear
    }
    
    func show() {
        updatePopoverPosition(in: vc)

        delegate?.onWillShow?()
        // 애니메이션 시작 전 초기 상태 설정
        self.dimmingView.alpha = 0.0
        self.alpha = 0.0
        
        // 기존 frame 저장
        let originalFrame = self.frame
        
        // anchorPoint를 변경하기 전 현재 center 값을 저장
        let oldCenter = self.center
        
        // 왼쪽 상단 모서리를 anchor point로 설정
        self.layer.anchorPoint = CGPoint(x: 0, y: 0)
        
        // anchorPoint를 변경한 뒤 center 값을 원래대로 복원
        self.center = oldCenter
        
        // frame을 원래대로 복원
        self.frame = originalFrame
        
        // 스케일 설정
        self.transform = CGAffineTransform(scaleX: 1, y: 0)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmingView.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.9,
                       options: [],
                       animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }) { _ in
            self.delegate?.onDidShow?()
        }
    }
    
    @objc func dismiss() {
        delegate?.onWillHide?()
        
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 0.000001)
            self.alpha = 0.0
            self.dimmingView.alpha = 0.0
        }) { _ in
            self.delegate?.onDidHide?()
        }
    }
}
