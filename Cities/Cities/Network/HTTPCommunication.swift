//
//  CityData.swift
//  Cities
//
//  Created by Евгений Полюбин on 07.08.2021.
//

import UIKit
import CoreLocation

class HTTPCommunication: NSObject {
    var completionHandler: ((Data) -> Void)!
    
    func retrieveWeather(from location: CLLocationCoordinate2D, completionHandler: @escaping ((Data) -> Void)) {
        self.completionHandler = completionHandler
        
        var components = URLComponents(string: "https://api.weather.yandex.ru/v2/forecast?")!
        components.queryItems = [
            URLQueryItem.init(name: "lat", value: "\(location.latitude)"),
            URLQueryItem.init(name: "lon", value: "\(location.longitude)"),
        ]
        guard let url = components.url else {return}
        var request: URLRequest = URLRequest(url: url)
        request.allHTTPHeaderFields = ["X-Yandex-API-Key" : "05861e0f-6d7c-4dd1-a770-2399e284b0ce"]
        
        let session: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let task: URLSessionDownloadTask = session.downloadTask(with: request)
        task.resume()
    }
}

extension HTTPCommunication: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data: Data = try Data(contentsOf: location)
            DispatchQueue.main.async(execute: {
                self.completionHandler(data)
                downloadTask.cancel()
            })
        } catch {
            print("data cannot be retrieved")
        }
    }
}
    
   
