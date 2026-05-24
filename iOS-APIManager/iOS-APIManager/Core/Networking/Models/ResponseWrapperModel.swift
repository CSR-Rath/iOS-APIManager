//
//  ResponseWrapperModel.swift
//  fengshui-ios
//
//  Created by Sophearath.chhan on 5/20/26.
//

import Foundation

struct ResponseWrapperModel<T: Codable>: Codable {
    
    let response: ResponseModel?
    let result: T?
    let id: String?
    
    var isSuccess: Bool {
        guard let statusCode = response?.statusCode else {
            return false
        }
        
        return  200 == statusCode //(200...299).contains(statusCode)
    }
}

struct ResponseModel: Codable {
    let message: String?
    let statusCode: Int?
}


