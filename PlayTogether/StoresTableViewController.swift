//
//  StoresTableViewController.swift
//  PlayTogether
//
//  Created by mac on 1/5/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct storeObj{
    let storeName: String
    let storeHours: String
    let storeAdress: String
    
    init(Name: String, Hours: String, Adress: String){
        self.storeName = Name
        self.storeHours = Hours
        self.storeAdress = Adress
    }
}

class StoresTableViewController: UITableViewController {
    
    // MARK: - Properties
    var objs: [GameObj] = []
    let ref = FIRDatabase.database().reference(withPath: "game-objs")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    var user: User!
    
    var stores: [storeObj] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting background image
        let backgroundImageView = UIImageView(image: UIImage(named: "Page.jpg"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubview(toBack: backgroundImageView)
        
        let s1 = storeObj(Name: "Omega Card Games", Hours: "12pm-10pm", Adress: "7610 Schomburg Rd #1, Columbus, GA 31909")
        let s2 = storeObj(Name: "Dragons Eye Games", Hours: "12pm-8pm", Adress: "116 Riverstone Pkwy, Canton, GA 30114")
        let s3 = storeObj(Name: "Dr. No's Comics & Games", Hours: "11am-8pm", Adress: "Blackwell Square Shopping Center, 104, 3372 Canton Rd, Marietta, GA 30066")
        let s4 = storeObj(Name: "Titan Games & Comics", Hours: "11am-8pm", Adress: "2512 Cobb Pkwy SE, Smyrna, GA 30080")
        let s5 = storeObj(Name: "Raven's Nest Games", Hours: "12pm-11pm", Adress: "688 Whitlock Ave NW #400, Marietta, GA 30064")
        
        stores.append(contentsOf: [s1,s2,s3,s4,s5])
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return objs.count
        return stores.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell", for: indexPath) as! StoreTableViewCell
        let currentStore = stores[indexPath.row]
        
        cell.storeLabel?.text = currentStore.storeName
        cell.gameLabel?.text = currentStore.storeAdress
        cell.timeLabel?.text = currentStore.storeHours
        
        
        /*
        if let infoCell = cell as? StoreTableViewCell {
            let gameObj = objs[indexPath.row]
            infoCell.storeLabel.text = gameObj.store
            infoCell.gameLabel.text = gameObj.game
            infoCell.timeLabel.text = gameObj.time
            
            return infoCell
            
        }*/

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "addGame") as? AddStoreViewController {
            let currentStore = stores[indexPath.row]
            let nav = self.navigationController
            
            //vc.gameObj = gameObj
            vc.store = currentStore
            
            nav?.pushViewController(vc, animated:true)
        }
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
