//
//  UIView.swift
//  Promise
//
//  Created by dylan on 2023/11/05.
//

import UIKit

extension UIView {
    func applyCornerRadii(topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let path = UIBezierPath()
        
        // 상단 왼쪽 코너
        path.move(to: CGPoint(x: topLeft, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.width - topRight, y: 0))
        path.addArc(withCenter: CGPoint(x: self.bounds.width - topRight, y: topRight),
                    radius: topRight,
                    startAngle: CGFloat(3 * Double.pi / 2),
                    endAngle: 0,
                    clockwise: true)
        
        // 상단 오른쪽 코너
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height - bottomRight))
        path.addArc(withCenter: CGPoint(x: self.bounds.width - bottomRight, y: self.bounds.height - bottomRight),
                    radius: bottomRight,
                    startAngle: 0,
                    endAngle: CGFloat(Double.pi / 2),
                    clockwise: true)
        
        // 하단 오른쪽 코너
        path.addLine(to: CGPoint(x: bottomLeft, y: self.bounds.height))
        path.addArc(withCenter: CGPoint(x: bottomLeft, y: self.bounds.height - bottomLeft),
                    radius: bottomLeft,
                    startAngle: CGFloat(Double.pi / 2),
                    endAngle: CGFloat(Double.pi),
                    clockwise: true)
        
        // 하단 왼쪽 코너
        path.addLine(to: CGPoint(x: 0, y: topLeft))
        path.addArc(withCenter: CGPoint(x: topLeft, y: topLeft),
                    radius: topLeft,
                    startAngle: CGFloat(Double.pi),
                    endAngle: CGFloat(3 * Double.pi / 2),
                    clockwise: true)
        
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        
        // 테두리 레이어 생성 및 적용
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path // 마스크와 동일한 경로 사용
        borderLayer.fillColor = UIColor.clear.cgColor // 내부 색상 없음
        borderLayer.strokeColor = borderColor.cgColor // 테두리 색상
        borderLayer.lineWidth = borderWidth // 테두리 두께
        borderLayer.frame = self.bounds
        
        // 기존 테두리 레이어를 제거하고 새로운 테두리 레이어를 추가합니다.
        self.layer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        self.layer.addSublayer(borderLayer)
    }
    
    func parentViewController<T: UIViewController>() -> T? {
        var responder: UIResponder? = self
        while let currentResponder = responder {
            if let viewController = currentResponder as? T {
                return viewController
            }
            responder = currentResponder.next
        }
        
        return nil
    }
    
    // MARK: 뷰가 그려진 이후에 호출해야 됨.
    func addDashedBorder() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor
        shapeLayer.lineWidth = frame.height
        
        // [첫번째 dash의 길이, 두번째 dash 사이 간격, 두번째 dash의 길이, 두번째와 세번째 dash의 간격] 이 패턴으로 반복된다.
        shapeLayer.lineDashPattern = [3]
        
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: 0, y: frame.height / 2), CGPoint(x: frame.width, y: frame.height / 2)])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}

