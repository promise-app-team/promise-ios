//
//  PopupHelper.swift
//  Promise
//
//  Created by Sun on 2023/07/29.
//

import UIKit

extension UIViewController {
    
    func showPopUp(title: String,
                   message: String,
                   rightBtnTitle: String? = nil,
                   rightBtnHandler: (() -> Void)? = nil,
                   cancelBtnExist: Bool = false) {
        
        let popupVC = PopupVC()
        popupVC.initialize(titleText: title,
                           messageText: message,
                           rightBtnTitle: rightBtnTitle ?? "확인",
                           rightBtnHandelr: rightBtnHandler ?? {popupVC.close()},
                           leftBtnTitle: cancelBtnExist ? "취소" : nil,
                           leftBtnHandler: cancelBtnExist ? { popupVC.close() } : nil)
        
        present(popupVC, animated: false, completion: nil)
    }
    
    func showPopUp(title: String,
                   message: String,
                   rightBtnTitle: String? = nil,
                   leftBtnTitle: String? = nil,
                   rightBtnHandler: (() -> Void)? = nil,
                   leftBtnHandler: (() -> Void)? = nil) {
        
        let popupVC = PopupVC()
        popupVC.initialize(titleText: title,
                           messageText: message,
                           rightBtnTitle: rightBtnTitle ?? "확인",
                           rightBtnHandelr: rightBtnHandler ?? { popupVC.close() },
                           leftBtnTitle: leftBtnTitle,
                           leftBtnHandler: leftBtnHandler)
        
        present(popupVC, animated: false, completion: nil)
    }
    
    func showPopUp(contentView: UIView,
                   rightBtnTitle: String? = nil,
                   rightBtnHandler: (() -> Void)? = nil,
                   cancelBtnExist: Bool = false) {
        
        let popupVC = PopupVC()
        popupVC.initialize(contentView: contentView,
                           rightBtnTitle: rightBtnTitle ?? "확인",
                           rightBtnHandelr: rightBtnHandler ?? {popupVC.close()},
                           leftBtnTitle: cancelBtnExist ? "취소" : nil,
                           leftBtnHandler: cancelBtnExist ? { popupVC.close() } : nil)
        
        present(popupVC, animated: false, completion: nil)
    }
    
    func showPopUp(contentView: UIView,
                   rightBtnTitle: String? = nil,
                   leftBtnTitle: String? = nil,
                   rightBtnHandelr: (() -> Void)? = nil,
                   leftBtnHandler: (() -> Void)? = nil) {
        
        let popupVC = PopupVC()
        popupVC.initialize(contentView: contentView,
                           rightBtnTitle: rightBtnTitle ?? "확인",
                           rightBtnHandelr: rightBtnHandelr ?? { popupVC.close() },
                           leftBtnTitle: leftBtnTitle,
                           leftBtnHandler: leftBtnHandler)
        
        present(popupVC, animated: false, completion: nil)
    }
    
}
