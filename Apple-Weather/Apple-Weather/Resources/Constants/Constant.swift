//
//  Constant.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/27.
//

struct Constants {
    struct TableViewHeaders {
        static let dailyWeather: String = "DailyWeatherHeaderView"
    }
    
    struct TableViewFooters {
        static let weekWeather: String = "WeekWeatherFooterView"
        static let weatherDetail: String = "WeatherDetailFooterView"
    }
    
    struct TableViewCells {
        static let temperature: String = "TemperatureTableViewCell"
        static let week: String = "WeekTableViewCell"
        static let weekWeather: String = "WeekWeatherTableViewCell"
        static let weatherDetail: String = "WeatherDetailTableViewCell"
    }
    
    struct CollectionViewCells {
        static let dailyWeather: String = "DailyWeatherCollectionViewCell"
    }
    
    struct Spacing {
        static let s20: Int = 20
    }
}
