//
//  Notification.Name+Extension.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/06.
//

import Foundation

extension Notification.Name {
    static let tapSearchButton = Notification.Name("tapSearchButton")
    static let tapFtoCButton = Notification.Name("tapFtoCButton")
    static let changeFtoC = Notification.Name("changeFtoC")
    static let addLocation = Notification.Name("addLocation")
    static let deleteLocation = Notification.Name("deleteLocation")
    static let selectLocation = Notification.Name("selectLocation")
}
