//
//  AlamofireAPIClient.swift
//  ssl-pinning-demo
//
//  Created by Abhishek Ravi on 29/12/22.
//

import Foundation
import Alamofire

struct Certificates {
    
    static let certificate: SecCertificate = Certificates.certificate(filename: "run.mocky.io")
    
    private static func certificate(filename: String) -> SecCertificate {
        let filePath = Bundle.main.path(forResource: filename, ofType: "cer")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let certificate = SecCertificateCreateWithData(nil, data as CFData)!
        
        return certificate
    }
}

class AlmofireAPIClient: APIClient {
    
    private var isSSLPinningEnabled = true
    private var session: Session = AF
    private let certificates = [
        "run.mocky.io":
            PinnedCertificatesTrustEvaluator(certificates: [Certificates.certificate],
                                             acceptSelfSignedCertificates: false,
                                             performDefaultValidation: true,
                                             validateHost: true)]
    
    
    init(sslPinningEnabled: Bool) {
        self.isSSLPinningEnabled = sslPinningEnabled
        
        if isSSLPinningEnabled {
            let serverTrustPolicy = ServerTrustManager(
                allHostsMustBeEvaluated: true,
                evaluators: certificates)
            
            self.session = Session(serverTrustManager: serverTrustPolicy)
        }
    }
    
    func dataRequest(_ url: URL, onCompletion: @escaping(_ result: Result<PostUserModel, Error>) -> Void) {
        
        self.session.request(url).response { response in
            DispatchQueue.main.async {
                if let data = response.data {
                    if let decodedType = try? JSONDecoder().decode(PostUserModel.self, from: data) {
                        onCompletion(.success(decodedType))
                    } else {
                        onCompletion(.failure(AppError.decodingError))
                    }
                } else {
                    if let err = response.error {
                        onCompletion(.failure(AppError.unknown(err.localizedDescription)))
                    } else if response.error?.isServerTrustEvaluationError {
                        
                    } else {
                        onCompletion(.failure(AppError.noData))
                    }
                }
            }
        }
    }
}
