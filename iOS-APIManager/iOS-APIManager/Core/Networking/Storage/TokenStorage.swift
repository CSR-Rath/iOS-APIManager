//
//  TokenStorage.swift
//  fengshui-ios
//
//  Created by Sophearath.chhan  on 22/5/26.
//

import Foundation
import Security

final class TokenStorage {
    
    static let shared = TokenStorage()
    private init() {}
    
    private let service = Bundle.main.bundleIdentifier ?? "com.yourapp.auth"
    
    private let accessTokenAccount = "access_token"
    private let refreshTokenAccount = "refresh_token"
    
    var accessToken: String? {
        get { readToken(account: accessTokenAccount) }
        set {
            if let token = newValue {
                saveToken(token, account: accessTokenAccount)
            } else {
                deleteToken(account: accessTokenAccount)
            }
        }
    }
    
    var refreshToken: String? {
        get { readToken(account: refreshTokenAccount) }
        set {
            if let token = newValue {
                saveToken(token, account: refreshTokenAccount)
            } else {
                deleteToken(account: refreshTokenAccount)
            }
        }
    }
    
    func clearTokens() {
        accessToken = nil
        refreshToken = nil
    }
}


// MARK: - Keychain

private extension TokenStorage {
    
    func saveToken(_ token: String, account: String) {
        guard let data = token.data(using: .utf8) else { return }
        
        deleteToken(account: account)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            print("❌ Failed to save token:", status)
        }
    }
    
    func readToken(account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard
            status == errSecSuccess,
            let data = item as? Data,
            let token = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        
        return token
    }
    
    func deleteToken(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        SecItemDelete(query as CFDictionary)
    }
}
