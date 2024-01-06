//
//  APIService.swift
//  Promise
//
//  Created by dylan on 2023/05/29.
//

import Foundation
import OpenAPIRuntime
import OpenAPIURLSession

enum NetworkError: Error {
    case badUrl
    case badRequest(Data?)
    case networkError(Error?)
    case decodingError
    case encodeingError
    case notAuthenticated
}

enum HttpMethod: String {
    case POST
    case GET
    // Ohter http methods
}

// TODO: 서버 에러 메시지
struct ErrorResponse {
    let message: String
    let error: String
    let statusCode: Int
}

protocol APIServiceDelegate: AnyObject {
    func onLoading(path: String?, isLoading: Bool)
}

extension APIServiceDelegate {
    func onLoading(path: String?, isLoading: Bool) {
        #if DEBUG
        print("==========================================================")
        print("API End Point: [\(path ?? "/")] is loading? \(isLoading)")
        print("==========================================================")
        #endif
    }
}

final class APIService: NSObject {
    static let shared = APIService()
    weak var delegate: APIServiceDelegate?
    
    func fetch<Response: Decodable>(_ method: HttpMethod, _ path: String? = nil, _ params: [String: String]? = nil , _ body: Encodable? = nil) async -> Result<Response, NetworkError> {
        
        // MARK: async fetch는 내부 모든 컨텍스트(토큰 만료로 인한 갱신 및 리패치 포함)가 모두 끝날때까지 기다리게 설계됨.
        // MARK: 즉, defer의 호출은 쿼리 호출이 모두 완료(혹은 중간에 중단)되었다는 것을 보장함.
        // fetch 함수 시작 loading -> true
        delegate?.onLoading(path: path, isLoading: true)
        // fetch 함수의 종료(반환)시 loading -> false
        defer {
            delegate?.onLoading(path: path, isLoading: false)
        }
        
        do {
            var url = Config.apiURL
            
            // Step 1: endpoint path setting
            if let path = path {
                url.appendPathComponent(path)
            }
            
            // Step 2: create URLComponents
            guard var urlComponents = URLComponents(string: url.absoluteString) else { return .failure(.badUrl) }
            
            // Step 3: query paramenters setting
            if let params = params {
                urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
            }
            
            // Step 4: create URLRequest
            guard let requestUrl = urlComponents.url else { return .failure(.badUrl) }
            var request = URLRequest(url: requestUrl)
            
            // Step 5: http header setting
            request.setValue("application/json", forHTTPHeaderField: "Content-Type") // 요청타입: JSON
            request.setValue("application/json", forHTTPHeaderField: "Accept") // 응답타입: JSON
            if let token = UserService.shared.getAccessToken(), !token.isEmpty {
                request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization") // JWT 토큰
            }
            
            // Step 6: http method setting
            request.httpMethod = method.rawValue
            
            // Step 7: body setting by method
            switch(method) {
            case .GET:
                break
            case .POST:
                if let body = body {
                    if let jsonData = try? JSONEncoder().encode(body) {
                        request.httpBody = jsonData
                    } else {
                        return .failure(.encodeingError)
                    }
                }
                // Other handle http methods
            }
            
            // Step 8: resume url session task
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if (response as? HTTPURLResponse)?.statusCode == 401 {
                return await updateAccessToken(request: request)
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return .failure(.badRequest(data))
            }
            
            guard let parsedData = try? JSONDecoder().decode(Response.self, from: data) else {
                return .failure(.decodingError)
            }
            
            return .success(parsedData)
        } catch {
            return .failure(.networkError(error))
        }
    }
    
