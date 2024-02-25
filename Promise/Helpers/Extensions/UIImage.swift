//
//  UIImage.swift
//  Promise
//
//  Created by dylan on 2023/08/01.
//

import UIKit

extension UIImage {
    func resize(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
    
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func withRoundedCorners(radius: CGFloat? = nil, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat = radius ?? maxRadius
        let imageSize = CGSize(width: size.width + borderWidth * 2, height: size.height + borderWidth * 2)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        let path = UIBezierPath(roundedRect: CGRect(x: borderWidth, y: borderWidth, width: size.width, height: size.height),
                                cornerRadius: cornerRadius)
        borderColor.set()
        path.lineWidth = borderWidth
        path.stroke()
        path.addClip()
        
        draw(at: CGPoint(x: borderWidth, y: borderWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
//    func withRoundedCorners(radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) -> UIImage? {
//            let maxRadius = min(size.width, size.height) / 2
//            let scaledRadius = radius > maxRadius ? maxRadius : radius
//            
//            // 이미지의 새 크기를 borderWidth를 고려하여 조정
//            let imageSize = CGSize(width: size.width + borderWidth * 2, height: size.height + borderWidth * 2)
//
//            UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
//            guard let context = UIGraphicsGetCurrentContext() else { return nil }
//
//            let rect = CGRect(x: borderWidth, y: borderWidth, width: size.width, height: size.height)
//            let path = UIBezierPath(roundedRect: rect, cornerRadius: scaledRadius).cgPath
//
//            // 테두리 그리기
//            context.addPath(path)
//            borderColor.set()
//            context.setLineWidth(borderWidth)
//            context.strokePath()
//
//            // 클리핑 영역 설정
//            context.addPath(path)
//            context.clip()
//
//            draw(at: CGPoint(x: borderWidth, y: borderWidth))
//            let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
//
//            UIGraphicsEndImageContext()
//
//            return roundedImage
//        }
}
