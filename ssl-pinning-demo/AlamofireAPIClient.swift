//
//  AlamofireAPIClient.swift
//  ssl-pinning-demo
//
//  Created by Abhishek Ravi on 29/12/22.
//

import Foundation
import Alamofire

class AlmofireAPIClient: APIClient {
    
    let client = AF.session
    
    init() {}
    
    func dataRequest(_ url: URL, onCompletion: @escaping(_ result: Result<UserResponseModel, Error>) -> Void) {
        
        AF.request(url).response { response in
            DispatchQueue.main.async {
                if let data = response.data {
                    if let decodedType = try? JSONDecoder().decode(UserResponseModel.self, from: data) {
                        onCompletion(.success(decodedType))
                    } else {
                        onCompletion(.failure(AppError.decodingError))
                    }
                } else {
                    onCompletion(.failure(AppError.noData))
                }
            }
        }
        
    }
}
