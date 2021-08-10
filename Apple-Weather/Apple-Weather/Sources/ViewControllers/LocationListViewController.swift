//
//  LocationListViewController.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/06.
//

import UIKit

import SnapKit
import Then

class LocationListViewController: UIViewController {
    
    private var weathers: [MainWeatherModel]?
    private var myLocationWeather: [MainWeatherModel]?
    
    private let locationTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.contentInsetAdjustmentBehavior = .never
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViewController()
        setLayout()
        
        registerLocationTableView()
        registerNotification()
    }
    
    private func initViewController() {
        view.backgroundColor = .black
    }
    
    private func setLayout() {
        view.addSubviews(locationTableView)
        locationTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func registerLocationTableView() {
        locationTableView.delegate = self
        locationTableView.dataSource = self
        
        locationTableView.register(LocationTableViewCell.self, forCellReuseIdentifier: Constants.TableViewCells.location)
        locationTableView.register(LocationTableFooterView.self, forHeaderFooterViewReuseIdentifier: Constants.TableViewFooters.location)
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: .tapSearchButton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: .tapFtoCButton, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: .addLocation, object: nil)
    }
    
    @objc
    func didRecieveNotification(_ notification: Notification) {
        switch notification.name {
        case .tapSearchButton:
            let searchViewController = SearchViewController()
            present(searchViewController, animated: true, completion: nil)
        case .tapFtoCButton:
            locationTableView.reloadData()
        case .addLocation:
            if let  object = notification.object as? MainWeatherModel {
                weathers?.append(object)
            }
            locationTableView.reloadData()
        default:
            break
        }
        
    }
    
    public func setData(myLocationWeather: [MainWeatherModel], weathers: [MainWeatherModel]) {
        self.myLocationWeather = myLocationWeather
        self.weathers = weathers
    }

}

extension LocationListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 1:
            return LocationTableFooterView()
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70 + 44
        case 1:
            return 70
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .selectLocation, object: indexPath, userInfo: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        switch indexPath.section {
        case 1:
            let action = UIContextualAction(style: .normal, title: nil) { _, _, completion in
                self.weathers?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                tableView.reloadData()
                
                NotificationCenter.default.post(name: .deleteLocation, object: indexPath.row, userInfo: nil)
                
                completion(true)
            }

            action.title = "삭제"
            action.backgroundColor = UIColor(red: 1, green: 0.322, blue: 0.322, alpha: 1)

            let configuration = UISwipeActionsConfiguration(actions: [action])
            configuration.performsFirstActionWithFullSwipe = true

            return configuration
                
        default:
            return nil
        }
    }
    
}

extension LocationListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return myLocationWeather?.count ?? 0
        case 1:
            return weathers?.count ?? 0
        default:
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = locationTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.location, for: indexPath) as? LocationTableViewCell
        else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            if let myLocationWeather = myLocationWeather {
                cell.setData(location: "나의 위치", temperature: myLocationWeather[indexPath.row].temperature, time: myLocationWeather[indexPath.row].location)
            }
           
        case 1:
            
            if let weathers = weathers {
                let now = Date()
                let date = DateFormatter()
                date.locale = Locale(identifier: "ko_kr")
                date.timeZone = TimeZone(secondsFromGMT: weathers[indexPath.row].timezonwOffset)
                date.dateFormat = "HH:mm"
                
                cell.setData(location: weathers[indexPath.row].location, temperature: weathers[indexPath.row].temperature, time: date.string(from: now))
            }
        default:
            break
        }
        
        return cell
    }
    
}
