//
//  SocketService.swift
//  Promise
//
//  Created by dylan on 2023/07/17.
//

import UIKit
import SocketIO

class SocketService {
    static let shared = SocketService()
    
    private let manager: SocketManager
    private var socket: SocketIOClient
    
    init() {
        self.manager = SocketManager(socketURL: URL(string: "http://ec2-43-202-89-111.ap-northeast-2.compute.amazonaws.com:8080")!,
                                     config: [.compress, .forceWebsockets(true), .connectParams(["to": "broadcast"])])
        self.socket = self.manager.socket(forNamespace: "/ping")
    }
    
    func connectToServer() {
        socket.on(clientEvent: .statusChange) { (data, ack) in
            if let status = data.first as? SocketIOStatus {
                switch status {
                case .connected:
                    print("⭐️⭐️⭐️Socket connected")
                case .connecting:
                    print("⭐️⭐️⭐️Socket connecting")
                case .disconnected:
                    print("⭐️⭐️⭐️Socket disconnected")
                case .notConnected:
                    print("⭐️⭐️⭐️Socket not connected")
                }
            }
        }
        
        socket.on("pong") { dataArray, ack in
            print("⭐️⭐️⭐️pong: \(dataArray)")
        }
        
        socket.connect()
    }
    
    func emitEvent(message: String?) {
        guard let message = message else { return }
        socket.emit("ping", "message: \(message)")
    }
    
    func disconnectFromServer() {
        socket.disconnect()
    }
}

