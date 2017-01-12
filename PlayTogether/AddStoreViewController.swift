//
//  AddStoreViewController.swift
//  PlayTogether
//
//  Created by mac on 1/11/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class AddStoreViewController: UIViewController {

    @IBOutlet weak var storeLabel: UITextField!
    @IBOutlet weak var gameLabel: UITextField!
    @IBOutlet weak var descLabel: UITextField!
    @IBOutlet weak var timeLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func addStoreButton(_ sender: UIButton) {
        
        if (storeLabel.text == "" && gameLabel.text == "" && timeLabel.text == "") {
            let alert = UIAlertController(title: "Post Error", message: "Please enter the mandatory values", preferredStyle: UIAlertControllerStyle.alert)
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
            // Add stores into the DB
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
