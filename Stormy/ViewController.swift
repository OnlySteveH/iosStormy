//
//  ViewController.swift
//  Stormy
//
//  Created by Steve Hunter on 23/01/2015.
//  Copyright (c) 2015 Big Dog Consultants Ltd. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    private let apiKey = "d0bbfb359e73a19d161686e885d73d68"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshActivityIndicator.hidden = true
        getCurrentWeatherData()
        
    }
    
    func getCurrentWeatherData() -> Void {
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        
        let forecastURL = NSURL(string: "52.438297,1.390112", relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(forecastURL!, completionHandler: { (location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
            if (error == nil) {
                let dataObject = NSData(contentsOfURL: location)
                let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                let currentWeather = Current(weatherDictionary: weatherDictionary)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.temperatureLabel.text = "\(currentWeather.temperature)"
                    self.iconView.image = currentWeather.icon!
                    self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                    self.humidityLabel.text = "\(currentWeather.humidity)"
                    self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                    self.summaryLabel.text = "\(currentWeather.summary)"
                    self.refreshButton.hidden = false
                    self.refreshActivityIndicator.hidden = true
                    self.refreshActivityIndicator.stopAnimating()
                    
                })
            } else {
                // there's an error
                println(error)
                let networkIssueController = UIAlertController(title: "Error", message: "Unable to load data", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "Error", style: .Default, handler: nil)
                let cancelButton = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                networkIssueController.addAction(okButton)
                networkIssueController.addAction(cancelButton)
                self.presentViewController(networkIssueController, animated: true, completion: nil)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.refreshButton.hidden = false
                    self.refreshActivityIndicator.hidden = true
                    self.refreshActivityIndicator.stopAnimating()
                })
            }
        })
        downloadTask.resume()
    }
    
    @IBAction func refresh(sender: AnyObject) {
        getCurrentWeatherData()
        refreshButton.hidden = true
        refreshActivityIndicator.hidden = false
        refreshActivityIndicator.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

