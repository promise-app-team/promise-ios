//
//  TextField.swift
//  Promise
//
//  Created by Sun on 2023/09/16.
//

import UIKit

class TextField: UITextField {
    
    private let placeHolderTextColor: UIColor = UIColor(hexCode: "#CCCCCC")
    private let defaultBorderColor: CGColor = UIColor(hexCode: "#CCCCCC").cgColor
    private let focusedBorderColor: CGColor = UIColor(hexCode: "#06BF9E").cgColor
    
    private var showSearchIcon: Bool = false
    
    public func initialize(placeHolder: String, showSearchIcon: Bool){
        self.showSearchIcon = showSearchIcon
        
        setupClearButton()
        setupPlaceHolder(placeHolder: placeHolder)
        setupUI()
        
        addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func becomeFirstResponder() -> Bool {
        self.layer.borderColor = focusedBorderColor
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.layer.borderColor = defaultBorderColor
        if let text = text, !text.isEmpty {
            rightViewMode = .always
        }
        return super.resignFirstResponder()
    }
    
    private func setupClearButton() {
        rightViewMode = .never
        updateClearButtonVisibility()
    }
    
    private func setupPlaceHolder(placeHolder: String){
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeHolderTextColor,
            .font: UIFont.pretendard(style: .B1_R)
        ]
        attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: attributes)
    }
    
    private func setupUI(){
        translatesAutoresizingMaskIntoConstraints = false
        
        // layer
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = defaultBorderColor
        layer.backgroundColor = UIColor.white.cgColor
        if showSearchIcon {
            addSearchIconPadding()
        } else {
            addLeftPadding()
        }
        addClearButton()
        
        //text
        textColor = UIColor.black
        font = UIFont.pretendard(style: .B1_R)
    }
    
    
    @objc func textFieldDidChange() {
        updateClearButtonVisibility()
    }
    
    private func updateClearButtonVisibility() {
        if let text = text, !text.isEmpty {
            rightViewMode = .whileEditing
            return
        }
        
        rightViewMode = .never
    }
}
