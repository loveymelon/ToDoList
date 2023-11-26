//
//  AppSignUpNetwork.swift
//  ToDoList
//
//  Created by 김진수 on 2023/11/13.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

class AppSignUpNetwork {
    static let shared = AppSignUpNetwork()
    
    private init() {}
    
    typealias AppSignNetworkCompletion = (Result<Any, NetworkError>) -> Void
    
    let url = "http://ec2-13-209-24-98.ap-northeast-2.compute.amazonaws.com:8080/api/members/checkid"
    
    func fetchId(appSignUp: AppSignUp, completion: @escaping AppSignNetworkCompletion) {
        
        let params = ["memberId" : appSignUp.id]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .responseJSON { response in

            /** 서버로부터 받은 데이터 활용 */
            switch response.result {
            case .success(let data):
                completion(.success(data))
                break
                /** 정상적으로 reponse를 받은 경우 */
            case .failure(let error):
                print(error)
                completion(.failure(.networkingError))
                break
                /** 그렇지 않은 경우 */
            }
        }
    }

    func postUserInfo(appSignUp: AppSignUp, completion: @escaping AppSignNetworkCompletion) {
        
        let url = "http://ec2-13-209-24-98.ap-northeast-2.compute.amazonaws.com:8080/api/members/join"
        let params = ["name" : appSignUp.name, "id" : appSignUp.id, "pw" : appSignUp.pw]

        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .responseJSON { response in

            /** 서버로부터 받은 데이터 활용 */
            switch response.result {
            case .success(let data):
                // accessToken, refreshToken 발급 (keyChain이나 UserDefalut로 데이터 저장)
                completion(.success(data))
                break
                /** 정상적으로 reponse를 받은 경우 */
            case .failure(let error):
                completion(.failure(.dataError))
                break
                /** 그렇지 않은 경우 */
            }
        }
    }
    
}
