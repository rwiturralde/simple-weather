//
//  ViewController.swift
//  SimpleWeather
//
//  Created by Roberto Iturralde on 2/17/15.
//  Copyright (c) 2015 Roberto Iturralde. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, WeatherDelegate {
    
    var backgroundImageView: UIImageView
    var blurredImageView: UIImageView
    var tableView: UITableView
    var screenHeight: CGFloat
    var weatherManager: WXManager
    
    var background: UIImage? = nil
    var temperatureLabel: UILabel? = nil
    var hiloLabel: UILabel? = nil
    var cityLabel: UILabel? = nil
    var conditionsLabel: UILabel? = nil
    var iconView: UIImageView? = nil
    
    var hourlyFormatter: NSDateFormatter
    var dailyFormatter: NSDateFormatter
    
    override init() {
        backgroundImageView = UIImageView()
        blurredImageView = UIImageView()
        tableView = UITableView()
        screenHeight = 0.0
        weatherManager = WXManager()
        hourlyFormatter = NSDateFormatter()
        hourlyFormatter.dateFormat = "h a"
        dailyFormatter = NSDateFormatter()
        dailyFormatter.dateFormat = "EEEE"
        super.init()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        backgroundImageView = UIImageView()
        blurredImageView = UIImageView()
        tableView = UITableView()
        screenHeight = 0.0
        weatherManager = WXManager()
        hourlyFormatter = NSDateFormatter()
        hourlyFormatter.dateFormat = "h a"
        dailyFormatter = NSDateFormatter()
        dailyFormatter.dateFormat = "EEEE"
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
     required init(coder aDecoder: NSCoder) {
        backgroundImageView = UIImageView()
        blurredImageView = UIImageView()
        tableView = UITableView()
        screenHeight = 0.0
        weatherManager = WXManager()
        hourlyFormatter = NSDateFormatter()
        hourlyFormatter.dateFormat = "h a"
        dailyFormatter = NSDateFormatter()
        dailyFormatter.dateFormat = "EEEE"
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.screenHeight = UIScreen.mainScreen().bounds.size.height
        
        background = UIImage(named: "bg")!
        
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
        
        self.weatherManager.delegate = self
        
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
        temperatureLabel = UILabel(frame: temperatureFrame)
        temperatureLabel!.backgroundColor = UIColor.clearColor()
        temperatureLabel!.textColor = UIColor.whiteColor()
        temperatureLabel!.text = "0°"
        temperatureLabel!.font = UIFont(name: "HelveticaNeue-UltraLight", size: 120)
        header.addSubview(temperatureLabel!)
        
        // Hi-Lo Label - bottom left
        hiloLabel = UILabel(frame: hiloFrame)
        hiloLabel!.backgroundColor = UIColor.clearColor()
        hiloLabel!.textColor = UIColor.whiteColor()
        hiloLabel!.text = "0° / 0°";
        hiloLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 28)
        header.addSubview(hiloLabel!)
        
        // City Label - top
        cityLabel = UILabel(frame: CGRectMake(0, 20, self.view.bounds.size.width, 30))
        cityLabel!.backgroundColor = UIColor.clearColor()
        cityLabel!.textColor = UIColor.whiteColor()
        cityLabel!.text = "Loading...";
        cityLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cityLabel!.textAlignment = NSTextAlignment.Center
        header.addSubview(cityLabel!)
        
        // Conditions Label
        conditionsLabel = UILabel(frame: conditionsFrame)
        conditionsLabel!.backgroundColor = UIColor.clearColor()
        conditionsLabel!.text = "Clear"
        conditionsLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        conditionsLabel!.textColor = UIColor.whiteColor()
        header.addSubview(conditionsLabel!)
        
        // bottom left
        iconView = UIImageView(frame: iconFrame)
        iconView!.image = UIImage(named: "weather-clear")
        iconView!.contentMode = UIViewContentMode.ScaleAspectFit
        iconView!.backgroundColor = UIColor.clearColor()
        header.addSubview(iconView!)
        
        //NSLog("Firing weatherManager.findCurrentLocation")

        weatherManager.findCurrentLocation()
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
        if (section == 0) {
            return min(weatherManager.hourlyForecast.count, 6) + 1 // + 1 for header
        }
        return min(weatherManager.dailyForecast.count, 6) + 1 // +1 for header
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier: String = "CellIdentifier"
        var cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: cellIdentifier)
        }
        
        var tableCell: UITableViewCell = cell as UITableViewCell
        
        tableCell.selectionStyle = UITableViewCellSelectionStyle.None
        tableCell.backgroundColor = UIColor(white: 0, alpha: 0.2)
        tableCell.textLabel?.textColor = UIColor.whiteColor()
        tableCell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                self.configureHeaderCell(tableCell, title: "Hourly Forecast")
            } else {
                var weather: WXCondition = weatherManager.hourlyForecast[indexPath.row - 1]
                configureHourlyCell(tableCell, weather: weather)
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                self.configureHeaderCell(tableCell, title: "Daily Forecast")
            } else {
                var weather: WXCondition = weatherManager.dailyForecast[indexPath.row - 1]
                configureDailyCell(tableCell, weather: weather)
            }
        }
        
        return tableCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //var cellCount: NSInteger = tableView.numberOfRowsInSection(indexPath.section)
        var cellCount : NSInteger = 8
        return screenHeight / CGFloat(cellCount)
        
        //return 44
    }
    
    func onLocationChange(currentCondition: WXCondition, dailyConditions: Array<WXCondition>, hourlyConditions: Array<WXCondition>) {
        NSLog("Location notification in ViewController.  New condition: \(currentCondition)")
        temperatureLabel?.text = NSString(format: "%.0f°", currentCondition.temperature)
        conditionsLabel?.text = currentCondition.condition.capitalizedString
        cityLabel?.text = currentCondition.locationName.capitalizedString
        hiloLabel?.text = NSString(format: "%.0f° / %.0f°", currentCondition.tempHigh, currentCondition.tempLow)
        
        iconView?.image = UIImage(named: currentCondition.imageName())
        
        tableView.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var bounds: CGRect = self.view.bounds
        
        self.backgroundImageView.frame = bounds
        self.blurredImageView.frame = bounds
        self.tableView.frame = bounds
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var height: CGFloat = scrollView.bounds.size.height
        var position: CGFloat = max(scrollView.contentOffset.y, 0.0);
        var percent: CGFloat = min(position / height, 1.0);
        self.blurredImageView.alpha = percent;
    }
    
    func configureHeaderCell(cell: UITableViewCell, title: String) -> Void {
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 18)
        cell.textLabel?.text = title;
        cell.detailTextLabel?.text = "";
        cell.imageView?.image = nil;
    }
    
    func configureHourlyCell(cell: UITableViewCell, weather: WXCondition) -> Void {
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        cell.detailTextLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:18)
        cell.textLabel?.text = self.hourlyFormatter.stringFromDate(weather.date)
        cell.detailTextLabel?.text = NSString(format: "%.0f°", weather.temperature)
        cell.imageView?.image = UIImage(named: weather.imageName())
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit

    }
    
    func configureDailyCell(cell: UITableViewCell, weather: WXCondition) -> Void {
        cell.textLabel?.font = UIFont(name:"HelveticaNeue-Light", size:18)
        cell.detailTextLabel?.font = UIFont(name:"HelveticaNeue-Medium", size:18)
        cell.textLabel?.text = self.dailyFormatter.stringFromDate(weather.date)
        cell.detailTextLabel?.text = NSString(format: "%.0f° / %.0f°", weather.tempHigh, weather.tempLow)
        cell.imageView?.image = UIImage(named: weather.imageName())
        cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
}

