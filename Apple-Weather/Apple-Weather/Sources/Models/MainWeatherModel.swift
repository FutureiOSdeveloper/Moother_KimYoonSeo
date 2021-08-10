//
//  MainWeatherModel.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/07.
//

struct MainWeatherModel {
    let location: String
    let weather: String
    let temperature: Int
    let highTemperature: Int
    let lowTemperatuer: Int
    
    let hourlyWeather: [HourlyWeatherModel]
    let dailyWeather: DailyWeatherModel
}
