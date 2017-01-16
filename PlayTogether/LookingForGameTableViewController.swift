//
//  GamersTableViewController.swift
//  PlayTogether
//
//  Created by mac on 1/5/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LookingForGameTableViewController: UITableViewController {
    
    // MARK: - Properties
    var objs: [GameObj] = []
    let ref = FIRDatabase.database().reference(withPath: "game-objs")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting background image
        let backgroundImageView = UIImageView(image: UIImage(named: "Page.jpg"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubview(toBack: backgroundImageView)
        
        //set up a observe so we can read from firebase
        ref.queryOrdered(byChild: "game").observe(.value, with:
        { snapshot in
            var newObjs: [GameObj] = []
            
            for item in snapshot.children {
                let gameObj = GameObj(snapshot: item as! FIRDataSnapshot)
                newObjs.append(gameObj)
            }
            self.objs = newObjs
            self.tableView.reloadData()
        })
        
 
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signOutButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Log Out",
                                      message: "Are you sure you want to log out?",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes",
                                     style: .default)
        { action in
            do{
                try FIRAuth.auth()!.signOut()
                self.dismiss(animated: true, completion: nil)
            } catch{
                print(error)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension LookingForGameTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objs.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFGTableViewCell", for: indexPath) as! GamersTableViewCell
        let gameObj = objs[indexPath.row]
        
        cell.gameLabel?.text = gameObj.game
        cell.nameLabel?.text = gameObj.userName
        cell.storeLabel?.text = gameObj.store
        cell.timeLabel?.text = gameObj.time
        cell.countLabel?.text = String(gameObj.playerNum)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailedGameViewController {
            let gameObj = objs[indexPath.row]
            let nav = self.navigationController
            //if let nav = self.navigationController{}
            
            vc.gameObj = gameObj
            vc.email = self.user.email
                        
            nav?.pushViewController(vc, animated:true)
        }
    }
}
