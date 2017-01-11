//
//  GamersTableViewController.swift
//  PlayTogether
//
//  Created by mac on 1/5/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LookingForGameTableViewController: UITableViewController {
    
    // MARK: - Properties
    var gamerArray: [(String, String, String, String)] = []
    let ref = FIRDatabase.database().reference(withPath: "game-objs")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    var callUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gamersPath = Bundle.main.path(forResource: "Gamers", ofType: "plist"){
            
            let gamersDict = NSDictionary(contentsOfFile: gamersPath)
            
            if let gamers = gamersDict?.object(forKey: "Gamers") as? [[String : String]]{
                for gamer in gamers {
                    
                    guard let name = gamer["Name"] else{
                        continue
                    }
                    
                    guard let game = gamer["Game"] else {
                        continue
                    }
                    
                    guard let store = gamer["Store"] else{
                        continue
                    }
                    
                    guard let time = gamer["Time"] else{
                        continue
                    }
                    
                    gamerArray.append((name, game, store, time))
                }
            }
            
            
        }
        
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
            
            let gameObj = GameObj(userName: userNameField.text!,
                                  game: gameField.text!,
                                  store: storeField.text!,
                                  time: tiemField.text!,
                                  addedByUser: "nil")
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
        return gamerArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LFGTableViewCell", for: indexPath)
        
        if let infoCell = cell as? GamersTableViewCell {
            let gamer = gamerArray[indexPath.row]
            infoCell.nameLabel.text = gamer.0
            infoCell.gameLabel.text = gamer.1
            infoCell.storeLabel.text = gamer.2
            infoCell.timeLabel.text = gamer.3
            
            return infoCell
        }
        return cell
    }
    
}
