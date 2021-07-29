//
//  TemperatureView.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/30.
//

import UIKit

import SnapKit
import Then

class TemperatureView: UIView {
    
    private let temperatureLabel = UILabel().then {
        $0.text = "34"
        $0.font = .systemFont(ofSize: 80, weight: .thin)
        $0.textColor = .white
    }
    
    private let highTemperatureLabel = UILabel().then {
        $0.text = "최고:34"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let lowTemperatureLabel = UILabel().then {
        $0.text = "최저:24"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let hStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        layoutLocationSectionHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutLocationSectionHeaderView() {
        addSubviews(temperatureLabel, hStackView)
        hStackView.addArrangedSubviews(highTemperatureLabel, lowTemperatureLabel)
        
        temperatureLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        hStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(10)
        }
        
    }
    
    public func setAlphaStackView(alpha: CGFloat) {
        hStackView.alpha = alpha
    }
    
    public func setAlphaTemperatureLabel(alpha: CGFloat) {
        temperatureLabel.alpha = alpha
    }
}
