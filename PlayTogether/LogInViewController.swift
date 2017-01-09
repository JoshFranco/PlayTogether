//
//  LogInViewController.swift
//  PlayTogether
//
//  Created by mac on 1/9/17.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class LogInViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gif in the login menu
        let imageData = try! Data(contentsOf: Bundle.main.url(forResource: "LoginGif", withExtension: "gif")!)
        self.imageView.image = UIImage.gif(data: imageData)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
