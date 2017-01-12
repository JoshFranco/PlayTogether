//
//  DetailedGameViewController.swift
//  PlayTogether
//
//  Created by mac on 1/11/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class DetailedGameViewController: UIViewController {
    
    var tog = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.tabBarController?.tabBar.isHidden = true
        

    }

    @IBAction func test(_ sender: UIButton) {
        if tog {
            self.tabBarController?.tabBar.isHidden = tog
            tog = false
        } else {
            self.tabBarController?.tabBar.isHidden = tog
            tog = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
