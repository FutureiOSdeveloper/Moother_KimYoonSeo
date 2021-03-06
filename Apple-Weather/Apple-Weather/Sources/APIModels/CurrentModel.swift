//
//  CurrentModel.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/10.
//

struct Current: Codable {
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let pop: Double?
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, rain
        case windGust = "wind_gust"
        case pop
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        dt = (try? value.decode(Int.self, forKey: .dt)) ?? 0
        sunrise = (try? value.decode(Int.self, forKey: .sunrise)) ?? 0
        sunset = (try? value.decode(Int.self, forKey: .sunset)) ?? 0
        temp = (try? value.decode(Double.self, forKey: .temp)) ?? 0
        feelsLike = (try? value.decode(Double.self, forKey: .feelsLike)) ?? 0
        pressure = (try? value.decode(Int.self, forKey: .pressure)) ?? 0
        humidity = (try? value.decode(Int.self, forKey: .humidity)) ?? 0
        dewPoint = (try? value.decode(Double.self, forKey: .dewPoint)) ?? 0
        uvi = (try? value.decode(Double.self, forKey: .uvi)) ?? 0
        clouds = (try? value.decode(Int.self, forKey: .clouds)) ?? 0
        visibility = (try? value.decode(Int.self, forKey: .visibility)) ?? 0
        windSpeed = (try? value.decode(Double.self, forKey: .windSpeed)) ?? 0
        windDeg = (try? value.decode(Int.self, forKey: .windDeg)) ?? 0
        windGust = (try? value.decode(Double.self, forKey: .windGust)) ?? 0
        weather = (try value.decode([Weather].self, forKey: .weather))
        pop = (try? value.decode(Double.self, forKey: .pop)) ?? 0
        rain = (try? value.decode(Rain.self, forKey: .rain))
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        the1H = (try? value.decode(Double.self, forKey: .the1H)) ?? 0
    }
    
}
