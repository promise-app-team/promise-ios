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
    
    // MARK: client by swift openapi generator
    public let client: Client = Client(serverURL: Config.apiURL, transport: URLSessionTransport())
    
    func fetch<Response: Decodable>(_ method: HttpMethod, _ path: String? = nil, _ params: [String: String]? = nil , _ body: Encodable? = nil, completion: @escaping (Result<Response, NetworkError>) -> Void) {
        
        var url = Config.apiURL
        
        // Step 1: endpoint path setting
        if let path = path {
            url.appendPathComponent(path)
        }
        
        // Step 2: create URLComponents
        guard var urlComponents = URLComponents(string: url.absoluteString) else { return }
        
        // Step 3: query paramenters setting
        if let params = params {
            urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        // Step 4: create URLRequest and URLComponents
        guard let requestUrl = urlComponents.url else { return }
        var request = URLRequest(url: requestUrl)
        
        // Step 5: http header setting
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // 요청타입: JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // 응답타입: JSON
        // request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization") // JWT 토큰
        
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
                    print("Failed to encode body into JSON")
                }
            }
            // Ohter handle http methods
        }
        
        // Step 7: resume url session task
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
            
            guard let parsedData = try? JSONDecoder().decode(Response.self, from: data) else {
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(parsedData))
        }.resume()
    }
}


