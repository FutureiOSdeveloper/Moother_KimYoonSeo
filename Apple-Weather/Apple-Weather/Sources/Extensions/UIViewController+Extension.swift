//
//  UIViewController+Extension.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/09.
//

import UIKit

extension UIViewController {
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        return presentingIsModal
    }
    
    func setLottieImage(_ timezone: Int) -> String {
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(secondsFromGMT: timezone)
        date.dateFormat = "HH"
        
        let hour = Int(date.string(from: Date()))!
        
        if hour >= 18 || hour <= 5 {
            return "4796-weather-cloudynight"
        } else {
            return "4800-weather-partly-cloudy"
        }
       
    }
    
}
