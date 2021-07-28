//
//  UIView+Extension.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/27.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
