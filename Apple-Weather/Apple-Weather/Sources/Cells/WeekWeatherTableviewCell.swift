//
//  weekTableviewCell.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/28.
//

import UIKit

import SnapKit
import Then

class WeekWeatherTableViewCell: UITableViewCell {
    
    private let dayLabel = UILabel().then {
        $0.text = "금요일"
        $0.font = .systemFont(ofSize: 16)
    }
    
    private let highTemperatureLabel = UILabel().then {
        $0.text = "34"
        $0.font = .systemFont(ofSize: 16)
    }
    
    private let lowTemperatureLabel = UILabel().then {
        $0.text = "24"
        $0.font = .systemFont(ofSize: 16)
    }
    
    private let weatherImageView = UIImageView().then {
        $0.image = UIImage(systemName: "cloud.rain.fill")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutWeekWeatherTableViewCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutWeekWeatherTableViewCell() {
        contentView.addSubviews(dayLabel, highTemperatureLabel, lowTemperatureLabel, weatherImageView)
        
        dayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
        
        weatherImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        lowTemperatureLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        highTemperatureLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(lowTemperatureLabel.snp.leading).inset(-20)
        }
    }
}
