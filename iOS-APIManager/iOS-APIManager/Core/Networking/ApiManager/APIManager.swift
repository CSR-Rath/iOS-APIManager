//
//  APIManager.swift
//  fengshui-ios
//
//  Created by Sophearath.chhan on 5/20/26.
//

import Foundation

final class APIManager {
    
    static let shared = APIManager()
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let logDebug: logDebug = .all
    
    private init() {}
    
    func request<T: Decodable>(
        body: APIRequestBody? = nil,
        method: HTTPMethod = .get,
        endpoint: APIEndpoint,
        header: APIHeader = .authorized,
        queryParams: QueryParams = [:],
        retryCount: Int = 0
    ) async throws -> T {
        
        let urlRequest = try buildRequest(
            method: method,
            endpoint: endpoint,
            body: body,
            header: header,
            queryParams: queryParams
        )
        
        // MARK: - Check request log
        if logDebug == .all || logDebug == .request{
            logRequest(urlRequest)
        }
       
        do {
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            

            // MARK: Handler refresh token
            if httpResponse.statusCode == 401 {
                
                if endpoint == .myAPIRefresh {
                    TokenStorage.shared.clearTokens()
//                    AppNavigator.shared.setRoot(.home)
                    throw APIError.unauthorized
                }
                
                return try await handleUnauthorized(
                    body: body,
                    method: method,
                    endpoint: endpoint,
                    header: header,
                    queryParams: queryParams,
                    retryCount: retryCount
                )
            }
            
            // MARK: - Check response log
            if logDebug == .all || logDebug == .response{
                logResponse(data: data, response: httpResponse)
            }
            
            try validateStatusCode(httpResponse.statusCode)
            
            // MARK: - Handle case 200...299
            do {
                return try decoder.decode(T.self, from: data)
            } catch let error as DecodingError {
                printDecodingError(error)
                throw APIError.decodingFailed
            } catch {
                print("❌ Decode Error: \(error)")
                throw APIError.decodingFailed
            }
            
        } catch let error as URLError {
            throw mapURLError(error)
        }
    }
    
}

// MARK: - Refresh Token
private extension APIManager {
    
    func handleUnauthorized<T: Decodable>(
        body: APIRequestBody?,
        method: HTTPMethod,
        endpoint: APIEndpoint,
        header: APIHeader,
        queryParams: QueryParams,
        retryCount: Int
    ) async throws -> T {
        
        guard retryCount < 1 else {
            TokenStorage.shared.clearTokens()
            throw APIError.unauthorized
        }
        
        do {
            try await APITokenRefresher.shared.refreshIfNeeded {
                try await self.refreshAccessToken()
            }
            
            return try await request(
                body: body,
                method: method,
                endpoint: endpoint,
                header: .authorized,
                queryParams: queryParams,
                retryCount: retryCount + 1
            )
            
        } catch {
            TokenStorage.shared.clearTokens()
            throw APIError.unauthorized
        }
    }
    
    func refreshAccessToken() async throws {
        
        guard let refreshToken = TokenStorage.shared.refreshToken else {
            throw APIError.unauthorized
        }
        
        let response: RefreshTokenResponseModel = try await request(
            body: .parameters([
                "refreshToken" : refreshToken
            ]),
            method: .post,
            endpoint: .myAPIRefresh,
            header: .default,
            retryCount: 1
        )
        
        TokenStorage.shared.accessToken = response.accessToken
        TokenStorage.shared.refreshToken = response.refreshToken
    }
}

// MARK: - Build Request

private extension APIManager {
    
    func buildRequest(
        method: HTTPMethod,
        endpoint: APIEndpoint,
        body: APIRequestBody?,
        header: APIHeader,
        queryParams: QueryParams
    ) throws -> URLRequest {
        
        let baseURL = ""
        
        var components = URLComponents(
            string: baseURL + endpoint.rawValue
        )
        
        
        if !queryParams.isEmpty {
            components?.queryItems = queryParams.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = 60
        
        header.value.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let body {
            request.httpBody = try encodeBody(body)
        }
        
        return request
    }
    
    func encodeBody(_ body: APIRequestBody) throws -> Data {
        switch body {
        case .encodable(let encodable):
            return try encoder.encode(encodable)
            
        case .parameters(let parameters):
            return try JSONSerialization.data(withJSONObject: parameters)
        }
    }
}

// MARK: - Error Handling

private extension APIManager {
    
    func validateStatusCode(_ statusCode: Int) throws {
        switch statusCode {
        case 200...299:
            return
            
        case 401:
            
            throw APIError.unauthorized
            
        case 403:
            throw APIError.forbidden
            
        case 408:
            throw APIError.timeout
            
        case 500...599:
            throw APIError.serverError(statusCode)
            
        default:
            
            throw APIError.unknown
        }
    }
    
    func mapURLError(_ error: URLError) -> APIError {
        switch error.code {
        case .notConnectedToInternet:
           
            return .noInternet
            
        case .timedOut:
            return .timeout
            
        default:
            return .custom(error.localizedDescription)
        }
    }
}
