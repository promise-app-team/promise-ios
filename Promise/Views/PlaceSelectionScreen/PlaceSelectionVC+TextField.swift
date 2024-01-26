//
//  PlaceSelectionVC+TextField.swift
//  Promise
//
//  Created by 신동오 on 2024/01/11.
//

import UIKit

extension PlaceSelectionVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case searchTextField:
            guard
                let userInput = textField.text,
                textField.text != ""
            else {
                viewState = .idle
                return false
            }
            
            searchPlace(of: userInput)
            viewState = .resultList
        case confirmView.addressTextField:
            print("this")
        default:
            break
        }
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func searchPlace(of userInput: String) {
        let urlString = "https://dapi.kakao.com/v2/local/search/keyword.json"
        let restAPIKey = "d957fe93f39254e70df345a09caaecf7"
        let searchKeyword = userInput
        
        guard var urlComponent = URLComponents(string: urlString) else {
            print("urlComponent error")
            return
        }
        urlComponent.queryItems = [
            URLQueryItem(name: "query", value: searchKeyword),
            URLQueryItem(name: "size", value: "15")
        ]
        
        guard let url = urlComponent.url else {
            print("url error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK \(restAPIKey)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                do {
                    let json = try JSONDecoder().decode(KakaoPlaceMDL.self, from: data)
                    self?.place = json
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                } catch {
                    print(String(data: data, encoding: .utf8) ?? "")
                    print(error)
                }
            }
        }
        task.resume()
    }
}
