//
//  WebsocketService.swift
//  Promise
//
//  Created by 신동오 on 2023/07/22.
//


import UIKit
import Starscream

extension Notification.Name {
    static let receivedText = Notification.Name("receivedText")
    static let receivedStatus = Notification.Name("receivedStatus")
}

class WebSocketService: WebSocketDelegate {
    
    static let shared = WebSocketService()
    private var socket: WebSocket!

    private init() {}
    
    deinit {
        print("manager 소멸")
    }

    func connect(to input: String) {
        guard var urlComponents = URLComponents(string: "http://ec2-43-202-89-111.ap-northeast-2.compute.amazonaws.com:8080")
        else {
            print("urlComponents 생성 실패")
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "to", value: input)]

        // URLRequest 생성
        var request = URLRequest(url: urlComponents.url!)
        request.timeoutInterval = 5

        // 웹소켓 연결 요청
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func disconnect() {
        socket?.disconnect()
    }

    func sendDataToServer(message: String) {
        let jsonData: [String: Any] = [
            "event": "ping",
            "data": [
                "client": "\(message)"
            ]
        ]

        // JSON 데이터를 문자열로 변환
        if let jsonString = jsonString(from: jsonData) {
            // 문자열을 웹소켓을 통해 서버로 전송
            socket?.write(string: jsonString)
        }
    }
    
    // JSON 데이터를 문자열로 변환하는 함수
    private func jsonString(from data: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("JSON 변환에 실패했습니다: \(error)")
            return nil
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            client.write(string: "userName")
            print("⭐️⭐️⭐️websocket is connected: \(headers)")
            NotificationCenter.default.post(name: .receivedStatus, object: nil, userInfo: ["message": "연결이 완료되었습니다.", "status": Status.connect])
            
        case .disconnected(let reason, let code):
            print("⭐️⭐️⭐️websocket is disconnected: \(reason) with code: \(code)")
            NotificationCenter.default.post(name: .receivedStatus, object: nil, userInfo: ["message": "연결 해제되었습니다.", "status": Status.disconnect])
            
        case .text(let text):
            print("⭐️⭐️⭐️received text: \(text)")
            NotificationCenter.default.post(name: .receivedText, object: nil, userInfo: ["text": text])
        case .binary(let data):
            print("⭐️⭐️⭐️Received data: \(data.count)")
        case .ping(_):
            print("⭐️⭐️⭐️ping")
            break
        case .pong(_):
            print("⭐️⭐️⭐️pong")
            break
        case .viabilityChanged(_):
            print("⭐️⭐️⭐️viabilityChanged")
            break
        case .reconnectSuggested(_):
            print("⭐️⭐️⭐️reconnectSuggested")
            break
            
        case .cancelled:
            print("⭐️⭐️⭐️websocket is canclled")
            NotificationCenter.default.post(name: .receivedStatus, object: nil, userInfo: ["message": "연결이 취소되었습니다.", "status": Status.disconnect])
            
        case .error(let error):
            print("⭐️⭐️⭐️websocket is error = \(error!)")
            NotificationCenter.default.post(name: .receivedStatus, object: nil, userInfo: ["message": "웹소켓 에러가 발생하였습니다.", "status": Status.disconnect])
        }
    }
}

