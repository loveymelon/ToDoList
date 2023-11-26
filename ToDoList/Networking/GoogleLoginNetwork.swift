//
//  GoogleLoginNetwork.swift
//  ToDoList
//
//  Created by 김진수 on 2023/10/10.
//

import Foundation
import GoogleSignIn
import Alamofire

class GoogleLoginNetwork {
    
    static let shared = GoogleLoginNetwork()
    
    private init() {}
    
    func googleLogin(viewController: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
            guard error == nil else { return }
            
            self.getUserInfo(viewController: viewController)
        }
    }
    
    func getUserInfo(viewController: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            
            let user = signInResult.user
            
            let emailAddress = user.profile?.email
            
            let fullName = user.profile?.name
            let givenName = user.profile?.givenName
            let familyName = user.profile?.familyName
            
            let profilePicUrl = user.profile?.imageURL(withDimension: 320)
            
            let idToken = user.idToken?.tokenString
            self.tokenSignIn(idToken: idToken!)
        }
    }
    
    func tokenSignIn(idToken: String) {
        
        let url = URL(string: "https://yourbackend.example.com/tokensignin")!
        let params = ["idToken": idToken] as Dictionary
        
        
        AF.request(url,
                    method: .post,
                    parameters: params,
                    encoding: JSONEncoding(options: []),
                    headers: ["Content-Type":"application/json", "Accept":"application/json"])
             .responseJSON { response in

             /** 서버로부터 받은 데이터 활용 */
             switch response.result {
             case .success(let data):
                 break
                 
                 /** 정상적으로 reponse를 받은 경우 */
             case .failure(let error): break
                 /** 그렇지 않은 경우 */
             }
         }
    }
}
