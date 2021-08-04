//
//  WeatherDetailFooterView.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/29.
//

import UIKit

import SnapKit
import Then

class WeatherDetailFooterView: UITableViewHeaderFooterView {
    
    private let label = UILabel().then {
        $0.text = "기흥역로 날씨. 지도에서 열기"
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 0
        $0.textColor = .white
    }
  
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layoutWeatherDetailFooterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder doesn't exist")
    }
    
    private func layoutWeatherDetailFooterView() {
        addSubviews(label)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
    }
}
