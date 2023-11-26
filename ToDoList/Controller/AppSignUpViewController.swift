//
//  AppSignUpViewController.swift
//  ToDoList
//
//  Created by 김진수 on 2023/11/13.
//

import UIKit

class AppSignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var checkPwTextField: UITextField!
    @IBOutlet weak var idCheckLabel: UILabel!
    @IBOutlet weak var pwCheckLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    var checkId: String?
    var userName: String?
    var checkPw: String?
    var passId: Bool = false
    var passPw: Bool = false
    
    var appSignUp = AppSignUp()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingUI()
        // Do any additional setup after loading the view.
    }
    
    func settingUI() {
        idCheckLabel.isHidden = true
        pwCheckLabel.isHidden = true
        
        nameTextField.delegate = self
        idTextField.delegate = self
        pwTextField.delegate = self
        checkPwTextField.delegate = self
        
        signUpButtonUI()
    }
    
    func signUpButtonUI() {
        if passId && passPw && userName != "" {
            confirmButton.backgroundColor = UIColor(displayP3Red: 175/255, green: 212/255, blue: 133/255, alpha: 1)
            confirmButton.isEnabled = true
        } else {
            confirmButton.backgroundColor = UIColor(displayP3Red: 189/255, green: 189/255, blue: 189/255, alpha: 1)
            confirmButton.isEnabled = false
        }
    }

    @IBAction func tappedDuplicateButton(_ sender: UIButton) {
        //아이디 중복 확인
        AppSignUpNetwork.shared.fetchId(appSignUp: appSignUp) { result in
            switch result {
            case .success(let data) :
                print(data)
                DispatchQueue.main.async {
                    self.idCheckLabel.isHidden = false
                    self.idCheckLabel.text = "사용가능한 아이디 입니다"
                    self.idCheckLabel.textColor = .blue
                    self.passId = true
                    self.signUpButtonUI()
                }
            case .failure(let error) :
                print("bbbbbb")
                DispatchQueue.main.async {
                    self.idCheckLabel.isHidden = false
                    self.idCheckLabel.text = "중복되는 아이디 입니다"
                    self.idCheckLabel.textColor = .red
                    self.passId = false
                    self.signUpButtonUI()
                }
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func tappedSignUpButton(_ sender: UIButton) {
        //서버에 이름, 아이디, 비밀번호 전송
        AppSignUpNetwork.shared.postUserInfo(appSignUp: appSignUp) { result in
            switch result {
            case .success(let data) :
                print(data)
                self.dismiss(animated: true)
            case .failure(let error) :
                print(error.localizedDescription)
                
            }
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

extension AppSignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField, textField.text != "" {
            self.appSignUp.name = textField.text
            idTextField.becomeFirstResponder()
        }
        if textField == idTextField, textField.text != "" {
            self.appSignUp.id = textField.text
            pwTextField.becomeFirstResponder()
        }
        if textField == pwTextField, pwTextField.text != "" {
            self.appSignUp.pw = textField.text
            checkPwTextField.becomeFirstResponder()
        }
        if textField == checkPwTextField, checkPwTextField.text != "" {
            if self.appSignUp.pw != textField.text {
                pwCheckLabel.isHidden = false
                passPw = false
            } else {
                pwCheckLabel.isHidden = true
                passPw = true
            }
            checkPwTextField.resignFirstResponder()
        }
        
        signUpButtonUI()
        
            return true
    }
}
