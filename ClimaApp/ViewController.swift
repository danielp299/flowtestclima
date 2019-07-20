//
//  ViewController.swift
//  ClimaApp
//
//  Created by Daniel Pernia on 7/19/19.
//  Copyright © 2019 Daniel Pernia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let APPID = ""
    let BaseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Buenos Aires
        GetCurrentWeather(CityCode: "Buenos Aires,AR")
    }
    
    func GetCurrentWeather(CityCode : String){
        
        
      //  print("ruta \(urlString)")
        var components = URLComponents(string: BaseUrl)!
        
        components.queryItems = [
            URLQueryItem(name: "q", value: CityCode ),
            URLQueryItem(name: "APPID", value: APPID)
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            
            guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                else {
                    print("error: not a valid http response")
                    return
            }
            
            switch (httpResponse.statusCode)
            {
            case 200:
                
                let response = NSString (data: receivedData, encoding: String.Encoding.utf8.rawValue)
                print("response is \(response ?? "NULL")")
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

