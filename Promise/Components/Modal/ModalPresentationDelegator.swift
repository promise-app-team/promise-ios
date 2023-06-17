//
//  ModalPresentationDelegator.swift
//  Promise
//
//  Created by Sun on 2023/06/12.
//

import UIKit

class ModalPresentationDelegator : NSObject, UIViewControllerTransitioningDelegate {
    
    // presentedViewController: 모달로 띄워진 뷰. 즉 모달 뷰 컨트롤러
    // presentingViewController: 모달을 띄우는 뷰. 모달 뒤에 있는 뷰
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }

}
