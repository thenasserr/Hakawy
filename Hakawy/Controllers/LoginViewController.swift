//
//  ViewController.swift
//  Hakawy
//
//  Created by Ibrahim Nasser Ibrahim on 25/10/2023.
//

import UIKit
import ProgressHUD

class LoginViewController: UIViewController {

  //MARK: - IBOutlets
      //Labels
  @IBOutlet weak var titleOutlet: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var passwordLabel: UILabel!
  @IBOutlet weak var confirmPasswordLabel: UILabel!
  @IBOutlet weak var haveAccLabel: UILabel!

      //TextFields
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!

  //MARK: - Buttons Outlet

  @IBOutlet weak var forgetPasswordButton: UIButton!
  @IBOutlet weak var resendEmailButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var registerButton: UIButton!

  //MARK: - Vars

  var isLogin: Bool = false


  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    setupUI()
    setupBackgroundTap()
  }

  //MARK: - Setup UI

  func setupUI () {
    passwordTextField.isSecureTextEntry = true
    confirmPasswordTextField.isSecureTextEntry = true
    forgetPasswordButton.isHidden = true
    emailLabel.text = ""
    passwordLabel.text = ""
    confirmPasswordLabel.text = ""
    emailTextField.delegate = self
    passwordTextField.delegate = self
    confirmPasswordTextField.delegate = self
  }

  //MARK: - Private Function

  private func updateUIMode(mode: Bool) {

    if !mode {
      titleOutlet.text = "Login"
      confirmPasswordLabel.isHidden = true
      confirmPasswordTextField.isHidden = true
      resendEmailButton.isHidden = true
      haveAccLabel.text = "New Here?"
      registerButton.setTitle("Login", for: .normal)
      loginButton.setTitle("Register", for: .normal)
      forgetPasswordButton.isHidden = false

    } else {
      titleOutlet.text = "Register"
      confirmPasswordLabel.isHidden = false
      confirmPasswordTextField.isHidden = false
      resendEmailButton.isHidden = false
      haveAccLabel.text = "Have an Account?"
      registerButton.setTitle("Register", for: .normal)
      loginButton.setTitle("Login", for: .normal)
      forgetPasswordButton.isHidden = true
    }

    isLogin.toggle()

  }

  //MARK: - Helpers

  private func isDataInputedFor(mode: String) -> Bool {
    switch mode {
    case "login":
      return emailTextField.text != "" && passwordTextField.text != ""
    case "register":
      return emailTextField.text != "" && passwordTextField.text != nil && confirmPasswordTextField.text != ""
    case "forgetPassword":
      return emailTextField.text != ""

    default:
      return false
    }
  }

  //MARK: - Tap Gesture Recognizer

  private func setupBackgroundTap() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    view.addGestureRecognizer(tapGesture)
  }

  @objc func hideKeyboard() {
    view.endEditing(false)
  }

  //MARK: - IBAction

  @IBAction func forgetPasswordPressed(_ sender: UIButton) {
    if isDataInputedFor(mode: "forgetPassword") {
      //TODO:- Reset Password
      forgetPassword()
    } else {
      ProgressHUD.failed("All Fields Is Required")
    }
  }

  @IBAction func resendEmailPressed(_ sender: UIButton) {
    resendVerificationEmail()
  }

  @IBAction func registerbuttonpressed(_ sender: UIButton) {
    if isDataInputedFor(mode: isLogin ? "login" : "register") {
      //TODO:- Regiter or login
      isLogin ? loginUser() : registerUser()

    } else {
      ProgressHUD.failed("All Fields Is Required")
    }
  }

  @IBAction func loginPressed(_ sender: UIButton) {
    updateUIMode(mode: isLogin)
  }


  //MARK: - Register User

  private func registerUser() {
    if passwordTextField.text! == confirmPasswordTextField.text! {
      FirebaseUserListener.shared.registerNewUser(email: emailTextField.text!, password: passwordTextField.text!) { error in
        if error == nil {
          ProgressHUD.succeed("Verification mail sent, Please verify you email and confirm the registration")
        } else{
          ProgressHUD.failed(error?.localizedDescription)
        }
      }
    }
  }

  //MARK: - Login User

  private func loginUser() {
    FirebaseUserListener.shared.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { error, isEmailVerified in
      if error == nil {
        if isEmailVerified {
          //TODO:- to the chat application
          self.goToApp()
          print("success")
        } else {
          ProgressHUD.failed("Please check your email and verify your registration")
        }
      } else {
        ProgressHUD.failed(error!.localizedDescription)
      }
    }
  }

  //MARK: - Resend Verification Method

  func resendVerificationEmail() {
    FirebaseUserListener.shared.resendVerificationEmail(email: emailTextField.text!) { error in
      if error == nil {
        ProgressHUD.succeed("Verification Email sent Succefully")
      } else {
        ProgressHUD.failed(error!.localizedDescription)
      }
    }
  }

  //MARK: - Forget Password

  func forgetPassword() {
    FirebaseUserListener.shared.resetPassword(email: emailTextField.text!) { error in
      if error == nil {
        ProgressHUD.succeed("Reset password email has been sent")
      } else {
        ProgressHUD.failed(error!.localizedDescription)
      }
    }
  }

  //MARK: - Navigation

  func goToApp() {
    let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainView") as! UITabBarController
    mainView.modalPresentationStyle = .fullScreen
    present(mainView, animated: true)
  }
}



extension LoginViewController: UITextFieldDelegate {

  func textFieldDidChangeSelection(_ textField: UITextField) {
    emailLabel.text = emailTextField.hasText ? "Email" : ""
    passwordLabel.text = passwordTextField.hasText ? "Password" : ""
    confirmPasswordLabel.text = confirmPasswordTextField.hasText ? "Confirm Password" : ""
  }
}

