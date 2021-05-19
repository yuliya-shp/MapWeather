//
//  Manager.swift
//  MapApp
//
//
//

import MapKit

class Manager {
    
    static let shared = Manager()
    private init() {}
    
    let apiKey = "0ad6775cc1bfdbd5d5799d4baf906fc1"
    let apiUrl = "https://api.openweathermap.org/data/2.5/weather?units=metric&"
    
    func getData(coordinates: CLLocationCoordinate2D, completion: @escaping (WeatherModel?) -> ()) {
        
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude
        
        let urlString = "\(apiUrl)lat=\(latitude)&lon=\(longitude)&APPID=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "Get"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil, let data = data {
                do {
                    let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                    completion(weather)
                } catch {
                    completion(nil)
                }
            } else {
                print(error!)
                completion(nil)
            }
        }
        task.resume()
    }
    
}

