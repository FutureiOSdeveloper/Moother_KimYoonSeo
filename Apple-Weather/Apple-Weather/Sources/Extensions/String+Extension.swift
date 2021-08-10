//
//  String+Extension.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/07.
//

import UIKit

extension String {
    func setHighlighted(with search: String, font: UIFont, color: UIColor) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: self)
        let range = NSString(string: self).range(of: search, options: .caseInsensitive)
        let highlightedAttributes: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color]
        
        attributedText.addAttributes(highlightedAttributes, range: range)
        return attributedText
    }
    
    func convertIcon() -> String {
        switch self {
        case "01d":
            return "sun.max.fill"
        case "01n":
            return "moon.stars.fill"
        case "02d":
            return "cloud.sun.fill"
        case "02n":
            return "cloud.moon.fill"
        case "03d":
            return "cloud.fill"
        case "03n":
            return "cloud.fill"
        case "04d":
            return "smoke.fill"
        case "04n":
            return "smoke.fill"
        case "09d":
            return "cloud.rain.fill"
        case "09n":
            return "cloud.rain.fill"
        case "10d":
            return "cloud.sun.rain.fill"
        case "10n":
            return "cloud.moon.rain.fill"
        case "11d":
            return "cloud.bolt.fill"
        case "11n":
            return "cloud.bolt.fill"
        case "13d":
            return "cloud.snow.fill"
        case "13n":
            return "cloud.snow.fill"
        case "50d":
            return "cloud.fog.fill"
        case "50n":
            return "cloud.fog.fill"
        default:
            return "sun.max.fill"
        }
    }
}
