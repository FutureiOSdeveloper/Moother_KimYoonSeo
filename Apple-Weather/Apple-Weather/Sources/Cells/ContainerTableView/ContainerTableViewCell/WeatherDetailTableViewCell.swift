//
//  WeatherDetailTableViewCell.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/29.
//

import UIKit

import SnapKit
import Then

class WeatherDetailTableViewCell: UITableViewCell {
    
    private let leftLabel = UILabel().then {
        $0.text = "일출"
        $0.font = .systemFont(ofSize: 10, weight: .thin)
        $0.textColor = .white
    }
    
    private let leftContentLabel = UILabel().then {
        $0.text = "05:34"
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .white
    }
    
    private let rightLabel = UILabel().then {
        $0.text = "일출"
        $0.font = .systemFont(ofSize: 10, weight: .thin)
        $0.textColor = .white
    }
    
    private let rightContentLabel = UILabel().then {
        $0.text = "05:34"
        $0.font = .systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .white
    }
    
    private let leftStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }
    
    private let rightStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }
    
    private let seperatorTopView = UIView().then {
        $0.backgroundColor = .white
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutWeatherDetailTableViewCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutWeatherDetailTableViewCell() {
        backgroundColor = .clear
        
        contentView.addSubviews(leftStackView, rightStackView, seperatorTopView)
        leftStackView.addArrangedSubviews(leftLabel, leftContentLabel)
        rightStackView.addArrangedSubviews(rightLabel, rightContentLabel)
        
        leftStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.leading.equalToSuperview().offset(Constants.Spacing.s20)
            $0.trailing.equalTo(contentView.snp.centerX)
        }
        
        rightStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.leading.equalTo(contentView.snp.centerX)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.s20)
        }
        
        seperatorTopView.snp.makeConstraints {  $0.leading.equalToSuperview().offset(Constants.Spacing.s20)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.s20)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Constants.Seperator.height)
        }
    }
}
