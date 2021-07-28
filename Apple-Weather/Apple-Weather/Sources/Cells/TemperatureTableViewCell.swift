//
//  TemperatureTableViewCell.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/27.
//

import UIKit

import SnapKit
import Then

class TemperatureTableViewCell: UITableViewCell {
    
    private let temperatureLabel = UILabel().then {
        $0.text = "34"
        $0.font = .systemFont(ofSize: 50)
    }
    
    private let highTemperatureLabel = UILabel().then {
        $0.text = "최고:34"
        $0.font = .systemFont(ofSize: 12)
    }
    
    private let lowTemperatureLabel = UILabel().then {
        $0.text = "최저:24"
        $0.font = .systemFont(ofSize: 12)
    }
    
    private let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutTemperatureTableViewCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutTemperatureTableViewCell() {
        contentView.addSubviews(temperatureLabel, hStackView)
        hStackView.addArrangedSubviews(highTemperatureLabel, lowTemperatureLabel)
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
        }
        
        hStackView.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).inset(-10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
        }
        
    }
}
