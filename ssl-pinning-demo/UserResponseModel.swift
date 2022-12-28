//
//  UserResponseModel.swift
//  ssl-pinning-demo
//
//  Created by Abhishek Ravi on 29/12/22.
//

import Foundation

public struct UserResponseModel: Codable {
    let data: UserDataModel?
}

public struct UserDataModel: Codable {
    let userId: Int?
    let email: String?
    let firstName: String?
    let lastName: String?
    let avatar: String?
    
    private enum CodingKeys: String, CodingKey {
        case userId = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case avatar
    }
}
