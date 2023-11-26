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
    @IBOutlet weak var appLoginView: UIView!
    
    var loginImage = LoginImageFunc()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setLoginImageView()
        labelAddGesture()
    }

    func setLoginImageView() {
        self.loginImageVIew.image = loginImage.setLoginImage()
    }
    
    func labelAddGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tappedAppLoginView))
        appLoginView.isUserInteractionEnabled = true //view를 위한 touch, press, keyboard 그리고 focus event는 event queue에서 무시하지않게 설정
        appLoginView.addGestureRecognizer(gesture)
    }
    
    @objc func tappedAppLoginView() {
        
        if let appLoginVC = storyboard?.instantiateViewController(withIdentifier: "AppLoginViewController") as? AppLoginViewController {
            navigationController?.pushViewController(appLoginVC, animated: true)
        }
        
    }
    
    @IBAction func googleButtonTapped(_ sender: GIDSignInButton) {
        GoogleLoginNetwork.shared.googleLogin(viewController: self)
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

