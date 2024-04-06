//
//  WebSocketMessageMDL.swift
//  Promise
//
//  Created by kwh on 4/5/24.
//

import Foundation

struct WebSocketMessage: Codable {
    let from: String
    let timestamp: Int64
    let data: ClientData
}

// `data` 필드의 내용을 나타내는 구조체
struct ClientData: Codable {
    let client: Client
}

// `client` 객체를 나타내는 구조체
struct Client: Codable {
    let userId: String
    let latitude: String
    let longitude: String
}
