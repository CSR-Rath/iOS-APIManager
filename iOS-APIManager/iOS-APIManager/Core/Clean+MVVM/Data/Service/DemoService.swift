//
//  LoginService.swift
//  fengshui-ios
//
//  Created by Chhan Sophearith  on 22/5/26.
//

final class DemoService {
    
    func login(request: DemoRequestModel) async throws -> DemoEntity {
        
//        APIManager.shared
        // Call API here
        return DemoEntity(
            token: "mock_token",
            userName: "Sophearath"
        )
    }
}


//View        → UI only
//ViewModel   → Presentation logic
//UseCase     → Business logic
//Repository  → Data abstraction
//Service     → API call
