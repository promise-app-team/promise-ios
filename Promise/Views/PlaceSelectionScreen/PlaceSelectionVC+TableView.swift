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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceSelectionTableViewCell.identifier, for: indexPath) as? PlaceSelectionTableViewCell else {
            return PlaceSelectionTableViewCell()
        }
        let document = place?.documents?[indexPath.row]
        cell.updateNameLabel(newText: document?.placeName ?? "")
        cell.updateAddressLabel(newText: document?.roadAddressName ?? L10n.PlaceSelection.Label.emptyAddress)
        return cell
    }
}

// MARK: UITableViewDelegate

extension PlaceSelectionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard
            let latString = place?.documents?[indexPath.row].y,
            let lngString = place?.documents?[indexPath.row].x,
            let lat = Double(latString),
            let lng = Double(lngString)
        else {
            print("didSelectRowAt: fail to transfer")
            // x,y 없는 경우 사용자 알림 필요
            return
        }
        
        let placeName = place?.documents?[indexPath.row].placeName ?? ""
        let roadNameAddress = place?.documents?[indexPath.row].roadAddressName ?? ""
        let lotNumberAddress = place?.documents?[indexPath.row].addressName ?? ""
        
        let address = roadNameAddress.isEmpty
        ? lotNumberAddress
        : roadNameAddress
        
        let (city, district, address1) = AddressHelper().parseAddress(address)
        if let city, let district, let address1 {
            
            let place = PlaceSelection(
                city: city,
                district: district,
                address1: address1,
                placeName: placeName,
                lotNumberAddress: lotNumberAddress,
                roadNameAddress: roadNameAddress,
                lat: lat,
                lng: lng
            )
            
            currentPlace = place
            viewState = .searchMap
            changeMarkerPosition(lat: lat, lng: lng)
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return adjustedValue(86, .height)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _ = searchTextField.resignFirstResponder()
    }
}
