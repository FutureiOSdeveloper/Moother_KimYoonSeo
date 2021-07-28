//
//  UIStackView+Extension.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/27.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
