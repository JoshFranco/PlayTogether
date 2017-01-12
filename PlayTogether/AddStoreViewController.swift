//
//  AddStoreViewController.swift
//  PlayTogether
//
//  Created by mac on 1/11/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class AddStoreViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var storeLabel: UITextField!
    @IBOutlet weak var gameLabel: UITextField!
    @IBOutlet weak var timeLabel: UITextField!
    
    // MARK: - Properties
    let ref = FIRDatabase.database().reference(withPath: "game-objs")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        else if (storeLabel.text == ""){
            let alert = UIAlertController(title: "Post Error", message: "Please enter a game", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
                                  store: storeLabel.text!,
                                  time: timeLabel.text!,
                                  addedByUser: self.user.email)
            let gameObjRef = self.ref.child((userNameLabel.text?.lowercased())!)
            gameObjRef.setValue(gameObj.toAnyObject())
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