    private func updateAccessToken<Response: Decodable>(request: URLRequest) async -> Result<Response, NetworkError> {
        // MARK: 리프레시 토큰 자체가 없는 경우(로그인 시 리프레시 토큰이 제대로 저장되지 않거나 로그인을 하지 않은 상태)
        guard let refreshToken = UserService.shared.getRefreshToken() else {
            // TODO: 로그인 화면으로 이동
            return .failure(.notAuthenticated)
        }
        
        let result: Result<Components.Schemas.AuthToken, NetworkError> = await APIService.shared.fetch(.POST, "/auth/refresh", nil, Components.Schemas.InputRefreshToken(refreshToken: refreshToken))
        
        switch result {
        case .success(let updatedToken):
            let result = await UserService.shared.setUser(accessToken: updatedToken.accessToken, refreshToken: updatedToken.refreshToken)
            
            guard result else {
                // MARK: 갱신에는 성공했지만 제대로 유저를 세팅하지 못한 경우(다시 로그인 하는게 좋겠음)
                // TODO: 로그인 화면으로 이동
                return .failure(.notAuthenticated)
            }
            
            // MARK: 인증에 실패한 최초 요청을 토큰 갱신 후 다시 처리
            do {
                var reRequest = request
                let updatedAccessToken = updatedToken.accessToken
                reRequest.setValue( "Bearer \(updatedAccessToken)", forHTTPHeaderField: "Authorization")
                
                let (data, response) = try await URLSession.shared.data(for: reRequest)
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    return .failure(.badRequest(data))
                }
                
                guard let parsedData = try? JSONDecoder().decode(Response.self, from: data) else {
                    return .failure(.decodingError)
                }
                
                return .success(parsedData)
            } catch {
                return .failure(.networkError(error))
            }
            
            // MARK: 리프레시 토큰도 만료돼서 갱신을 못하는 경우(로그인을 다시 해야함)
        case .failure:
            // TODO: 로그인 화면으로 이동
            return .failure(.notAuthenticated)
        }
    }
    
    func fetch<Response: Decodable>(_ method: HttpMethod, _ path: String? = nil, _ params: [String: String]? = nil , _ body: Encodable? = nil, completion: @escaping (Result<Response, NetworkError>) -> Void) {
        
        var url = Config.apiURL
        
        // Step 1: endpoint path setting
        if let path = path {
            url.appendPathComponent(path)
        }
        
        // Step 2: create URLComponents
        guard var urlComponents = URLComponents(string: url.absoluteString) else {
            completion(.failure(.badUrl))
            return
        }
        
        // Step 3: query paramenters setting
        if let params = params {
            urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        // Step 4: create URLRequest
        guard let requestUrl = urlComponents.url else {
            completion(.failure(.badUrl))
            return
        }
        var request = URLRequest(url: requestUrl)
        
        // Step 5: http header setting
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // 요청타입: JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // 응답타입: JSON
        if let token = UserService.shared.getAccessToken(), !token.isEmpty {
            request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization") // JWT 토큰
        }
        
        
        // Step 6: http method setting
        request.httpMethod = method.rawValue
        
        // Step 7: body setting by method
        switch(method) {
        case .GET:
            break
        case .POST:
            if let body = body {
                if let jsonData = try? JSONEncoder().encode(body) {
                    request.httpBody = jsonData
                } else {
                    completion(.failure(.encodeingError))
                    return
                }
            }
            // Ohter handle http methods
        }
        
        // Step 8: resume url session task
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard error == nil, let data = data, let response = response as? HTTPURLResponse else {
                completion(.failure(.networkError(error)))
                return
            }
            
            if response.statusCode == 401 {
                self.updateAccessToken(request: request, completion: completion)
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(.badRequest(data)))
                return
            }
            
            guard let parsedData = try? JSONDecoder().decode(Response.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(parsedData))
        }.resume()
    }
    
    private func updateAccessToken<Response: Decodable>(request: URLRequest, completion: @escaping (Result<Response, NetworkError>) -> Void) {
        // MARK: 리프레시 토큰 자체가 없는 경우(로그인 시 리프레시 토큰이 제대로 저장되지 않거나 로그인을 하지 않은 상태)
        guard let refreshToken = UserService.shared.getRefreshToken() else {
            // TODO: 로그인 화면으로 이동
            completion(.failure(.notAuthenticated))
            return
        }
        
        fetch(
            .POST,
            "/auth/refresh",
            nil,
            Components.Schemas.InputRefreshToken(refreshToken: refreshToken))
        {  (result: Result<Components.Schemas.AuthToken, NetworkError>) in
            switch result {
            case .success(let updatedToken):
                Task {
                    let result = await UserService.shared.setUser(accessToken: updatedToken.accessToken, refreshToken: updatedToken.refreshToken)
                    
                    guard result else {
                        // MARK: 갱신에는 성공했지만 제대로 유저를 세팅하지 못한 경우(다시 로그인 하는게 좋겠음)
                        // TODO: 로그인 화면으로 이동
                        completion(.failure(.notAuthenticated))
                        return
                    }
                    
                    // MARK: 인증에 실패한 최초 요청을 토큰 갱신 후 다시 처리
                    var reRequest = request
                    let updatedAccessToken = updatedToken.accessToken
                    reRequest.setValue( "Bearer \(updatedAccessToken)", forHTTPHeaderField: "Authorization")
                    
                    URLSession.shared.dataTask(with: request) {(data, response, error) in
                        guard error == nil, let data = data, let response = response as? HTTPURLResponse else {
                            completion(.failure(.networkError(error)))
                            return
                        }
                        
                        guard (200...299).contains(response.statusCode) else {
                            completion(.failure(.badRequest(data)))
                            return
                        }
                        
                        guard let parsedData = try? JSONDecoder().decode(Response.self, from: data) else {
                            completion(.failure(.decodingError))
                            return
                        }
                        
                        completion(.success(parsedData))
                        return
                    }.resume()
                }
                
                // MARK: 리프레시 토큰도 만료돼서 갱신을 못하는 경우(로그인을 다시 해야함)
            case .failure:
                // TODO: 로그인 화면으로 이동
                completion(.failure(.notAuthenticated))
                return
            }
        }
        
    }
}


