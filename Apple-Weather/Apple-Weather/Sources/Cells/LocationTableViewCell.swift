//
//  LocationTableViewCell.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/06.
//

import UIKit

import SnapKit
import Then

class LocationTableViewCell: UITableViewCell {
    
    private let topLabel = UILabel().then {
        $0.text = "용인시"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let locationLabel = UILabel().then {
        $0.text = "나의 위치"
        $0.font = .systemFont(ofSize: 25)
        $0.textColor = .white
    }
    
    private let locationStackView = UIStackView().then {
        $0.axis = .vertical
//        $0.spacing = 5
        $0.alignment = .leading
        $0.distribution = .fillProportionally
    }
    
    private let temperatureLabel = UILabel().then {
        $0.text = "27"
        $0.font = .systemFont(ofSize: 50, weight: .thin)
        $0.textColor = .white
    }
    
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "backImage")
        $0.contentMode = .redraw
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubviews(backgroundImageView, locationStackView, temperatureLabel)
        locationStackView.addArrangedSubviews(topLabel, locationLabel)
        
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        locationStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.Spacing.s20)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.s20)
            $0.bottom.equalToSuperview().offset(-10)
            $0.height.equalTo(50)
        }
    }

}
