//
//  NetworkService.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

class NetworkService<T: Codable> {
    typealias completionBlock  = (Result<T, NetworkError>) -> ()
    class func request(router: Router, completion: @escaping completionBlock) {
        var components = URLComponents()
        components.scheme = router.scheme
        components.host = router.host
        components.path = router.path
        components.queryItems = router.parameters
        
        guard let url = components.url else {
            fatalError(Strings.URL_CONSTRUCTION_FAILURE)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = router.method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = router.httpBody {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = jsonData
            }catch (let error) {
                completion(.failure(.other(error.localizedDescription)))
                return
            }
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (responseData, response, error) in
            guard error == nil else {
                completion(.failure(.other(error!.localizedDescription)))
                return
            }
            
            //checking status code
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.other(Strings.UNABLE_TO_TYPECASE_URL_RESPONSE)))
                return
            }
            
            let statusCode = httpResponse.statusCode
            switch (statusCode) {
            case 200:
                guard let data = responseData else {
                    //null data encountered
                    completion(.failure(.noData))
                    return
                }
                
                processResponseData(data, usingCompletionBlock: completion)
            case 404:
                completion(.failure(.notFound))
            case 422:
                completion(.failure(.validationFailed))
            case 500:
                completion(.failure(.internalServerError))
            default:
                completion(.failure(.other(Strings.UNKNOWN_STATUS_CODE(statusCode))))
            }
        }
        
        task.resume()
    }
    
    private class func processResponseData(_ data: Data, usingCompletionBlock completion: @escaping completionBlock) {
        //decode fetched bytes into supplied model
        let decoder = JSONDecoder()
        do {
            let decodedResponse = try decoder.decode(T.self, from:  data)
            //success!!
            completion(.success(decodedResponse))
        }catch (let error) {
            completion(.failure(.other((error.localizedDescription))))
        }
    }
}
