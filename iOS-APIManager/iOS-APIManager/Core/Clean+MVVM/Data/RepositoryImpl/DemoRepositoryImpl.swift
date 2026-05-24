//
//  LoginRepositoryImpl.swift
//  fengshui-ios
//
//  Created by Chhan Sophearith  on 22/5/26.
//


final class DemoRepositoryImpl: DemoRepository {
    
    private let service: DemoService
    
    init(service: DemoService) {
        self.service = service
    }
    
    func login(request: DemoRequestModel) async throws -> DemoEntity {
        try await service.login(request: request)
    }
}
