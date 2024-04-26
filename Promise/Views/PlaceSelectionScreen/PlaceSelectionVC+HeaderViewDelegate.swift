//
//  PlaceSelectionVC+HeaderViewDelegate.swift
//  Promise
//
//  Created by 신동오 on 4/10/24.
//

import Foundation

extension PlaceSelectionVC: HeaderViewDelegate {
    func onTapCustomBackAction() {
        switch viewState {
        case .searchMap:
            viewState = .searchResult
        case .searchResult:
            viewState = .none
        case .none:
            dismiss(animated: true)
        default:
            break
        }
    }
}
