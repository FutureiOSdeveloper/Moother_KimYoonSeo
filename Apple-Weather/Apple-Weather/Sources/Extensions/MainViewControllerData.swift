//
//  MainViewControllerData.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/07.
//

extension MainPageViewController {
    func setData() {
        weathers.append(MainWeatherModel(location: "용인시",
                                         weather: "청명함",
                                         temperature: 27,
                                         highTemperature: 33,
                                         lowTemperatuer: 22,
                                         dailyWeather: [DailyWeatherModel(time: 22,
                                                                          icon: "cloud",
                                                                          temperature: 27)],
                                         detailWeather: DetailWeatherModel(weekWeather:
                                                                            [WeekWeaherModel(day: "일요일",
                                                                                             icon: "cloud",
                                                                                             precipitation: 20,
                                                                                             highTemperature: 32,
                                                                                             lowTemperature: 22)
                                                                             ])
                                         ))
    }
}
