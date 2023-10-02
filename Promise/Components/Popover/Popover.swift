//
//  Popover.swift
//  Promise
//
//  Created by dylan on 2023/09/03.
//

import Foundation
import UIKit

struct PopoverTarget {
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat = 0.0
    let height: CGFloat = 0.0
    let target: UIView
}

class PopoverView: UIView {
    var contentView: UIView
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frame.size = contentView.frame.size
    }
    
    init(from: PopoverTarget, in viewController: UIViewController, contentView: UIView) {
        self.contentView = contentView
        super.init(frame: .zero)
        
        // contentView 설정
        addSubview(self.contentView)
        
        // PopoverView를 부모 뷰 컨트롤러의 뷰에 추가
        viewController.view.addSubview(self)
        
        // 위치 설정
        let targetBounds = from.target.bounds
        let startingFrame = from.target.convert(
            CGRect(
                x: targetBounds.minX + from.x,
                y: targetBounds.maxY + from.y,
                width: targetBounds.width + from.width,
                height: targetBounds.height + from.height
            ),
            to: viewController.view
        )
        
        frame = startingFrame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(animated: Bool) {
        if animated {
            // 애니메이션 시작 전 초기 상태 설정
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
            
            // 애니메이션 적용 (바운스 효과 추가)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0.9,
                           options: [],
                           animations: {
                            self.alpha = 1.0
                            self.transform = CGAffineTransform.identity
            }, completion: nil)
            
        } else {
            self.alpha = 1.0
        }
    }

    func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0.0
                self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) { _ in
                self.removeFromSuperview()
            }
        } else {
            self.removeFromSuperview()
        }
    }
}








