//
//  WeatherAPI.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/10.
//

import Foundation
import Moya

enum WeatherAPI {
    case getWeathers(lat: Double, lon: Double, exclude: String)
}

extension WeatherAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: APIService.baseURL) else {
            fatalError("baseURL 가져오기 실패")
        }
        return url
    }

    var path: String {
        switch self {
        case .getWeathers(_, _, _):
            return "/onecall"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWeathers:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getWeathers(lat, lon, exclude):
            return .requestParameters(
                parameters: [ "lat": lat, "lon": lon, "exclude": exclude, "units": "metric", "appid": "43e744bd747e3acafd7cbe50e304701d", "lang": "kr"], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [ String: String]? {
        return nil
    }
}
