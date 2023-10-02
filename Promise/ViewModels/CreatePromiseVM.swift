//
//  CreatePromiseVM.swift
//  Promise
//
//  Created by dylan on 2023/08/28.
//

import Foundation
import UIKit

class CreatePromiseVM: NSObject {
    var currentVC: UIViewController?
    
    var form = PromiseForm(title: "", date: "") {
        didSet {
            validateForm(form)
        }
    }
    
    init(currentVC: UIViewController? = nil) {
        self.currentVC = currentVC
    }
    
    private func validateForm(_ form: PromiseForm) {
        print(form.title)
    }
    
    @objc func onChangedTitle(_ textField: UITextField) {
        self.form = PromiseForm(title: textField.text ?? "", date: form.date)
    }
    
    @objc func onChangedDate(_ date: Date) {
        
    }
    
    func goBack() {
        currentVC?.navigationController?.popViewController(animated: true)
    }
    
    func getTodayString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
    func getSupportedTheme() -> [String] {
//        APIService.shared.fetch(.GET, "/promise/theme", Components.Schemas.)
//        Components.Schemas.
        
        return [""]
    }
}

extension CreatePromiseVM: UITextFieldDelegate {
    
}
