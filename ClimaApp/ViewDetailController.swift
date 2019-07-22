//
//  ViewDetailController.swift
//  ClimaApp
//
//  Created by Daniel Pernia on 7/22/19.
//  Copyright © 2019 Daniel Pernia. All rights reserved.
//

import UIKit

class ViewDetailController: UIViewController {

    
    //var Icon:UIImage = nil
    var City:String = ""
    var Weather:String = ""
    var Temp:String = ""
    var Pressure:String = ""
    var Humidity:String = ""
    var Wind:String = ""
    var Visibility:String = ""
    
    @IBOutlet weak var DetailCity: UILabel!
    @IBOutlet weak var DetailWeather: UILabel!
    @IBOutlet weak var DetailTemp: UILabel!
    @IBOutlet weak var DetailHumidity: UILabel!
    @IBOutlet weak var DetailPressure: UILabel!
    @IBOutlet weak var DetailWind: UILabel!
    @IBOutlet weak var DetailVisibility: UILabel!
    @IBOutlet weak var DetailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        //let IndexCity  = defaults.string(forKey: "Index")
        let IndexCity = "current"
        
        if let city = defaults.string(forKey: "\(String(describing: IndexCity))city") {
            DetailCity?.text = city
        }else{
            DetailCity?.text = ""
        }
        
        if let weather = defaults.string(forKey: "\(String(describing: IndexCity))weather") {
            DetailWeather?.text = weather
        }else{
            DetailWeather?.text = ""
        }
        
        if let temp = defaults.string(forKey: "\(String(describing: IndexCity))temp") {
            DetailTemp?.text = temp
        }else{
            DetailTemp?.text = ""
        }
        
        if let pressure = defaults.string(forKey: "\(String(describing: IndexCity))pressure") {
            DetailPressure?.text = pressure
        }else{
            DetailPressure?.text = ""
        }
        
        if let humidity = defaults.string(forKey: "\(String(describing: IndexCity))humidity") {
            DetailHumidity?.text = humidity
        }else{
            DetailHumidity?.text = ""
        }
        
        if let wind = defaults.string(forKey: "\(String(describing: IndexCity))wind") {
            DetailWind?.text = wind
        }else{
            DetailWind?.text = ""
        }
        
        if let visibility = defaults.string(forKey: "\(String(describing: IndexCity))visibility") {
            DetailVisibility?.text = visibility
        }else{
            DetailVisibility?.text = ""
        }
        
    }
    
}
