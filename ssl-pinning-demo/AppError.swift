//
//  AppError.swift
//  ssl-pinning-demo
//
//  Created by Abhishek Ravi on 29/12/22.
//

import Foundation

enum AppError: Error {
    case noData
    case decodingError
    case unknown(String)
}
