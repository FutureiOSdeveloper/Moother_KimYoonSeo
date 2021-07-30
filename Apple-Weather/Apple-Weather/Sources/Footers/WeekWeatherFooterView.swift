//
//  WeekWeatherFooterView.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/28.
//

import UIKit

import SnapKit
import Then

class WeekWeatherFooterView: UITableViewHeaderFooterView {
    
    private let label = UILabel().then {
        $0.text = "오늘: 날씨 한때 흐림, 체감 더위는 39도입니다. 최고 기온은 35도 입니다. 오늘 밤 날씨는 한때 흐림, 최저 기온은 24도 입니다."
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.numberOfLines = 0
        $0.textColor = .white
    }
    
    private let seperatorTopView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let seperatorBottomView = UIView().then {
        $0.backgroundColor = .white
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layoutWeekWeatherFooterView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder doesn't exist")
    }
    
    private func layoutWeekWeatherFooterView() {
        addSubviews(label, seperatorTopView, seperatorBottomView)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        seperatorTopView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.Seperator.height)
        }
        
        seperatorBottomView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.Seperator.height)
        }
        
    }
}
