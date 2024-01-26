//
//  PlaceSelectionVC+TableView.swift
//  Promise
//
//  Created by 신동오 on 2024/01/09.
//

import UIKit
import NMapsMap

// MARK: UITableViewDataSource

extension PlaceSelectionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return place?.documents?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PlaceSelectionTableViewCell else {
            return PlaceSelectionTableViewCell()
        }
        let document = place?.documents?[indexPath.row]
        cell.updateNameLabel(newText: document?.placeName ?? "")
        cell.updateAddressLabel(newText: document?.roadAddressName ?? "주소 없음")
        return cell
    }
}

// MARK: UITableViewDelegate

extension PlaceSelectionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard
            let latString = place?.documents?[indexPath.row].y,
            let lonString = place?.documents?[indexPath.row].x,
            let lat = Double(latString),
            let lon = Double(lonString)
        else {
            print("didSelectRowAt: fail to transfer")
            
            // x,y 없는 경우 사용자 알림 필요
            
            return
        }
        
        let position = NMGLatLng(lat: lat, lng: lon)
        let cameraUpdate = NMFCameraUpdate(scrollTo: position)
        naverMapView.mapView.moveCamera(cameraUpdate)
        
        viewState = .map
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _ = textField.resignFirstResponder()
    }
}
