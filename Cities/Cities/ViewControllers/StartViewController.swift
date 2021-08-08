//
//  ViewController.swift
//  Cities
//
//  Created by Евгений Полюбин on 07.08.2021.
//

import UIKit
import CoreLocation

class StartViewController: UITableViewController {
    let search = UISearchBar.init()
    let cityData = CityData.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        cityData.delegate = self
        
        search.placeholder = "Введите город"
        search.delegate = self
        navigationItem.titleView = search
    
        tableView.register(CityViewCell.self, forCellReuseIdentifier: "City")
    }
}

//MARK: Methods Delegate and DataSource of TableView
extension StartViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cityData.nameCities.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "City") as! CityViewCell
        let city = cityData.nameCities[indexPath.row]
        
        if let temp = cityData.stuffCities[city]?.temp {
            cell.tempLabel.text = "\(temp)℃"
        } else {
            cell.tempLabel.text = "загрузка"
        }
        
        var subtitle: String
        if let condition = cityData.stuffCities[city]?.condition {
            subtitle = CityData.translateWeather(condition)
        } else {
            subtitle = "загрузка"
        }
        
        cell.textLabel?.text = city
        cell.detailTextLabel?.text = subtitle
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        guard let city = cell?.textLabel?.text else {return}
        guard let url = cityData.stuffCities[city]?.url else {return}
        let detailed = DetailedViewController.init(url: url)
        self.present(detailed, animated: true, completion: nil)
    }
    
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= -100 {
            cityData.updateData()
            tableView.reloadData()
        }
    }
}


//MARK: Method for getting data from the network for CityData
extension StartViewController {
    
    func retrieveCityWeather(_ city: String) {
        guard let location = cityData.stuffCities[city]?.location else {return}
        let http = HTTPCommunication()
    
        http.retrieveWeather(from: location) { [weak self] (data) -> Void in
            guard String(data: data, encoding: String.Encoding.utf8) != nil else { return }
            do {
                let jsonObjectAny: Any = try JSONSerialization.jsonObject(with: data, options: [])
                guard
                    let jsonObject = jsonObjectAny as? [String: Any],
                    let fact = jsonObject["fact"] as? [String: Any],
                    let info = jsonObject["info"] as? [String: Any],

                    let temp = fact["temp"] as? Int,
                    let condition = fact["condition"] as? String,
                    let url = info["url"] as? String
                else {
                    return
                }
                
                self?.cityData.stuffCities[city]?.condition = condition
                self?.cityData.stuffCities[city]?.temp = temp
                self?.cityData.stuffCities[city]?.url = url
                self?.cityData.stuffCities[city]?.createdData = true
                self?.tableView.reloadData()
            } catch {
                print("data cannot be retrieved")
            }
        }
    }
    
    //MARK: Method for getting data from the network for DetailedViewController)
    private func runDetailedViewControllerWith(addres: String) {
        CityData.getCoordinateFrom(address: addres) { [weak self] coordinate, error in
            guard let location = coordinate, error == nil else { return }
            let http = HTTPCommunication()
            
            http.retrieveWeather(from: location) { [weak self] (data) -> Void in
                do {
                    let jsonObjectAny: Any = try JSONSerialization.jsonObject(with: data, options: [])
                
                    guard
                        let jsonObject = jsonObjectAny as? [String: Any],
                        let info = jsonObject["info"] as? [String: Any],
                        let url = info["url"] as? String
                    else {
                        return
                    }
                    let detailed = DetailedViewController.init(url: url)
                    self?.present(detailed, animated: true, completion: nil)
                   
                } catch {
                    print("missing city data")
                }
            }
        }
    }
}


//MARK: Subscribing on the UISearchBatDelegate
extension StartViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        runDetailedViewControllerWith(addres: searchBar.text ?? "")
    }
}


//MARK: Subscribing on the CityDataDelegate
extension StartViewController: CityDataDelegate {
    func locationLoaded(from city: String) {
            retrieveCityWeather(city)
    }
}



