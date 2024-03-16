//
//  PromiseFormMDL.swift
//  Promise
//
//  Created by dylan on 2023/08/29.
//

import Foundation

struct PromiseForm {
    var title: String
    var date: SelectionDate?
    var themes: [SelectableTheme]
    var placeType: Components.Schemas.InputCreatePromiseDTO.destinationTypePayload
    var place: Components.Schemas.InputCreatePromiseDTO.destinationPayload?
    var shareLocationStartType: Components.Schemas.InputCreatePromiseDTO.locationShareStartTypePayload
    var shareLocationStart: Double
    var shareLocationEnd: Double
}

struct SelectableTheme {
    let id: Double
    let theme: String
    var isSelected: Bool
}

struct SelectionPlace {
    let city: String
    let district: String
    let address: String
    let latitude: Double
    let longitude: Double
}

struct SelectionDate {
    let originDate: Date
    var formattedDate: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.string(from: originDate)
        }
    }
    
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC 타임존 설정
        return formatter.string(from: originDate)
    }
    
    var timeIntervalInSeconds: TimeInterval {
        get {
            return originDate.timeIntervalSince1970
        }
    }
}

struct SelectionItem {
    let item: String
    let itemIndex: Int
}

struct ShareLocationStartBasedOnDistanceInfo {
    let meters = ["100", "200", "300", "400", "500", "600", "700", "800", "900"]
    let kilometers = ["1", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50"]
    
    var metersText: [String]
    var kilometersText: [String]
    var originItmes: [String]
    var items: [String]
    var initialItem: SelectionItem
    
    init() {
        self.originItmes = meters + kilometers
        self.metersText = meters.map { "\($0)\(L10n.Common.m)" }
        self.kilometersText = kilometers.map { "\($0)\(L10n.Common.km)" }
        
        self.items = metersText + kilometersText
        self.initialItem = SelectionItem(item: items[9], itemIndex: 9)
    }
    
    func getOriginItem(at index: Int) -> Double? {
        if index >= 0 && index < items.count {
            return Double(originItmes[index])
        }
        
        return nil
    }
}


struct ShareLocationStartBasedOnTimeInfo {
    let minutes = ["10", "20", "30", "40", "50"]
    let hours = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    
    var minutesText: [String]
    var hoursText: [String]
    var originItmes: [String]
    var items: [String]
    var initialItem: SelectionItem
    
    init() {
        self.originItmes = minutes + hours
        self.minutesText = minutes.map { "\($0)\(L10n.Common.minute) \(L10n.CreatePromise.ShareLocationStartType.BasedOnTime.itemSuffix)" }
        self.hoursText = hours.map { "\($0)\(L10n.Common.hour) \(L10n.CreatePromise.ShareLocationStartType.BasedOnTime.itemSuffix)" }
        
        self.items = minutesText + hoursText
        self.initialItem = SelectionItem(item: items[5], itemIndex: 5)
    }
    
    func getOriginItem(at index: Int) -> Double? {
        if index >= 0 && index < items.count {
            return Double(originItmes[index])
        }
        
        return nil
    }
}

struct ShareLocationEndInfo {
    let minutes = ["10", "20", "30", "40", "50"]
    let hours = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    
    var minutesText: [String]
    var hoursText: [String]
    var maxText: String
    var originItmes: [String]
    var items: [String]
    var initialItem: SelectionItem
    
    init() {
        self.originItmes = minutes + hours
        self.minutesText = minutes.map { "\($0)\(L10n.Common.minute) \(L10n.CreatePromise.ShareLocationEnd.itemSuffix)" }
        self.hoursText = hours.map { "\($0)\(L10n.Common.hour) \(L10n.CreatePromise.ShareLocationEnd.itemSuffix)" }
        self.maxText = "\(L10n.CreatePromise.ShareLocationEnd.max)"
        
        self.items = minutesText + hoursText + [maxText]
        self.initialItem = SelectionItem(item: items[5], itemIndex: 5)
    }
    
    func getOriginItem(at index: Int) -> Double? {
        if index >= 0 && index < items.count {
            return Double(originItmes[index])
        }
        
        return nil
    }
}

