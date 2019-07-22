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
    @IBOutlet weak var CurrentButtonDetail: UIButton!
    @IBOutlet weak var TabletOtherCity: UITableView!
    @IBOutlet weak var CurrentIcon: UIImageView!
    
    

    let APPID = ""
    let BaseUrl = "https://api.openweathermap.org/data/2.5/weather"
    let IconBaseURL = "https://openweathermap.org/img/wn/"
    let IconExtURL = "@2x.png"
    let KelvinToCelsius : Float32 = -273.15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Buenos Aires
        var lat : Float = -0.13
        var lon : Float = -51.51
        GetCurrentWeather(lat: lat,lon: lon)
        //print(" Kelvin ti \(GetKelvinToCelsius(Kelvin: "285"))")
    }
    
    /*func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        
        (window?.rootViewController as? MyViewController)?.moc = persistentContainer.viewContext
    }*/
    
    func UpdateCurrentCityUi(JsonValue : Dictionary<String, AnyObject>){
        
        print(JsonValue)
        
        do {
            //let coord = JsonValue["coord"] as! Dictionary<String,AnyObject>
            //print("coord \(coord["lat"]) \(coord["lon"])")
            print("weather \( JsonValue["weather"] )")
            
            let array = (JsonValue["weather"]! as! NSArray).mutableCopy() as! NSMutableArray
            print("array 0 \(array[0])")
            
            let weather = array[0] as! Dictionary<String,AnyObject>
            
            let main = JsonValue["main"] as! Dictionary<String,AnyObject>
            //print("main \(main)")
        
            DispatchQueue.main.async { // Correct K
                self.CurrentCity.text = weather["main"] as? String
                self.CurrentWeather.text = weather["description"] as? String
                
                if let temp = main["temp"] {
                    //print("temp_min main \(temp_min)")
                    self.CurrentTemp.text = self.GetKelvinToCelsius(Kelvin: String(describing: temp))
                }else{
                    print("error temp")
                }
                
                if let humidity = main["humidity"] {
                    //print("temp_max main \(temp_max)")
                    self.CurrentHumidity.text = String(describing: humidity)
                }else{
                    print("error humidity")
                }
            }
            
            if let iconId = weather["icon"] {
                let url = URL(string: "\(IconBaseURL)\(iconId)\(IconExtURL)")!
                print(url)
                self.DownloadImage(from: url)
            }else{
                print("error iconId")
            }
            
            
            
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func DownloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.CurrentIcon.image = UIImage(data: data)
            }
        }
    }
    
    func GetKelvinToCelsius(Kelvin : String)-> String{
        let KelvinFloat : Float = Float32(Kelvin) as! Float
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
                    
                    self.UpdateCurrentCityUi(JsonValue: json)
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

