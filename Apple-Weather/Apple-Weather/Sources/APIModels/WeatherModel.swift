//
//  WeatherModel.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/10.
//


struct Weather: Codable {
    let id: Int
    let main: Main
    let weatherDescription: Description
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? value.decode(Int.self, forKey: .id)) ?? 0
        main = (try value.decode(Main.self, forKey: .main))
        weatherDescription = (try value.decode(Description.self, forKey: .weatherDescription))
        icon = (try? value.decode(String.self, forKey: .icon)) ?? ""
    }
    
}

enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
}
