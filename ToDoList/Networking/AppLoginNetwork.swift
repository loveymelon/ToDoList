//
//  AppLoginNetwork.swift
//  ToDoList
//
//  Created by 김진수 on 2023/11/22.
//

import Foundation
import Alamofire
import SwiftyJSON

enum NetworkErrorr: Error {
    case networkingError
    case dataError
    case parseError
}

protocol AppLoginDelegate: AnyObject {
    func loginSuccess()
}

class AppLoginNetwork {
    static let shared = AppLoginNetwork()
    
    private init() {}
    
    weak var delegate: AppLoginDelegate?
    
    typealias AppLoginNetworkCompletion = (Result<Any, NetworkErrorr>) -> Void
    
    let url = "http://ec2-13-209-24-98.ap-northeast-2.compute.amazonaws.com:8080/api/members/login"
    
    func login(appLogin: Login, completion: @escaping AppLoginNetworkCompletion) {
        
        let params = ["memberId" : appLogin.id, "memberPw" : appLogin.pw]
        
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .responseJSON { response in

            /** 서버로부터 받은 데이터 활용 */
            switch response.result {
            case .success(let data):
                let jsonDatas = JSON(data)
                KeyChain.create(key: "accessToken", token: jsonDatas["accessToken"].stringValue)
                KeyChain.create(key: "refreshToken", token: jsonDatas["refreshToken"].stringValue)
                completion(.success(data))
                self.delegate?.loginSuccess()
                break
                /** 정상적으로 reponse를 받은 경우 */
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(.dataError))
                break
                /** 그렇지 않은 경우 */
            }
        }
    }
    
}
