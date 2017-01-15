//
//  LogInViewController.swift
//  PlayTogether
//
//  Created by mac on 1/9/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import FirebaseAuth

class LogInViewController: UIViewController {
    
    // MARK: - Constants
    let loginToApp = "LoginToApp"
    
    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting background image
        let backgroundImageView = UIImageView(image: UIImage(named: "MainPage.jpg"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubview(toBack: backgroundImageView)
        
        passTextField.isSecureTextEntry = true
        
        //Gif in the login menu
        let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "LoginGif", withExtension: "gif")!)
        self.imageView.image = UIImage.gif(data: imageData)
        
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: self.loginToApp, sender: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // IDK i hate this function...
    }
    
    @IBAction func loginButtPush(_ sender: UIButton) {
        FIRAuth.auth()!.signIn(withEmail: emailTextField.text!,
                               password: passTextField.text!)
        { user, error in
            if error != nil{
                let failAlert = UIAlertController(title: "Login Failed",
                                                  message: "The password or email was incorrect",
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",
                                             style: .default)
                failAlert.addAction(okAction)
                self.present(failAlert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func newUserButtPush(_ sender: UIButton) {
        let alert = UIAlertController(title: "New User Registration",
                                      message: "Register a new user",
                                      preferredStyle: .alert)
        let regAction = UIAlertAction(title: "Register",
                                      style: .default)
        { action in
            let emailField = alert.textFields![0]
            let passField = alert.textFields![1]
            let rePassField = alert.textFields![2]
            
            if passField.text == rePassField.text {
                FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                           password: passField.text!)
                { user, error in
                    if error == nil {
                    FIRAuth.auth()!.signIn(withEmail: self.emailTextField.text!,
                                           password: self.passTextField.text!)
                    }
                    else {
                        let failAlert = UIAlertController(title: "Failed to Register",
                                                          message: "The email or password did not follow the correct format or the email is in use. \n The email must follow this format: example@example.com \n The Password must be at least 6 characters long ",
                                                          preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK",
                                                 style: .default)
                        failAlert.addAction(okAction)
                        self.present(failAlert, animated: true, completion: nil)
                    }
                }
            }
            else{
                let failAlert = UIAlertController(title: "Passwords did not match",
                                                  message: "The passwords did not match, please ensure both passwords match",
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",
                                             style: .default)
                failAlert.addAction(okAction)
                self.present(failAlert, animated: true, completion: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        alert.addTextField { textRePassword in
            textRePassword.isSecureTextEntry = true
            textRePassword.placeholder = "Retype your password"
        }
        
        alert.addAction(regAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}//end of LogInVC

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passTextField.becomeFirstResponder()
        }
        if textField == passTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}//end of LoginVC extension
