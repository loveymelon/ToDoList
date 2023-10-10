//
//  GoogleLoginNetwork.swift
//  ToDoList
//
//  Created by 김진수 on 2023/10/10.
//

import Foundation
import GoogleSignIn

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
            print(fullName)
        }
    }
}
