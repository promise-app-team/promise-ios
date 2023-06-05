//
//  ViewController.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showConfigAlert()
    }
    
    func showConfigAlert() {
        let alert = UIAlertController(title: "Config Values", message: "BUILD_ENV: \(Config.buildENV), APP_ENV: \(Config.appENV), API_URL: \(Config.apiURL)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
}

