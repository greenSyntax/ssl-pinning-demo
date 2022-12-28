//
//  URLSessionAPIClient.swift
//  ssl-pinning-demo
//
//  Created by Abhishek Ravi on 29/12/22.
//

import Foundation

protocol APIClient {
    func dataRequest(_ url: URL, onCompletion: @escaping (_ result: Result<UserResponseModel, Error>) -> Void)
}

class URLSessionAPIClient: APIClient {
    
    func dataRequest(_ url: URL, onCompletion: @escaping (_ result: Result<UserResponseModel, Error>) -> Void) {
        
        guard let request = try? URLRequest(url: url, method: .get) else {
            onCompletion(.failure(AppError.noData))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let err = error {
                onCompletion(.failure(AppError.noData))
                return
            }
            
            DispatchQueue.main.async {
                if let decodedData = try? JSONDecoder().decode(UserResponseModel.self, from: data!) {
                    onCompletion(.success(decodedData))
                } else {
                    onCompletion(.failure(AppError.decodingError))
                }
            }
        }.resume()
    }
    
}
