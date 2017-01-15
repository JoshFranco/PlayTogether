//
//  AddStoreViewController.swift
//  PlayTogether
//
//  Created by mac on 1/11/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import Social
import FirebaseAuth
import FirebaseDatabase

class AddStoreViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var storeLabel: UITextField!
    @IBOutlet weak var gameLabel: UITextField!
    @IBOutlet weak var timeLabel: UITextField!
    @IBOutlet weak var adressLabel: UILabel!
    
    // MARK: - Properties
    let ref = FIRDatabase.database().reference(withPath: "game-objs")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    var user: User!
    
    var store:storeObj? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adressLabel.text = store?.storeName
        
        //set up user so that the email can be rerived from the firebase
        FIRAuth.auth()!.addStateDidChangeListener{
            auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
    }

    @IBAction func addStoreButton(_ sender: UIButton) {
        
        if (userNameLabel.text == "" && storeLabel.text == "" && gameLabel.text == "" && timeLabel.text == "") {
            let alert = UIAlertController(title: "Post Error", message: "Please enter the mandatory values", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (userNameLabel.text == ""){
            let alert = UIAlertController(title: "Post Error", message: "Please enter the user name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        /*else if (storeLabel.text == ""){
            let alert = UIAlertController(title: "Post Error", message: "Please enter a game", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }*/
        else if (gameLabel.text == ""){
            let alert = UIAlertController(title: "Post Error", message: "Please enter a game", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (timeLabel.text == ""){
            let alert = UIAlertController(title: "Post Error", message: "Please enter time", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            
            let gameObj = GameObj(userName: userNameLabel.text!,
                                  game: gameLabel.text!,
                                  store: (store?.storeName)!,
                                  time: timeLabel.text!,
                                  addedByUser: self.user.email)
            
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(self.userNameLabel.text!){
                    print("user exists")
                    let failAlert = UIAlertController(title: "Game Already Exists",
                                                      message: "A Game with that Title already exists, plz change the username of the game",
                                                      preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK",
                                                 style: .default)
                    failAlert.addAction(okAction)
                    self.present(failAlert, animated: true, completion: nil)
                }else{
                    print("user does not exist")
                    let gameObjRef = self.ref.child((self.userNameLabel.text?.lowercased())!)
                    gameObjRef.setValue(gameObj.toAnyObject())
                    let alert = UIAlertController(title: "Game has been created",
                                                      message: "Your game has been created!!!",
                                                      preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    { _ in
                        _ = self.navigationController?.popViewController(animated: true)
                        
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            })
            
            
            
        }
    }
    
    @IBAction func fbPost(_ sender: UIButton) {
        
        if (storeLabel.text == "" || gameLabel.text == "") {
            let alert = UIAlertController(title: "Post Error", message: "Please enter the Store and Game values", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
                let fbController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                fbController?.setInitialText("I will be playing " + gameLabel.text! + " at " + storeLabel.text!)
                present(fbController!, animated: true, completion: nil)
            } else{
                let alert = UIAlertController(title: "Accounts", message: "Please login to your facebook account", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (UIAlertAction) in
                    let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsURL {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    
                }))
                present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func twPost(_ sender: UIButton) {
        if (storeLabel.text == "" || gameLabel.text == "") {
            let alert = UIAlertController(title: "Post Error", message: "Please enter the Store and Game values", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
                let tweetController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                tweetController?.setInitialText("I will be playing " + gameLabel.text! + " at " + storeLabel.text!)
                present(tweetController!, animated: true, completion: nil)
            } else{
                let alert = UIAlertController(title: "Accounts", message: "Please login to your twitter account", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    (UIAlertAction) in
                    let settingsURL = URL(string: UIApplicationOpenSettingsURLString)
                    if let url = settingsURL {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    
                }))
                present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
