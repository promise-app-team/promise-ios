//
//  UIImageView.swift
//  Promise
//
//  Created by dylan on 2023/11/05.
//

import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                 
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                
            }
            
        }
    }
    
    func load(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        DispatchQueue.global().async {
            
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                
                DispatchQueue.main.async {
                    self.image = image
                    completion(image)
                }
                
            } else {
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            
        }
    }
}
