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
        $0.textColor = .white
    }
    
    private let highTemperatureLabel = UILabel().then {
        $0.text = "34"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .white
    }
    
    private let lowTemperatureLabel = UILabel().then {
        $0.text = "24"
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .white
    }
    
    private let weatherImageView = UIImageView().then {
        $0.image = UIImage(systemName: "cloud.rain.fill")
        $0.tintColor = .white
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutWeekWeatherTableViewCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        [dayLabel, highTemperatureLabel, lowTemperatureLabel].forEach { $0.text = nil }
        weatherImageView.image = nil
    }
    
    private func layoutWeekWeatherTableViewCell() {
        backgroundColor = .clear
        contentView.addSubviews(dayLabel, highTemperatureLabel, lowTemperatureLabel, weatherImageView)
        
        dayLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset( Constants.Spacing.s20)
        }
       
        weatherImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo( Constants.Spacing.s20)
        }
        
        lowTemperatureLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.s20)
        }
        
        highTemperatureLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(lowTemperatureLabel.snp.leading).inset(-Constants.Spacing.s20)
        }
    }
    
    public func setData(weekWeather: WeekWeaherModel) {
        dayLabel.text = weekWeather.day
        highTemperatureLabel.text = weekWeather.highTemperature.isFahrenheit().addTemperatureSymbol()
        lowTemperatureLabel.text = weekWeather.lowTemperature.isFahrenheit().addTemperatureSymbol()
        weatherImageView.image = UIImage(systemName: weekWeather.icon)
    }
}
