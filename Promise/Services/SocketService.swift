//
//  SocketService.swift
//  Promise
//
//  Created by 신동오 on 2023/08/01.
//

import Foundation
import SocketIO

final class SocketService {
    
    // MARK: - Static property
    
    static let shared = SocketService()
    
    // MARK: - Private property
    
    private let manager: SocketManager
    private let socket: SocketIOClient
    
    // MARK: - Initializer
    
    private init() {
        
        // configure
        manager = SocketManager(
            socketURL: URL(string: "http://ec2-43-202-89-111.ap-northeast-2.compute.amazonaws.com:8080")!,
            config: [
                .compress,
                .connectParams(["to": "broadcast"])]
        )
        
        socket = manager.socket(forNamespace: "/ping")
    }
    
    // MARK: - Public function
    
    func connectToServer() {
        
        socket.on(clientEvent: .connect) {data, _ in
            print("socket connected")
        }
        
        socket.on("pong") { data, _ in
            print("pong: \(data)")
        }
        
        socket.connect()
    }
    
    func emitEvent(message: String) {
        
        socket.emit("emit: \(message)")
    }
    
    func disconnectFromServer() {
        
        socket.disconnect()
    }
}
