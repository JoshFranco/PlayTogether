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
    
    @IBAction func tempAddToDatabase(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Temp add to database",
                                      message: "Add an item to the database...",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "SAVE",
                                       style: .default)
        { _ in
            
            let userNameField = alert.textFields![0]
            let gameField = alert.textFields![1]
            let storeField = alert.textFields![2]
            let tiemField = alert.textFields![3]
            
            print(self.user.email)
            
            let gameObj = GameObj(userName: userNameField.text!,
                                  game: gameField.text!,
                                  store: storeField.text!,
                                  time: tiemField.text!,
                                  addedByUser: self.user.email)
            let gameObjRef = self.ref.child((userNameField.text?.lowercased())!)
            gameObjRef.setValue(gameObj.toAnyObject())
            
        }
        
        let cancelAction = UIAlertAction(title: "CANCEL",
                                         style: .default)
        
        alert.addTextField { textUserName in
            textUserName.placeholder = "Enter your User Name"
        }
        alert.addTextField { textGame in
            textGame.placeholder = "Enter the Game Title"
        }
        alert.addTextField { textStore in
            textStore.placeholder = "Enter the Store Location"
        }
        alert.addTextField { textTime in
            textTime.placeholder = "Enter the time of the game"
        }
        
        alert.addAction(saveAction)
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Details") as? DetailedGameViewController {
            let gameObj = objs[indexPath.row]
            let nav = self.navigationController
            //if let nav = self.navigationController{}
            
            vc.game = gameObj.game
            vc.user = gameObj.userName
            vc.store = gameObj.store
            vc.time = gameObj.time
            
            nav?.pushViewController(vc, animated:true)
        }
    }
}
