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
    case badRequest
    case decodingError
    case notAuthenticated
}

enum HttpMethod: String {
    case POST
    case GET
    // Ohter http methods
}

struct LoginResponse: Codable {
    let success: Bool
}

final class APIService {
    static let shared = APIService()
    static let client: Client = Client(serverURL: Config.apiURL, transport: URLSessionTransport())
    
    
    private lazy var request = {
        var request = URLRequest(url: Config.apiURL)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // 요청타입: JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // 응답타입: JSON
        // request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization") // JWT 토큰
        
        return request
    }()
    
    func fetch<Response: Decodable>(_ method: HttpMethod, _ params: [String: String]? = nil , _ body: Encodable? = nil, completion: @escaping (Result<Response, NetworkError>) -> Void) {
        request.httpMethod = method.rawValue
        
        if let params = params {
            Config.apiURLComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        switch(method) {
        case .GET:
            break
        case .POST:
            if let body = body {
                if let jsonData = try? JSONEncoder().encode(body) {
                    request.httpBody = jsonData
                } else {
                    print("Failed to encode body into JSON")
                }
            }
            // Ohter handle http methods
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (response as? HTTPURLResponse)?.statusCode == 401 {
                completion(.failure(.notAuthenticated))
                return
            }
            
            // response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode
            guard let data = data, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion(.failure(.badRequest))
                return
            }
            
            // TODO: 어떤 타입으로 파싱할거냐...
            guard let parsedData = try? JSONDecoder().decode(Response.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(parsedData))
        }.resume()
    }
}


