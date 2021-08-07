//
//  String+Extension.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/07.
//

import Foundation

extension Int {
    func addTemperatureSymbol() -> String {
        let result = "\(self)°"
        return result
    }
}
