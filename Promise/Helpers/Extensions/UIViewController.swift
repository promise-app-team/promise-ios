//
//  PopupHelper.swift
//  Promise
//
//  Created by Sun on 2023/07/29.
//

import UIKit

extension UIViewController {
    
    // 확인 버튼이 팝업 닫기
    func showPopUp(title: String,
                   message: String,
                   rightBtnTitle: String = "확인") {
        
        let popupVC = PopupVC()
        popupVC.initialize(titleText: title, messageText: message, rightBtnTitle: rightBtnTitle, rightBtnHandelr: { popupVC.close() })
        
        present(popupVC, animated: false, completion: nil)
    }
    
    func showPopUp(title: String,
                   message: String,
                   rightBtnTitle: String,
                   rightBtnHandler: @escaping (() -> Void),
                   cancelBtnExist: Bool = false) {
        
        let popupVC = PopupVC()
        if cancelBtnExist {
            popupVC.initialize(titleText: title, messageText: message, rightBtnTitle: rightBtnTitle, rightBtnHandelr: rightBtnHandler, leftBtnTitle: "취소", leftBtnHandler: { popupVC.close() })
            
        } else{
            popupVC.initialize(titleText: title, messageText: message, rightBtnTitle: rightBtnTitle, rightBtnHandelr: rightBtnHandler)
        }
        
        present(popupVC, animated: false, completion: nil)
    }
    
    func showPopUp(title: String,
                   message: String,
                   rightBtnTitle: String,
                   leftBtnTitle: String?,
                   rightBtnHandler: @escaping (() -> Void),
                   leftBtnHandler: (() -> Void)? = nil) {
        
        let popupVC = PopupVC()
        popupVC.initialize(titleText: title, messageText: message, rightBtnTitle: rightBtnTitle, rightBtnHandelr: rightBtnHandler, leftBtnTitle: leftBtnTitle, leftBtnHandler: leftBtnHandler)
        
        present(popupVC, animated: false, completion: nil)
        
    }
    
    func showPopUp(contentView: UIView,
                   rightBtnTitle: String = "확인") {
        
        let popupVC = PopupVC()
        popupVC.initialize(contentView: contentView, rightBtnTitle: rightBtnTitle, rightBtnHandelr: { popupVC.close() })
        
        present(popupVC, animated: false, completion: nil)
    }
    
    func showPopUp(contentView: UIView,
                   rightBtnTitle: String,
                   rightBtnHandler: @escaping (() -> Void),
                   cancelBtnExist: Bool = false) {
        
        let popupVC = PopupVC()
        if cancelBtnExist {
            popupVC.initialize(contentView: contentView, rightBtnTitle: rightBtnTitle, rightBtnHandelr: rightBtnHandler, leftBtnTitle: "취소", leftBtnHandler: { popupVC.close() })
            
        } else{
            popupVC.initialize(contentView: contentView, rightBtnTitle: rightBtnTitle, rightBtnHandelr: rightBtnHandler)
        }
        
        present(popupVC, animated: false, completion: nil)
    }
    
    func showPopUp(contentView: UIView,
                   rightBtnTitle: String,
                   leftBtnTitle: String?,
                   rightBtnHandelr: @escaping (() -> Void),
                   leftBtnHandler: (() -> Void)? = nil) {
        
        let popupVC = PopupVC()
        popupVC.initialize(contentView: contentView, rightBtnTitle: rightBtnTitle, rightBtnHandelr: rightBtnHandelr, leftBtnTitle: leftBtnTitle, leftBtnHandler: leftBtnHandler)
        
        present(popupVC, animated: false, completion: nil)
    }
    
}
