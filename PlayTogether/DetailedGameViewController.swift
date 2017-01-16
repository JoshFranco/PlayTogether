//
//  DetailedGameViewController.swift
//  PlayTogether
//
//  Created by mac on 1/12/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DetailedGameViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var acceptButt: UIButton!
    @IBOutlet weak var deleteButt: UIButton!
    
    let ref = FIRDatabase.database().reference(withPath: "game-objs")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    var userX: User!
    var listOfPlayers:[String] = []
    var gameObj: GameObj? = nil
    
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting background image
        let backgroundImageView = UIImageView(image: UIImage(named: "Page.jpg"))
        backgroundImageView.frame = view.frame
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        view.sendSubview(toBack: backgroundImageView)

        self.tabBarController?.tabBar.isHidden = true
        
        userLabel.text = gameObj?.userName
        gameLabel.text = gameObj?.game
        storeLabel.text = gameObj?.store
        timeLabel.text = gameObj?.time
        
        listOfPlayers = (gameObj?.playerList.components(separatedBy: "|"))!
        
        hasAccepted()
        
        if gameObj?.addedByUser != email{
            deleteButt.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptButt(_ sender: UIButton) {
        
        let inc = (gameObj?.playerNum)! + 1
        listOfPlayers.append(email)
        let strOfPlayers = listOfPlayers.joined(separator: "|")
            
        gameObj?.ref?.updateChildValues(["playerNum": inc])
        gameObj?.ref?.updateChildValues(["playerList": strOfPlayers])
            
        acceptButt.setTitle("Game Accepted =D", for: .normal)
        acceptButt.isEnabled = false
    }
    
    @IBAction func deleteButt(_ sender: UIButton) {
        print("DELETE")
        gameObj?.ref?.removeValue()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func hasAccepted(){
        
        if listOfPlayers.contains(email){
            acceptButt.setTitle("Game Accepted =D", for: .normal)
            acceptButt.isEnabled = false
        }
    }
}
