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
}
