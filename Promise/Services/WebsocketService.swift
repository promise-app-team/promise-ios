//
//  WebsocketService.swift
//  Promise
//
//  Created by 신동오 on 2023/08/01.
//

import Foundation
import Starscream

typealias JsonData = [String: Any]

final class WebsocketService {
    // MARK: - Static property
    
    static let shared = WebsocketService()
    
    // MARK: - Public property
    
    var isConnected = false
    
    // MARK: - Private property
    
    private var socket: WebSocket!
    
    // MARK: - Initializer
    
    private init() {}
    
    // MARK: - Public function
    
    func connect(
        withQueryItems queryItems: [URLQueryItem],
        timeoutInterval: TimeInterval = 60.0
    ){
        guard let request = generateURLRequest(
            withQueryItems: queryItems,
            timeoutInterval: timeoutInterval
        ) else {
            print("WebSocketService: URLRequest 생성 실패")
            return
        }
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }
    
    func send(message: String) {
        let jsonData = generateJSONData(event: "ping", clientMessage: message)
        guard let jsonString = jsonString(from: jsonData)
        else {
            print("WebSocketSerice: jsonString 생성 실패")
            return
        }
            socket?.write(string: jsonString)
    }
    
    // MARK: - Private function
    
    private func generateURL(withQueryItems queryItems: [URLQueryItem]) -> URL? {
        let url = Config.apiURL
        var urlComponents = URLComponents(string: url.absoluteString)
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
    private func generateURLRequest(
        withQueryItems queryItems: [URLQueryItem],
        timeoutInterval: TimeInterval)
    -> URLRequest? {
        guard let url = generateURL(withQueryItems: queryItems) else {
            print("WebSocketService: URL 생성 실패")
            return nil
        }
        
        return URLRequest(url: url, timeoutInterval: timeoutInterval)
    }
    
    private func generateJSONData(
        event: String,
        clientMessage: String
    ) -> JsonData {
        let jsonData: [String: Any] = [
            "event": event,
            "data": ["client": clientMessage]
        ]
        
        return jsonData
    }
    
    private func jsonString(from data: JsonData) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("WebSocketService: JSON 변환에 실패했습니다 \(error)")
            return nil
        }
    }
}

// MARK: - WebSocketDelegate

extension WebsocketService: WebSocketDelegate {
    func didReceive(
        event: Starscream.WebSocketEvent,
        client: Starscream.WebSocket
    ){
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
        case .ping(_), .pong(_), .viabilityChanged(_), .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
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
