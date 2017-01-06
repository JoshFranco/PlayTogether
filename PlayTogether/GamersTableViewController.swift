//
//  GamersTableViewController.swift
//  PlayTogether
//
//  Created by mac on 1/5/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class GamersTableViewController: UITableViewController {
    
    var gamerArray: [(String, String, String, String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return gamerArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GamersTableViewCell", for: indexPath)

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
