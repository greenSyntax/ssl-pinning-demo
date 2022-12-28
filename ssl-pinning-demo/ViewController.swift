//
//  ViewController.swift
//  ssl-pinning-demo
//
//  Created by Abhishek Ravi on 29/12/22.
//

import UIKit

class ViewController: UIViewController {

    private let GET_API = URL(string: "https://reqres.in/api/users/2")!
    
    //TODO: Change as per your convience
    private lazy var apiClient: APIClient = {
        //return AlmofireAPIClient()
        return URLSessionAPIClient()
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeRequest()
    }

    func makeRequest() {
        apiClient.dataRequest(GET_API) { result in
            switch result {
            case .success(let data):
                print("Success: \(data)")
            case .failure(let error):
                print("Failure: \(error)")
            }
        }
    }

}

