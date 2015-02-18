//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Roberto Iturralde on 2/17/15.
//  Copyright (c) 2015 Roberto Iturralde. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    var backgroundImageView: UIImageView
    var blurredImageView: UIImageView
    var tableView: UITableView
    var screenHeight: CGFloat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenHeight = UIScreen.mainScreen().bounds.size.height
        
        var background = UIImage(named: "bg")
        
        self.backgroundImageView = UIImageView(image: background)
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.view.addSubview(self.backgroundImageView)
        
        
        self.blurredImageView = UIImageView()
        self.blurredImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.blurredImageView.alpha = 0
        self.blurredImageView.setImageToBlur(background, blurRadius: 10, completionBlock: nil)
        self.view.addSubview(self.blurredImageView)
        
        self.tableView = UITableView()
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorColor = UIColor(white: 1, alpha: 0.2)
        self.tableView.pagingEnabled = true
        self.view.addSubview(self.tableView)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: return count of forecast
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier: String = "CellIdentifier"
        var cell = UITableViewCell()
        /*cell = tableView.dequeueReusableCellWithIdentifier("CellIdentifier")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor(white: 0, alpha: 0.2)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        // TODO: Setup the cell
        
        */
        return cell
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var bounds: CGRect = self.view.bounds
        
        self.backgroundImageView.frame = bounds
        self.blurredImageView.frame = bounds
        self.tableView.frame = bounds
        
    }
}

