//
//  PopupDelegate.swift
//  Promise
//
//  Created by Sun on 2023/08/26.
//

import UIKit

protocol PopupDelegate {
    
    func show(title: String,
              message: String,
              rightBtnTitle: String?,
              rightBtnHandler: (() -> Void)?,
              cancelBtnExist: Bool)
    
    func show(title: String,
              message: String,
              rightBtnTitle: String?,
              leftBtnTitle: String?,
              rightBtnHandler: (() -> Void)?,
              leftBtnHandler: (() -> Void)?)
    
    func showWithView(rightBtnTitle: String?,
                      rightBtnHandler: (() -> Void)?,
                      cancelBtnExist: Bool)
    
    func showWithView(rightBtnTitle: String?,
                      leftBtnTitle: String?,
                      rightBtnHandler: (() -> Void)?,
                      leftBtnHandler: (() -> Void)?)
    
}
