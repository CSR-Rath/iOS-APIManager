//
//  LoginUseCase.swift
//  fengshui-ios
//
//  Created by Sophearath.chhan  on 22/5/26.
//

protocol DemoUseCase {
    func execute(request: DemoRequestModel) async throws -> DemoEntity
}

final class LoginUseCaseImpl: DemoUseCase {
    
    private let repository: DemoRepository
    
    init(repository: DemoRepository) {
        self.repository = repository
    }
    
    func execute(request: DemoRequestModel) async throws -> DemoEntity {
        try await repository.login(request: request)
    }
}
