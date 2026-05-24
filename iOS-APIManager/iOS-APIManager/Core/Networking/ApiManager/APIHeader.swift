//
//  HeaderType.swift
//  fengshui-ios
//
//  Created by Sophearath.chhan  on 23/5/26.
//

enum APIHeader {
    
    case `default`
    case authorized
    case custom(HTTPHeaders)
    
    var value: HTTPHeaders {
        switch self {
        case .default:
            return Self.defaultHeaders
            
        case .authorized:
            var headers = Self.defaultHeaders
            
            if let token = TokenStorage.shared.accessToken {
                headers["Authorization"] = "Bearer \(token)"
            }
            
            return headers
            
        case .custom(let headers):
            return headers
        }
    }
    
    private static var defaultHeaders: HTTPHeaders
    {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }
}
