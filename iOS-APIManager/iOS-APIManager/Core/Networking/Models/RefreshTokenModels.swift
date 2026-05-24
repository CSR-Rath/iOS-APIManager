//
//  RefreshTokenModels.swift
//  fengshui-ios
//
//  Created by Chhan Sophearith  on 24/5/26.
//

struct RefreshTokenRequestModel: Codable {
    let refreshToken: String
}

struct RefreshTokenResponseModel: Codable {
    let accessToken: String
    let refreshToken: String
}
