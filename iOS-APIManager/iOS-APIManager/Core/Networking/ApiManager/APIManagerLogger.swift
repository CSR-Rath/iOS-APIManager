//
//  APIManagerLogger.swift
//  fengshui-ios
//
//  Created by Sophearath.chhan  on 24/5/26.
//

import Foundation

enum logDebug{
    case none
    case request
    case response
    case all
}

 extension APIManager {
    
    func logRequest(_ request: URLRequest) {
        
        print("""
        
        ┌──────────────────────── 🚀 REQUEST 🚀 ────────────────────────
        │ URL: \(request.url?.absoluteString ?? "")
        │ Method: \(request.httpMethod ?? "")
        │ Headers:
        │ \(prettyHeaders(request.allHTTPHeaderFields ?? [:]))
        """)
        
        if let body = request.httpBody {
            print("""
            │ Body:
            \(prettyJSON(from: body))
            """)
        }
        
        print("└──────────────────────────────────────────────────────────────────\n")
    }
    
    func logResponse(
        data: Data,
        response: HTTPURLResponse
    ) {
        
        print("""
        
        ┌──────────────────────── ✅ RESPONSE ✅ ────────────────────────
        │ URL: \(response.url?.absoluteString ?? "")
        │ Status Code: \(response.statusCode)
        │ Headers:
        │ \(prettyHeaders(response.allHeaderFields))
        │ Body:
        \(prettyJSON(from: data))
        └──────────────────────────────────────────────────────────────────\n
        """)
    }
    
    func logError(_ error: Error) {
        
        print("""
        
        ┌──────────────────────── ❌ ERROR ❌ ───────────────────────────
        │ \(error.localizedDescription)
        └──────────────────────────────────────────────────────────────────\n
        """)
    }
}

// MARK: - Pretty Print
 extension APIManager {
    
    func prettyJSON(from data: Data) -> String {
        
        guard
            let object = try? JSONSerialization.jsonObject(with: data),
            let prettyData = try? JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted]
            ),
            let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            return String(data: data, encoding: .utf8) ?? "Invalid JSON"
        }
        
        return prettyString
            .split(separator: "\n")
            .map { "│ \($0)" }
            .joined(separator: "\n")
    }
    
    func prettyHeaders(_ headers: [AnyHashable: Any]) -> String {
        headers
            .map { "│ \($0.key): \($0.value)" }
            .joined(separator: "\n")
    }
}

extension APIManager {
    
    func printDecodingError(_ error: DecodingError) {
        switch error {
        case .typeMismatch(let type, let context):
            print("""
            ❌ Type Mismatch
            Type: \(type)
            KeyPath: \(keyPath(from: context.codingPath))
            Description: \(context.debugDescription)
            """)
            
        case .valueNotFound(let type, let context):
            print("""
            ❌ Value Not Found
            Type: \(type)
            KeyPath: \(keyPath(from: context.codingPath))
            Description: \(context.debugDescription)
            """)
            
        case .keyNotFound(let key, let context):
            print("""
            ❌ Key Not Found
            Missing Key: \(key.stringValue)
            KeyPath: \(keyPath(from: context.codingPath))
            Description: \(context.debugDescription)
            """)
            
        case .dataCorrupted(let context):
            print("""
            ❌ Data Corrupted
            KeyPath: \(keyPath(from: context.codingPath))
            Description: \(context.debugDescription)
            """)
            
        @unknown default:
            print("❌ Unknown Decoding Error")
        }
    }
    
    func keyPath(from codingPath: [CodingKey]) -> String {
        codingPath.map { $0.stringValue }.joined(separator: ".")
    }
}
