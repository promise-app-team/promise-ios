//
//  PlaceSelectionMapVC.swift
//  Promise
//
//  Created by 신동오 on 1/13/24.
//

import UIKit
import NMapsMap

final class PlaceSelectionMapVC: UIViewController {
    
    let mapView: NMFMapView = {
        let mapView = NMFMapView()
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
