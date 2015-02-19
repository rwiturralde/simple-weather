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
    
    override init() {
        backgroundImageView = UIImageView()
        blurredImageView = UIImageView()
        tableView = UITableView()
        screenHeight = 0.0
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        backgroundImageView = UIImageView()
        blurredImageView = UIImageView()
        tableView = UITableView()
        screenHeight = 0.0
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
     required init(coder aDecoder: NSCoder) {
        backgroundImageView = UIImageView()
        blurredImageView = UIImageView()
        tableView = UITableView()
        screenHeight = 0.0
        super.init(coder: aDecoder)
    }
    
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
        
        var headerFrame: CGRect = UIScreen.mainScreen().bounds
        var inset: CGFloat = 20;
        var temperatureHeight: CGFloat = 110
        var hiloHeight: CGFloat = 40
        var iconHeight: CGFloat = 30
        
        var hiloFrame: CGRect = CGRectMake(inset,
            headerFrame.size.height - hiloHeight,
            headerFrame.size.width - (2 * inset),
            hiloHeight)
        var temperatureFrame: CGRect = CGRectMake(inset,
            headerFrame.size.height - (temperatureHeight + hiloHeight),
            headerFrame.size.width - (2 * inset),
            temperatureHeight)
        var iconFrame: CGRect = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight)
        
        var conditionsFrame: CGRect = iconFrame
        conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10)
        conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10)
        
        
        var header: UIView = UIView(frame: headerFrame)
        header.backgroundColor = UIColor.clearColor()
        self.tableView.tableHeaderView = header
        
        // Temperature label - bottom left
        var temperatureLabel: UILabel = UILabel(frame: temperatureFrame)
        temperatureLabel.backgroundColor = UIColor.clearColor()
        temperatureLabel.textColor = UIColor.whiteColor()
        temperatureLabel.text = "0°"
        temperatureLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 120)
        header.addSubview(temperatureLabel)
        
        // Hi-Lo Label - bottom left
        var hiloLabel: UILabel = UILabel(frame: hiloFrame)
        hiloLabel.backgroundColor = UIColor.clearColor()
        hiloLabel.textColor = UIColor.whiteColor()
        hiloLabel.text = "0° / 0°";
        hiloLabel.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        header.addSubview(hiloLabel)
        
        // City Label - top
        var cityLabel: UILabel = UILabel(frame: CGRectMake(0, 20, self.view.bounds.size.width, 30))
        cityLabel.backgroundColor = UIColor.clearColor()
        cityLabel.textColor = UIColor.whiteColor()
        cityLabel.text = "Loading...";
        cityLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cityLabel.textAlignment = NSTextAlignment.Center
        header.addSubview(cityLabel)
        
        // Conditions Label
        var conditionsLabel: UILabel = UILabel(frame: conditionsFrame)
        conditionsLabel.backgroundColor = UIColor.clearColor()
        conditionsLabel.text = "Clear"
        conditionsLabel.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        conditionsLabel.textColor = UIColor.whiteColor()
        header.addSubview(conditionsLabel)
        
        // bottom left
        var iconView: UIImageView = UIImageView(frame: iconFrame)
        iconView.image = UIImage(named: "weather-clear")
        iconView.contentMode = UIViewContentMode.ScaleAspectFit
        iconView.backgroundColor = UIColor.clearColor()
        header.addSubview(iconView)

        
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
        var cell: UITableViewCell? = (tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        
        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        cell!.backgroundColor = UIColor(white: 0, alpha: 0.2)
        cell!.textLabel?.textColor = UIColor.whiteColor()
        cell!.detailTextLabel?.textColor = UIColor.whiteColor()
        
        // TODO: Setup the cell
        
        
        return cell!
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var bounds: CGRect = self.view.bounds
        
        self.backgroundImageView.frame = bounds
        self.blurredImageView.frame = bounds
        self.tableView.frame = bounds
        
    }
}

