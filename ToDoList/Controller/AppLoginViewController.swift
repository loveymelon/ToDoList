//
//  AppLoginViewController.swift
//  ToDoList
//
//  Created by 김진수 on 2023/11/13.
//

import UIKit

class AppLoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var loginManager = Login()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        uiSetting()
    }
    
    func uiSetting() {
        errorLabel.isHidden = true
        
        self.idTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @IBAction func tappedLoginButton(_ sender: UIButton) {
        //통신성공시
        AppLoginNetwork.shared.login(appLogin: loginManager) { result in
            switch result {
            case .success(let data) :
                self.errorLabel.isHidden = true
//                print(data)
            case .failure(let error) :
                self.errorLabel.isHidden = false
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func tappedSignUpButton(_ sender: UIButton) {
        if let appSignUpVC = storyboard?.instantiateViewController(identifier: "AppSignUpViewController") as? AppSignUpViewController {
            present(appSignUpVC, animated: true)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AppLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.idTextField, self.idTextField.text != "" {
            loginManager.id = textField.text
            passwordTextField.becomeFirstResponder()
        }
        if textField == self.passwordTextField, self.passwordTextField.text != "" {
            loginManager.pw = textField.text
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
