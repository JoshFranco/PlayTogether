//
//  LogInViewController.swift
//  PlayTogether
//
//  Created by mac on 1/9/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class LogInViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gif in the login menu
        let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "LoginGif", withExtension: "gif")!)
        self.imageView.image = UIImage.gif(data: imageData)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // IDK i hate this function...
    }
    
    @IBAction func loginButtPush(_ sender: UIButton) {
        //Implement the login feature
    }
    
    @IBAction func newUserButtPush(_ sender: UIButton) {
        let alert = UIAlertController(title: "New User Registration",
                                      message: "Register a new user",
                                      preferredStyle: .alert)
        let regAction = UIAlertAction(title: "Register",
                                      style: .default)
        { action in
            //implement the save feature here
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
