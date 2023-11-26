//
//  TokenNetwork.swift
//  ToDoList
//
//  Created by 김진수 on 11/24/23.
//

import Foundation
import Alamofire
import SwiftyJSON

class MyRequestInterceptor: RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix("api 요청 사이트의 공통 주소") == true,
              let accessToken = KeyChain.read(key: "accessToken") else {
            completion(.success(urlRequest))
            return
        }
        
        var urlRequest = urlRequest
        urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        let url = "호출할 api 주소"
        let headers: HTTPHeaders = [
            "Authorization" : String(describing: KeyChain.read(key: "refreshToken"))
        ]
    
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            let data = response.data
            let jsonDatas = JSON(data!)
            
            switch response.result{
            case .success(_):
                KeyChain.delete(key: "accessToekn")
                KeyChain.delete(key: "refreshToken")
                KeyChain.create(key: "accessToken", token: jsonDatas["accessToken"].stringValue)
                KeyChain.create(key: "refreshToken", token: jsonDatas["refreshToken"].stringValue)
                completion(.retry)
            case .failure(let error):
                completion(.doNotRetryWithError(error))
            }
        }
        
    }
}
