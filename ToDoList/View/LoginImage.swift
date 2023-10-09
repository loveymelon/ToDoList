//
//  LoginImage.swift
//  ToDoList
//
//  Created by 김진수 on 2023/08/10.
//

import UIKit

class LoginImage: UIImageView {
    
    var loginImageName: LoginImageNames = LoginImageNames()
    
    init(loginImageName: LoginImageNames) {
        self.loginImageName = loginImageName
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
