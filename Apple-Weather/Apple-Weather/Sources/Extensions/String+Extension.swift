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
}
