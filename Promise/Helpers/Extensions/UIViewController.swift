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
                           rightBtnTitle: rightBtnTitle ?? L10n.Common.confirm,
                           rightBtnHandelr: rightBtnHandler ?? {popupVC.close()},
                           leftBtnTitle: cancelBtnExist ? L10n.Common.cancel : nil,
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
                           rightBtnTitle: rightBtnTitle ?? L10n.Common.confirm,
                           rightBtnHandelr: rightBtnHandler ?? { popupVC.close() },
                           leftBtnTitle: leftBtnTitle,
                           leftBtnHandler: leftBtnHandler)
        
        present(popupVC, animated: false, completion: nil)
    }
    
    func showPopUp(
        contentView: UIView,
        rightBtnTitle: String? = nil,
        rightBtnHandler: (() -> Void)? = nil,
        cancelBtnExist: Bool = false,
        cancelBtnTitle: String = L10n.Common.cancel
    ) {
        
        let popupVC = PopupVC()
        popupVC.initialize(contentView: contentView,
                           leftBtnTitle: cancelBtnExist ? cancelBtnTitle : nil,
                           leftBtnHandler: cancelBtnExist ? { popupVC.close() } : nil,
                           rightBtnTitle: rightBtnTitle ?? L10n.Common.confirm,
                           rightBtnHandelr: rightBtnHandler ?? {popupVC.close()}
        )
        
        present(popupVC, animated: false, completion: nil)
    }
    
    func showPopUp(contentView: UIView,
                   leftBtnTitle: String? = nil,
                   leftBtnHandler: (() -> Void)? = nil,
                   rightBtnTitle: String? = nil,
                   rightBtnHandelr: (() -> Void)? = nil) {
        
        let popupVC = PopupVC()
        
        popupVC.initialize(contentView: contentView,
                           leftBtnTitle: leftBtnTitle,
                           leftBtnHandler: leftBtnHandler,
                           rightBtnTitle: rightBtnTitle ?? L10n.Common.confirm,
                           rightBtnHandelr: rightBtnHandelr ?? { popupVC.close() })
        
        present(popupVC, animated: false, completion: nil)
    }
}
