//
//  WebsocketService.swift
//  Promise
//
//  Created by 신동오 on 2023/07/22.
//


import UIKit
import Starscream

class WebSocketManager: WebSocketDelegate {
    
    static let shared = WebSocketManager()
    private var socket: WebSocket!
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var timer: Timer?

    private init() { }

    func connect() {
        guard var urlComponents = URLComponents(string: "http://ec2-43-202-89-111.ap-northeast-2.compute.amazonaws.com:8080")
        else {
            print("urlComponents 생성 실패")
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "to", value: "broadcast")]

        // URLRequest 생성
        var request = URLRequest(url: urlComponents.url!)
        request.timeoutInterval = 5

        // 웹소켓 연결 요청
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }

    func sendDataToServer() {
        let jsonData: [String: Any] = [
            "event": "ping",
            "data": [
                "⭐️데이터보내기": "⭐️성공!"
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

    func startBackgroundTask() {
        // 백그라운드 작업 시작
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }

        // 3초마다 sendDataToServerInBackground() 함수를 호출하는 Timer 설정
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(sendDataToServerInBackground), userInfo: nil, repeats: true)

        // 10초 후에 작업 종료를 위해 Timer 추가
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
            print("🔴백그라운드 진입 10초후 종료")
            self?.endBackgroundTask()
        }
    }

    @objc func sendDataToServerInBackground() {
        // 백그라운드에서 sendDataToServer() 함수 호출
        print("🔴3초 단위 전송")
        sendDataToServer()
    }

    func endBackgroundTask() {
        // 타이머를 중지하고 백그라운드 작업 종료
        timer?.invalidate()
        timer = nil

        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            client.write(string: "userName")
            //          client.write(string: userName)
            print("⭐️⭐️⭐️websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            print("⭐️⭐️⭐️websocket is disconnected: \(reason) with code: \(code)")
        case .text(let text):
            print("⭐️⭐️⭐️received text: \(text)")
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
        case .error(let error):
            print("⭐️⭐️⭐️websocket is error = \(error!)")
        }
    }
}

