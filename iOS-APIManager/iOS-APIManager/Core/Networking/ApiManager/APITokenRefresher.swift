//
//  APITokenRefresher.swift
//  fengshui-ios
//
//  Created by Chhan Sophearith  on 24/5/26.
//

actor APITokenRefresher {
    
    static let shared = APITokenRefresher()
    
    private var isRefreshing = false
    private var waiters: [CheckedContinuation<Void, Error>] = []
    
    func refreshIfNeeded(
        refreshAction: @Sendable @escaping () async throws -> Void
    ) async throws {
        
        if isRefreshing {
            return try await withCheckedThrowingContinuation { continuation in
                waiters.append(continuation)
            }
        }
        
        isRefreshing = true
        
        defer {
            isRefreshing = false
            waiters.removeAll()
        }
        
        do {
            try await refreshAction()
            waiters.forEach { $0.resume() }
        } catch {
            waiters.forEach { $0.resume(throwing: error) }
            throw error
        }
    }
}
