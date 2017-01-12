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

class StoresTableViewController: UITableViewController {
    
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
        return objs.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreTableViewCell", for: indexPath)

        if let infoCell = cell as? StoreTableViewCell {
            let gameObj = objs[indexPath.row]
            infoCell.storeLabel.text = gameObj.store
            infoCell.gameLabel.text = gameObj.game
            infoCell.timeLabel.text = gameObj.time
            
            return infoCell
            
        }

        return cell
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
