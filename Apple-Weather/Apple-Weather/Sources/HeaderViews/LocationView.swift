//
//  LocationHeaderView.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/27.
//

import UIKit

class LocationView: UIView {
    
    private let locationLabel = UILabel().then {
        $0.text = "용인시"
        $0.font = .systemFont(ofSize: 22)
    }
    
    private let weatherLabel = UILabel().then {
        $0.text = "한때 흐림"
        $0.font = .systemFont(ofSize: 12)
    }
    
    private let vStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .center
    }
    
    public init() {
        super.init(frame: CGRect.zero)
        layoutLocationSectionHeaderView()
        backgroundColor = .brown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layoutLocationSectionHeaderView() {
        addSubview(vStackView)
        vStackView.addArrangedSubviews(locationLabel, weatherLabel)
        
        vStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-15)
            $0.centerX.equalToSuperview()
        }
    }
}
