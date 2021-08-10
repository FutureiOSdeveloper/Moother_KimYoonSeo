//
//  SearchViewController.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/06.
//

import Foundation
import UIKit

import MapKit
import Moya
import SnapKit
import Then

class SearchViewController: UIViewController {
    private lazy var service = MoyaProvider<WeatherAPI>(plugins: [MoyaLoggingPlugin()])
    private var getWeather: GenericModel?
    
    private var searchWeather: MainWeatherModel?
    
    private let searchBar = UISearchBar().then {
        $0.backgroundColor = .clear
        $0.barTintColor = .darkGray
        $0.searchTextField.backgroundColor = .gray.withAlphaComponent(0.6)
        $0.backgroundImage = UIImage()
        $0.tintColor = .white
        
        let textFieldInsideSearchBar = $0.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
    }
    
    private let dismissButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(tapDismissButton), for: .touchUpInside)
    }
    
    private let discriptionLabel = UILabel().then {
        $0.text = "도시,우편번호 또는 공항 위치 입력"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 12)
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .darkGray
    }
    
    private let resultTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    private var searchResults = [MKLocalSearchCompletion]()
    
    private var places: MKMapItem? {
        didSet {
            resultTableView.reloadData()
        }
    }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setSearchBar()
        registerResultTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
           super.viewDidDisappear(animated)
//           searchCompleter = nil
       }
    
    private func registerResultTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    private func setSearchBar() {
        searchBar.becomeFirstResponder()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        searchCompleter.region = searchRegion
        searchBar.delegate = self
    }
    
    private func setLayout() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        
        view.addSubviews(backgroundView, resultTableView)
        backgroundView.addSubviews(searchBar, dismissButton, discriptionLabel)
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        dismissButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.Spacing.s20)
            $0.centerY.equalTo(searchBar.snp.centerY)
            $0.width.height.equalTo(40)
        }
        
        searchBar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-4)
            $0.trailing.equalTo(dismissButton.snp.leading)
        }
        
        discriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(8)
        }
        
        resultTableView.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    @objc
    private func tapDismissButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults.removeAll()
            resultTableView.reloadData()
        }
        searchCompleter.queryFragment = searchText
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
  
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        resultTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let selectedResult = searchResults[indexPath.row]
       let searchRequest = MKLocalSearch.Request(completion: selectedResult)
       let search = MKLocalSearch(request: searchRequest)
        
       search.start { response, error in
        guard error == nil else {
            return
        }
        guard let placemark = response?.mapItems[0].placemark else { return }

        let vc = MainViewController()
        self.requestGetWeather(lat: placemark.coordinate.latitude, lon: placemark.coordinate.longitude, location: (placemark.locality ?? placemark.title) ?? "") { result in
            if let result = result {
                vc.setData(weather: result)
                self.present(vc, animated: true, completion: nil)
            }
        }
       }
   }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let searchResult = searchResults[indexPath.row]
        
        cell.textLabel?.font = .systemFont(ofSize: 16)
        cell.textLabel?.textColor = .gray
        cell.backgroundColor = .clear
        
        if let highlightText = searchBar.text {
            cell.textLabel?.setHighlighted(searchResult.title, with: highlightText)
        }
        
        return cell
    } 
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController {
    func requestGetWeather(lat: Double, lon: Double, location: String, completion: @escaping (MainWeatherModel?) -> Void) {
        service.request(WeatherAPI.getWeathers(lat: lat, lon: lon, exclude: "minutely")) { [weak self] result in
            switch result {
            case .success(let response):
                do {
                    
                    let response = try JSONDecoder().decode(GenericModel.self, from: response.data)
                    self?.getWeather = response
                    
                     completion(self?.convertMainWeatherModel(response: response, location: location))
                    
                } catch let err {
                    debugPrint(err)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func convertMainWeatherModel(response: GenericModel, location: String) -> MainWeatherModel? {
        let now = Date()
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_KR")
        date.timeZone = TimeZone(secondsFromGMT: response.timezoneOffset)
        date.dateFormat = "HH"
        
        let date2 = DateFormatter()
        date2.locale = Locale(identifier: "ko_KR")
        date2.timeZone = TimeZone(identifier: "KST")
        date2.dateFormat = "EEEE"
        
        var hourlyWeatherModel: [HourlyWeatherModel] = []
        var weekWeatherModel: [WeekWeaherModel] = []
        
        let hourly = response.hourly
        let daily = response.daily
        
        print("시간")
        print(date.string(from: now))
        
        for index in 0...23 {
            hourlyWeatherModel.append(HourlyWeatherModel(
                                        time: date.string(from: Date(timeIntervalSince1970: TimeInterval(hourly[index].dt))),
                                        icon: "cloud",
                                        temperature: Int(hourly[index].temp)))
        }
        
        print(response.hourly.count)
        
        for index in 0...response.daily.count - 1 {
            weekWeatherModel.append(WeekWeaherModel(
                                        day: date2.string(from: Date(timeIntervalSince1970: TimeInterval(response.daily[index].dt))),
                                        icon: "cloud",
                                        precipitation: 20,
                                        highTemperature: Int(daily[index].temp.max),
                                        lowTemperature: Int(daily[index].temp.min)))
        }
        
        searchWeather = MainWeatherModel(location: location,
                                         weather: response.current.weather[0].weatherDescription,
                                         temperature: Int(response.current.temp),
                                         highTemperature: Int(daily[0].temp.max),
                                         lowTemperatuer: Int(daily[0].temp.min),
                                         timezonwOffset: response.timezoneOffset,
                                         hourlyWeather: hourlyWeatherModel,
                                         dailyWeather: DailyWeatherModel(weekWeather: weekWeatherModel)
        )
        
        return searchWeather
    }
}
