//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Roberto Iturralde on 2/17/15.
//  Copyright (c) 2015 Roberto Iturralde. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    let backgroundImageView: UIImageView
    let blurredImageView: UIImageView
    let tableView: UITableView
    let screenHeight: CGFloat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.redColor()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
}

