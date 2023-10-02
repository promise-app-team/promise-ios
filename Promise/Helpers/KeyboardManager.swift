//
//  KeyboardManager.swift
//  Promise
//
//  Created by dylan on 2023/09/30.
//

import Foundation
import UIKit

@objc protocol KeyboardManagerDelegate: AnyObject {
    @objc optional func dismissKeyboard()
}

class KeyboardManager: NSObject {
    
    static let shared = KeyboardManager()
    
    private(set) var isKeyboardVisible = false
    private var tapGestureRecognizer: UITapGestureRecognizer?
    
    weak var delegate: KeyboardManagerDelegate?
    weak var vc: UIViewController?
    
    private override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        isKeyboardVisible = true
        activateTapToDismiss()
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        isKeyboardVisible = false
        deactivateTapToDismiss()
    }
    
    func registerVC(_ vc: UIViewController) {
        self.vc = vc
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapToDismiss))
        tapGestureRecognizer?.cancelsTouchesInView = true
        tapGestureRecognizer?.delegate = self
    }
    
    func hideKeyboard() {
        self.vc?.view.endEditing(true)
    }
    
    @objc private func handleTapToDismiss() {
        // UIViewController or UIView 타입으로 캐스팅
        if let vcDelegate = delegate as? UIViewController {
            vcDelegate.view.endEditing(true)
        } else if let viewDelegate = delegate as? UIView {
            viewDelegate.endEditing(true)
        }
        
        delegate?.dismissKeyboard?()
    }
    
    private func activateTapToDismiss() {
        if let tap = tapGestureRecognizer {
            UIApplication.shared.windows.first?.addGestureRecognizer(tap)
        }
    }
    
    private func deactivateTapToDismiss() {
        if let tap = tapGestureRecognizer {
            UIApplication.shared.windows.first?.removeGestureRecognizer(tap)
        }
    }
}

extension KeyboardManager: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

