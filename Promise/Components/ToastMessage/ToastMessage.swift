//
//  ToastMessage.swift
//  Promise
//
//  Created by zzee22su on 2023/06/12.
//

import UIKit

class ToastView: UIView {
    private let label: PaddingLabel
    private let sumOfPadding: CGFloat = 20 //PaddingLabel의 왼쪽/오른쪽 여백의 합
    
    init(message: String) {
        let labelHeight: CGFloat = 35
        let font = UIFont.systemFont(ofSize: 13)
        let maxWidth = UIScreen.main.bounds.width - sumOfPadding
        let labelWidth = min(message.width(labelHeight: labelHeight, font: font) + sumOfPadding, maxWidth)
        
        let frame = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
        
        label = {
            let label = PaddingLabel(frame: frame)
            label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = font
            label.numberOfLines = 1
            label.lineBreakMode = .byTruncatingTail
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 15
            label.text = message
            return label
        }()
        
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showToast(duration: TimeInterval = 2.0) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        
        let toastView = ToastView(message: self.label.text ?? "")
        toastView.center = CGPoint(x: window.center.x, y: window.bounds.height - (toastView.frame.height / 2) - 100)
        window.addSubview(toastView)
        
        UIView.animate(withDuration: 0.3, animations: {
            toastView.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                toastView.alpha = 0.0
            }) { _ in
                toastView.removeFromSuperview()
            }
        }
    }
}


extension String {
    //문자열 너비 계산
    func width(labelHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.width)
    }
}


//MARK: - 토스트메시지 사용법(예시코드)
//@objc private func showShortButtonTapped() {
//    ToastView(message: "약속이 생성되었습니다").showToast()
//}
