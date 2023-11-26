//
//  LoginImageFunc.swift
//  ToDoList
//
//  Created by 김진수 on 2023/08/13.
//

import Foundation
import UIKit

struct LoginImageFunc {
    func setLoginImage() -> UIImage {
        var loginImageArray: [UIImage] = []
        
        for i in LoginImageNames.loginImageNames {
            loginImageArray.append(UIImage(named: i)!.applyBlur(radius: 10))
        }
        
        //이미지 애니메이션 추가
        let animatedImage = UIImage.animatedImage(with: loginImageArray, duration: 5)!
        return animatedImage
    }

}
