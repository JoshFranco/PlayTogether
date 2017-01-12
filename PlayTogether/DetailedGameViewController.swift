//
//  DetailedGameViewController.swift
//  PlayTogether
//
//  Created by mac on 1/12/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class DetailedGameViewController: UIViewController {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var user = ""
    var game = ""
    var store = ""
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.tabBar.isHidden = true
        
        userLabel.text = user
        gameLabel.text = game
        storeLabel.text = store
        timeLabel.text = time
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptButt(_ sender: UIButton) {
    }

}
