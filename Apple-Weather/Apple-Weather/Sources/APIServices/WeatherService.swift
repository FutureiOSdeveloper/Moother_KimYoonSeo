//
//  WeatherService.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/15.
//

import Foundation

import Moya

class WeatherService {
    static let shared = WeatherService()
    private lazy var service = MoyaProvider<WeatherAPI>(plugins: [MoyaLoggingPlugin()])
    private var getWeather: GenericModel?
    private var searchWeather: MainWeatherModel?
    
    public func requestGetWeather(lat: Double,
                                  lon: Double,
                                  location: String,
                                  completion: @escaping (MainWeatherModel?) -> Void) {
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
    
    private func convertMainWeatherModel(response: GenericModel,
                                         location: String) -> MainWeatherModel? {
        
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_KR")
        date.timeZone = TimeZone(secondsFromGMT: response.timezoneOffset)
        date.dateFormat = "HH"
        
        let date2 = DateFormatter()
        date2.locale = Locale(identifier: "ko_KR")
        date2.timeZone = TimeZone(secondsFromGMT: response.timezoneOffset)
        date2.dateFormat = "EEEE"
        
        let date3 = DateFormatter()
        date3.locale = Locale(identifier: "ko_KR")
        date3.timeZone = TimeZone(secondsFromGMT: response.timezoneOffset)
        date3.dateFormat = "HH:mm"
        
        var hourlyWeatherModel: [HourlyWeatherModel] = []
        var weekWeatherModel: [WeekWeaherModel] = []
        var detailWeatherModel: [DetailModel] = []

        let hourly = response.hourly
        let daily = response.daily
        let current = response.current
        
        detailWeatherModel.append(contentsOf: [DetailModel(description: "일출",
                                                           content: date3.string(from: Date(timeIntervalSince1970: TimeInterval(current.sunrise ?? 0)))),
                                               DetailModel(description: "일몰",
                                                           content: date3.string(from: Date(timeIntervalSince1970: TimeInterval(current.sunset ?? 0)))),
                                               DetailModel(description: "비 올 확률",
                                                           content: "\(current.dewPoint)%"),
                                               DetailModel(description: "습도",
                                                           content: "\(current.humidity)%"),
                                               DetailModel(description: "바람",
                                                           content: "\(current.windSpeed)m/s"),
                                               DetailModel(description: "체감",
                                                           content: "\(current.feelsLike)°"),
                                               DetailModel(description: "강수량",
                                                           content: "\(String(describing: current.rain?.the1H ?? 0))"),
                                               DetailModel(description: "기압",
                                                           content: "\(current.pressure)hPa"),
                                               DetailModel(description: "가시거리",
                                                           content: "\(current.visibility / 1000)km"),
                                               DetailModel(description: "자외선지수",
                                                           content: "\(current.uvi)")
        
        ])
        
        for index in 0...23 {
            hourlyWeatherModel.append(HourlyWeatherModel(
                                        time: date.string(from: Date(timeIntervalSince1970: TimeInterval(hourly[index].dt))),
                                        icon: hourly[index].weather[0].icon,
                                        temperature: Int(hourly[index].temp)))
        }
        
        print(response.hourly.count)
        
        for index in 0...response.daily.count - 1 {
            weekWeatherModel.append(WeekWeaherModel(
                                        day: date2.string(from: Date(timeIntervalSince1970: TimeInterval(response.daily[index].dt))),
                                        icon: daily[index].weather[0].icon,
                                        precipitation: daily[index].rain,
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
                                         dailyWeather: DailyWeatherModel(weekWeather: weekWeatherModel,
                                                                         detail: detailWeatherModel)
        )
        
        return searchWeather
    }
}
