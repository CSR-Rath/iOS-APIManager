//
//  APIError.swift
//  fengshui-ios
//
//  Created by Sophearath.chhan on 5/20/26.
//

import Foundation

enum APIError: LocalizedError, Equatable {
    
    case invalidURL
    case invalidResponse
    case decodingFailed
    case unauthorized
    case forbidden
    case noInternet
    case timeout
    case serverError(Int)
    case custom(String)
    case unknown
    
    var errorDescription: String? {
        
        switch self {
            
        case .invalidURL:
            return "Invalid URL"
            
        case .invalidResponse:
            return "Invalid server response"
            
        case .decodingFailed:
            return "Failed to decode response"
            
        case .unauthorized:
            return "Unauthorized access"
            
        case .forbidden:
            return "Access denied"
            
        case .noInternet:
            return "No internet connection"
            
        case .timeout:
            return "Request timeout"
            
        case .serverError(let code):
            return "Server error (\(code))"
            
        case .custom(let message):
            return message
            
        case .unknown:
            return "Something went wrong"
        }
    }
}
