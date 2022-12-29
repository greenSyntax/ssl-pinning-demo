//
//  UserResponseModel.swift
//  ssl-pinning-demo
//
//  Created by Abhishek Ravi on 29/12/22.
//

import Foundation

public struct PostUserModel: Codable {
    let userId: Int?
    let id: Int?
    let title: String?
    let body: String?
}
