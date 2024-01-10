//
//  PlaceSelectionVC+TableView.swift
//  Promise
//
//  Created by 신동오 on 2024/01/09.
//

import UIKit

// MARK: UITableViewDataSource

extension PlaceSelectionVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PlaceSelectionTableViewCell else {
            return PlaceSelectionTableViewCell()
        }
        cell.updateNameLabel(newText: "스트롱밧데리")
        cell.updateAddressLabel(newText: "서울 중랑구 신내로 193 지하1층 코어스트롱")
        return cell
    }
}

// MARK: UITableViewDelegate

extension PlaceSelectionVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
}
