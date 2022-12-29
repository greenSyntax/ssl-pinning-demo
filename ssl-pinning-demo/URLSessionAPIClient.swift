//
//  URLSessionAPIClient.swift
//  ssl-pinning-demo
//
//  Created by Abhishek Ravi on 29/12/22.
//

import Foundation

protocol APIClient {
    func dataRequest(_ url: URL, onCompletion: @escaping (_ result: Result<PostUserModel, Error>) -> Void)
}

class URLSessionAPIClient: NSObject, APIClient {
    
    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    
    private let certificates: [Data] = {
        let url = Bundle.main.url(forResource: "run.mocky.io", withExtension: "cer")!
        let data = try! Data(contentsOf: url)
        return [data]
      }()
    
    func dataRequest(_ url: URL, onCompletion: @escaping (_ result: Result<PostUserModel, Error>) -> Void) {
        
        guard let request = try? URLRequest(url: url, method: .get) else {
            onCompletion(.failure(AppError.noData))
            return
        }
        
        self.session.dataTask(with: request) { data, response, error in
            if let err = error {
                onCompletion(.failure(AppError.unknown(err.localizedDescription)))
                return
            }
            
            DispatchQueue.main.async {
                if let decodedData = try? JSONDecoder().decode(PostUserModel.self, from: data!) {
                    onCompletion(.success(decodedData))
                } else {
                    onCompletion(.failure(AppError.decodingError))
                }
            }
        }.resume()
    }
    
}

extension URLSessionAPIClient: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if let trust = challenge.protectionSpace.serverTrust,
           SecTrustGetCertificateCount(trust) > 0 {
            if let certificate = SecTrustGetCertificateAtIndex(trust, 0) {
                let data = SecCertificateCopyData(certificate) as Data
                
                if certificates.contains(data) {
                    completionHandler(.useCredential, URLCredential(trust: trust))
                    return
                } else {
                    //TODO: Throw SSL Certificate Mismatch
                }
            }
            
        }
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}
