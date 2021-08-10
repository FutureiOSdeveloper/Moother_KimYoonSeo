//
//  WeatherModel.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/10.
//

struct Weather: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? value.decode(Int.self, forKey: .id)) ?? 0
        main = (try value.decode(String.self, forKey: .main))
        weatherDescription = (try value.decode(String.self, forKey: .weatherDescription))
        icon = (try? value.decode(String.self, forKey: .icon)) ?? ""
    }
    
}
