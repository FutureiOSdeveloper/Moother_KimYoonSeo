//
//  DailyWeatherCollectionViewCell.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/28.
//

import UIKit

import SnapKit
import Then

class DailyWeatherCollectionViewCell: UICollectionViewCell {
    
    private let timeLabel = UILabel().then {
        $0.text = "지금"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let weatherImageView = UIImageView().then {
        $0.image = UIImage(systemName: "cloud.rain.fill")
        $0.tintColor = .white
    }
    
    private let temperatureLabel = UILabel().then {
        $0.text = "26"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let vStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .center
    }
    
    private let percentLabel = UILabel().then {
        $0.text = "80%"
        $0.font = .systemFont(ofSize: 6)
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutDailyWeatherCollectionViewCell()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        [timeLabel, temperatureLabel].forEach { $0.text = nil }
        weatherImageView.image = nil
    }
    
    private func layoutDailyWeatherCollectionViewCell() {
        backgroundColor = .clear
        
        contentView.addSubviews(vStackView)
        vStackView.addArrangedSubviews(timeLabel, weatherImageView, temperatureLabel)
        
        weatherImageView.snp.makeConstraints {
            $0.width.height.equalTo(30)
        }
        
        vStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    public func setData(dailyWeather: HourlyWeatherModel) {
        timeLabel.text = "\(dailyWeather.time)시"
        temperatureLabel.text = dailyWeather.temperature.isFahrenheit().addTemperatureSymbol()
        weatherImageView.image = UIImage(systemName: dailyWeather.icon.convertIcon())
    }
}
