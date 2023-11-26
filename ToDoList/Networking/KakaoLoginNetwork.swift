//
//  KakaoLoginNetwork.swift
//  ToDoList
//
//  Created by 김진수 on 2023/09/11.
//

import Foundation
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

// Login완료시 sceneDelegate에서 navigationController의 rootview를 변경
protocol KakaoLoginDelegate: AnyObject {
    func loginSuccessValue()
}

//AF.request(url).res
class KakaoLoginNetwork {
    
    static let shared = KakaoLoginNetwork()
    
    private init() {}
    
    weak var delegate: KakaoLoginDelegate?
    
    func loginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")
                //do something
                self.checkToken()
            }
        }
    }
    
    func loginWithWeb() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoAccount() success.")
                
                //do something
                self.checkToken()
            }
        }
    }
    
    func getUserInfo() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                print("me() success.")
                // bool값
                self.delegate?.loginSuccessValue()
                //do something
                _ = user
                let kakaoInfo = KakaoUserInfo()
                kakaoInfo.registrationId = "kakao"
                kakaoInfo.name = user?.kakaoAccount?.profile?.nickname
                kakaoInfo.id = user?.kakaoAccount?.email
                kakaoInfo.pw = String((user?.id)!)
                kakaoInfo.imageUrl = user?.kakaoAccount?.profile?.profileImageUrl?.absoluteString
                
                self.postUserInfo(kakaoUserInfo: kakaoInfo)
                //서버 성공하면 self.delegate?.loginSuccessValue()
                /*if let url = user?.kakaoAccount?.profile?.profileImageUrl{
                    
                }*/
            }
        }
    }
    
    func checkToken() {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (_, error) in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
                        //로그인 필요
                        //Access 토큰 만료사
                        if UserApi.isKakaoTalkLoginAvailable() {
                            self.loginWithApp()
                        } else {
                            self.loginWithWeb()
                        }
                    }
                    else {
                        //기타 에러
                    }
                }
                else {
                    //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                    self.getUserInfo()
                    print("success")
                }
            }
        }
        else {
            //로그인 필요
            if UserApi.isKakaoTalkLoginAvailable() {
                self.loginWithApp()
            } else {
                self.loginWithWeb()
            }
        } //리프레쉬 토큰 존재 유무 파악이므로 else문에 재로그인 로직 필요
    }
    
    func postUserInfo(kakaoUserInfo: KakaoUserInfo) {
        let url = "http://ec2-13-209-24-98.ap-northeast-2.compute.amazonaws.com:8080/api/members/join"
        let params = ["id" : kakaoUserInfo.id, "pw" : kakaoUserInfo.pw, "name" : kakaoUserInfo.name, "imageUrl" : kakaoUserInfo.imageUrl, "registrationId" : kakaoUserInfo.registrationId] as Dictionary

        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: JSONEncoding(options: []),
                   headers: ["Content-Type":"application/json", "Accept":"application/json"])
            .responseJSON { response in

            /** 서버로부터 받은 데이터 활용 */
            switch response.result {
            case .success(let data):
                self.delegate?.loginSuccessValue()
                print("kakaoSuccess")
                print(data)
                break
                /** 정상적으로 reponse를 받은 경우 */
            case .failure(let error):
                print("kakao errorCode\(error)")
                break
                /** 그렇지 않은 경우 */
            }
        }
        
        
        
    }
}

