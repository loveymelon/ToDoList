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
protocol KakaoLoginDelegate {
    func loginSuccessValue()
}

//AF.request(url).res
class KakaoLoginNetwork {
    
    static let shared = KakaoLoginNetwork()
    
    private init() {}
    
    var delegate: KakaoLoginDelegate?
    
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
}

