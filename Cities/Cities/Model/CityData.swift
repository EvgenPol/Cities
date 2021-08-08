//
//  CityData.swift
//  Cities
//
//  Created by Евгений Полюбин on 07.08.2021.
//

import Foundation
import CoreLocation

protocol CityDataDelegate {
    func locationLoaded(from city: String)
}

struct CityStuff {
    var location: CLLocationCoordinate2D?
    var temp: Int?
    var condition: String?
    var url: String?
    var createdData = false
}

class CityData {
    var delegate : CityDataDelegate?
    
    var locationLoaded = false
    var stuffCities = [
        "Москва" : CityStuff.init(),
        "Краснодар" : CityStuff.init(),
        "Санкт-Петербург" : CityStuff.init(),
        "Армавир" : CityStuff.init(),
        "Сочи" : CityStuff.init(),
        "Воронеж" : CityStuff.init(),
        "Волгоград" : CityStuff.init(),
        "Самара" : CityStuff.init(),
        "Иркутск" : CityStuff.init(),
        "Сургут" : CityStuff.init(),
    ] 
    
    let nameCities = [
        "Москва",
        "Краснодар",
        "Санкт-Петербург",
        "Армавир",
        "Сочи",
        "Воронеж",
        "Волгоград",
        "Самара",
        "Иркутск",
        "Сургут",
    ]

    init() {
        updateData()
    }
    
    //delete data and loading again
    func updateData() {
        locationLoaded = false
        for name in stuffCities.keys {
            stuffCities[name] = CityStuff.init()
            CityData.getCoordinateFrom(address: name) { [weak self] coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                DispatchQueue.main.async {
                    self?.stuffCities[name]?.location = coordinate
                    self?.delegate?.locationLoaded(from: name)
                }
            }
        }
    }
    
   static func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
    
    
    static func translateWeather(_ string: String) -> String {
        switch string {
        case "clear": return "ясно"
        case "partly-cloudy": return "малооблачно"
        case "cloudy": return "облачно с прояснениями"
        case "overcast": return "пасмурно"
        case "drizzle": return "морось"
        case "light-rain": return "небольшой дождь"
        case "rain": return "дождь"
        case "moderate-rain": return "умеренно сильный дождь"
        case "heavy-rain": return "сильный дождь"
        case "continuous-heavy-rain": return "длительный сильный дождь"
        case "showers": return "ливень"
        case "wet-snow": return "дождь со снего"
        case "light-snow": return "небольшой снег"
        case "snow": return "снег"
        case "snow-showers": return "снегопад"
        case "hail": return "град"
        case "thunderstorm": return "гроза"
        case "thunderstorm-with-rain": return "дождь с грозой"
        case "thunderstorm-with-hail": return "гроза с градом"
        default: return "нераспознанная погода"
        }
    }
}
