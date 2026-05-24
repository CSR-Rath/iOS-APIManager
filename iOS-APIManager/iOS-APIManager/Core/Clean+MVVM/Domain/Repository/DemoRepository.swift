//
//  LoginRepository.swift
//  fengshui-ios
//
//  Created by Sophearath.chhan  on 22/5/26.
//



protocol DemoRepository {
    func login(request: DemoRequestModel) async throws -> DemoEntity
}
