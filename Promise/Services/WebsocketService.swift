//
//  WebsocketService.swift
//  Promise
//
//  Created by 신동오 on 2023/08/01.
//

import Foundation
import Starscream

final class WebsocketService: WebSocketDelegate {
    
    // MARK: - Static property
    
    static let shared = WebsocketService()
    
    // MARK: - Public property
    
    var isConnected = false
    
    // MARK: - Private property
    
    private var socket: WebSocket!
    
    // MARK: - Initializer
    
    private init() {}
    
    // MARK: - Public function
    
    func connect(_ toParam: String) {
        
        // url 생성
        guard
            var urlComponents = URLComponents(string: "http://ec2-43-202-89-111.ap-northeast-2.compute.amazonaws.com:8080")
        else {
            print("urlComponents 생성 실패")
            return
        }
        urlComponents.queryItems = [URLQueryItem(name: "to", value: toParam)]
        
        // URLRequest 생성
        var request = URLRequest(url: urlComponents.url!)
        request.timeoutInterval = 5
        
        // 웹소켓 연결 요청
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
    
    func disconnect() {
        
        socket?.disconnect()
    }
    
    func send(message: String) {
        
        let jsonData: [String: Any] = [
            "event": "ping",
            "data": ["client": "\(message)"]
        ]
        
        if let jsonString = jsonString(from: jsonData) {
            socket?.write(string: jsonString)
        }
    }
    
    // MARK: - Delegate protocol function
    
    func didReceive(event: Starscream.WebSocketEvent, client: Starscream.WebSocket) {
        
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    
    // MARK: - Private function
    
    private func jsonString(from data: [String: Any]) -> String? {
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("JSON 변환에 실패했습니다: \(error)")
            return nil
        }
    }
    
    private func handleError(_ error: Error?) {
        
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
}
