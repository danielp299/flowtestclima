//
//  ViewController.swift
//  ClimaApp
//
//  Created by Daniel Pernia on 7/19/19.
//  Copyright © 2019 Daniel Pernia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var CurrentCity: UILabel!
    @IBOutlet weak var CurrentWeather: UILabel!
    @IBOutlet weak var CurrentTemp: UILabel!
    @IBOutlet weak var CurrentHumidity: UILabel!
    @IBOutlet weak var TabletOtherCity: UITableView!
    @IBOutlet weak var CurrentIcon: UIImageView!
    
    

    let APPID = "a98e5a2087b1dbb5d0f1255d34f08be0"
    let BaseUrl = "https://api.openweathermap.org/data/2.5/weather"
    let IconBaseURL = "https://openweathermap.org/img/wn/"
    let IconExtURL = "@2x.png"
    let KelvinToCelsius : Float32 = -273.15
    let DetailAviable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Buenos Aires
        var lat : Float = -0.13
        var lon : Float = -51.51
        GetCurrentWeather(lat: lat,lon: lon)
        //print(" Kelvin ti \(GetKelvinToCelsius(Kelvin: "285"))")
    }
    
    @IBAction func OnClickDetailWeather(){
        
        
        //DetailAviable
        if true {
            
            /*
             
             var City:String = ""
             var Weather:String = ""
             var Temp:String = ""
             var Pressure:String = ""
             var Humidity:String = ""
             var Wind:String = ""
             var Visibility:String = ""
             */
            /*
            let DetailController = ViewDetailController()
            
            if let city = defaults.string(forKey: "city") {
                DetailController.City = "Cty ( \(city) )"
            }else{
                DetailController.City = "cty"
            }
            
            if let weather = defaults.string(forKey: "weather") {
                DetailController.Weather = weather
            }else{
                DetailController.Weather = ""
            }
            
            if let temp = defaults.string(forKey: "temp") {
                DetailController.Temp = temp
            }else{
                DetailController.Temp = ""
            }
            
            if let pressure = defaults.string(forKey: "pressure") {
                DetailController.Pressure = pressure
            }else{
                DetailController.Pressure = ""
            }
            
            if let humidity = defaults.string(forKey: "humidity") {
                DetailController.Humidity = humidity
            }else{
                DetailController.Humidity = ""
            }
            
            if let wind = defaults.string(forKey: "wind") {
                DetailController.Wind = wind
            }else{
                DetailController.Wind = ""
            }
            
            if let visivility = defaults.string(forKey: "Visibility") {
                DetailController.Visibility = visivility
            }else{
                DetailController.Visibility = ""
            }
            */
          //  navigationController?.pushViewController(DetailController, animated: true)
        }
        
        
    }
    
    func UpdateWeaterData(IndexCity: String, JsonValue: Dictionary<String, AnyObject>){
        print(JsonValue)
        
        let main = JsonValue["main"] as! Dictionary<String,AnyObject>
        let array = (JsonValue["weather"]! as! NSArray).mutableCopy() as! NSMutableArray
        let weather = array[0] as! Dictionary<String,AnyObject>
        let wind = JsonValue["wind"] as! Dictionary<String,AnyObject>
        
        print(wind)
        
        let defaults = UserDefaults.standard
        defaults.set(weather["main"] as? String, forKey: "\(IndexCity)city")
        defaults.set(weather["description"] as? String, forKey: "\(IndexCity)weather")
        defaults.set(weather["icon"] as? String, forKey: "\(IndexCity)icon")
        
        if let temp = main["temp"] {
            defaults.set(self.GetKelvinToCelsius(Kelvin: String(describing: temp)) , forKey: "\(IndexCity)temp")
        }else{
            print("error temp")
        }
        if let humidity = main["humidity"] {
            defaults.set(String(describing: humidity) , forKey: "\(IndexCity)humidity")
        }else{
            print("error humidity")
        }
        
        if let pressure = main["pressure"] {
            defaults.set(String(describing: pressure), forKey: "\(IndexCity)pressure")
        }else{
            print("error pressure")
        }
        
        if let visibility = JsonValue["visibility"] {
            defaults.set(String(describing: visibility), forKey: "\(IndexCity)visibility")
        }else{
            print("error visibility")
        }
        
        if let windspeed = wind["speed"] {
            defaults.set(String(describing: windspeed), forKey: "\(IndexCity)wind")
        }else{
            print("error windspeed")
        }
        /*
        defaults.set(weather["visivility"] as? String, forKey: "\(IndexCity)visivility")
        defaults.set(weather["pressure"] as? String, forKey: "\(IndexCity)pressure")
        defaults.set(weather["wind"] as? String, forKey: "\(IndexCity)wind")
        */
 }
    
    func UpdateCityPreviewUi(IndexCity: String, JsonValue : Dictionary<String, AnyObject>, imageViewIcon : UIImageView, CityLabel :UILabel, WeatherLabel: UILabel, TempLabel:UILabel, HumidityLabel: UILabel ){
        
        let defaults = UserDefaults.standard
        
        do {
        
            DispatchQueue.main.async { // Correct K
                
                if let city = defaults.string(forKey: "\(IndexCity)city") {
                    CityLabel.text = city
                }else{
                    CityLabel.text = ""
                }
                
                if let weather = defaults.string(forKey: "\(IndexCity)weather") {
                    WeatherLabel.text = weather
                }else{
                    WeatherLabel.text = ""
                }
                
                if let temp = defaults.string(forKey: "\(IndexCity)temp") {
                    TempLabel.text = temp
                }else{
                    TempLabel.text = ""
                }
                
                if let humidity = defaults.string(forKey: "\(IndexCity)humidity") {
                    HumidityLabel.text = humidity
                }else{
                    HumidityLabel.text = ""
                }
            }
            
            
            if let icon = defaults.string(forKey: "\(IndexCity)icon") {
                let url = URL(string: "\(IconBaseURL)\(icon)\(IconExtURL)")!
                self.DownloadImage(from: url,imageView: self.CurrentIcon)
            }
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func DownloadImage(from url: URL, imageView : UIImageView) {
        //print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() {
                imageView.image = UIImage(data:data)!
            }
        }
    }
    
    func GetKelvinToCelsius(Kelvin : String)-> String{
        let KelvinFloat : Float = Float32(Kelvin) as! Float32
        return String(KelvinFloat + KelvinToCelsius)
    }
    
    func GetCurrentWeather(lat: Float, lon: Float){
      //  print("ruta \(urlString)")
        var components = URLComponents(string: BaseUrl)!
        
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat) ),
            URLQueryItem(name: "lon", value: String(lon) ),
            URLQueryItem(name: "APPID", value: APPID)
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            //print(response!)
            
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                
                let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                print("response is ok \(response ?? "NULL")")
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    self.UpdateWeaterData(IndexCity: String("current"), JsonValue: json)
                    self.UpdateCityPreviewUi(IndexCity: String("current"),
                                             JsonValue: json,
                                             imageViewIcon: self.CurrentIcon,
                                             CityLabel: self.CurrentCity,
                                             WeatherLabel: self.CurrentWeather,
                                             TempLabel: self.CurrentTemp,
                                             HumidityLabel: self.CurrentHumidity)
                } catch {
                    print("error json parce")
                }
                
                break
            case 400:
                
                break
            default:
                print("GET request got response \(httpResponse.statusCode)")
            }
            
        })
        
        task.resume()
        
    }


}

