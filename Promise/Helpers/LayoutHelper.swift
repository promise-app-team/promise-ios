//
//  LayoutHelper.swift
//  Promise
//
//  Created by kwh on 2/7/24.
//

import Foundation
import UIKit

enum DeviceDimension {
    case width
    case height
}

// MARK: Width, Height
func adjustedHeight(_ designedHeight: CGFloat, _ designedDeviceHeight: CGFloat = 852) -> CGFloat {
    let actualDeviceHeight = UIScreen.main.bounds.height
    return (designedHeight * actualDeviceHeight) / designedDeviceHeight
}

func adjustedWidth(_ designedWidth: CGFloat, _ designedDeviceWidth: CGFloat = 393) -> CGFloat {
    let actualDeviceWidth = UIScreen.main.bounds.width
    return (designedWidth * actualDeviceWidth) / designedDeviceWidth
}

// MARK: Common
func adjustedValue(_ designedValue: CGFloat, _ dimension: DeviceDimension) -> CGFloat {
    let designedDeviceSize = CGSize(width: 393, height: 852)
    let actualDeviceSize = UIScreen.main.bounds.size
    
    let designedDeviceDimension = (dimension == .width) ? designedDeviceSize.width : designedDeviceSize.height
    let actualDeviceDimension = (dimension == .width) ? actualDeviceSize.width : actualDeviceSize.height
    
    return (designedValue * actualDeviceDimension) / designedDeviceDimension
}
