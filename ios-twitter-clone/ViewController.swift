//
//  ViewController.swift
//  ios-twitter-clone
//
//  Created by Mary Xia on 9/26/15.
//  Copyright (c) 2015 Mary Xia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickedLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if (user != nil) {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                
            }
        }
    }
}