//
//  Date+Extension.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/18.
//

import Foundation

extension Date {
    func setLottieImage(_ timezone: Int) -> String {
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(secondsFromGMT: timezone)
        date.dateFormat = "HH"
        
        let hour = Int(date.string(from: self))!
        
        switch hour {
        case 6..<17 :
            return "4800-weather-partly-cloudy"
        case 17..<22 :
            return "4796-weather-cloudynight"
        default:
            return "4796-weather-cloudynight"
        }
    }
    
    func isNight(_ timezone: Int) -> Bool {
        
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(secondsFromGMT: timezone)
        date.dateFormat = "HH"
        let hour = Int(date.string(from: self))!
        
        switch hour {
        case 6..<17 :
            return false
        case 17..<22 :
            return true
        default:
            return true
        }
    }
    
    func getCurrentTime(_ timezone: Int) -> String {
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(secondsFromGMT: timezone)
        date.dateFormat = "HH:mm"
        
        return date.string(from: self)
    }
}
