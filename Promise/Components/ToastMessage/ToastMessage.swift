//
//  ToastMessage.swift
//  Promise
//
//  Created by zzee22su on 2023/06/12.
//

import UIKit

class ToastView: UIView {
    private let label: UILabel
    
    init(message: String) {
        let labelWidth: CGFloat = 180
        let labelHeight: CGFloat = 35
        let frame = CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)

        label = {
            let label = UILabel(frame: frame)
            label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 13)
            label.text = message
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 15
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
        
        DispatchQueue.main.async {
            let toastView = ToastView(message: self.label.text ?? "")
            toastView.center = window.center
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
    
    // MARK: 토스트 메시지를 생성하고 싶은 곳에 사용
    // func showToastMessage() {
    //   let toastView = ToastView(message: "약속이 생성되었습니다.")
    //   toastView.showToast()
    // }
}
