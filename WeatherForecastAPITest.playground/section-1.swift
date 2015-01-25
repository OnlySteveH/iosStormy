// Playground - noun: a place where people can play

import UIKit

let apiKey = "d0bbfb359e73a19d161686e885d73d68"


let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")


let forecastURL = NSURL(string: "52.438,1.390", relativeToURL: baseURL)
forecastURL!


let weatherData = NSData(contentsOfURL: forecastURL!, options: nil, error: nil)

println(weatherData)

let languages = ["iOS": "Swift", "Android": "Java"]
languages["iOS"]







