//
//  ViewController.swift
//  ToDoList
//
//  Created by 김진수 on 2023/08/07.
//

import UIKit
import KakaoSDKUser
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginImageVIew: UIImageView!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    
    var loginImage = LoginImageFunc()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLoginImageView()
    }

    func setLoginImageView() {
        self.loginImageVIew.image = loginImage.setLoginImage()
    }
    
    @IBAction func googleButtonTapped(_ sender: GIDSignInButton) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
        }
    }
    
    @IBAction func kakaoButtonTapped(_ sender: UIButton) {
        if UserApi.isKakaoTalkLoginAvailable() {
            KakaoLoginNetwork.shared.loginWithApp()
        } else {
            KakaoLoginNetwork.shared.loginWithWeb()
        }
    }
    
}

extension UIImage {
    //image blur 처리
    func applyBlur(radius: CGFloat) -> UIImage {
            let context = CIContext()
            guard let ciImage = CIImage(image: self),
                  let clampFilter = CIFilter(name: "CIAffineClamp"),
                  let blurFilter = CIFilter(name: "CIGaussianBlur") else {
                return self
            }
            
            clampFilter.setValue(ciImage, forKey: kCIInputImageKey)
            
            blurFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
            blurFilter.setValue(radius, forKey: kCIInputRadiusKey)
            guard let output = blurFilter.outputImage,
                  let cgimg = context.createCGImage(output, from: ciImage.extent) else {
                return self
            }
            return UIImage(cgImage: cgimg)
        }
    
}

