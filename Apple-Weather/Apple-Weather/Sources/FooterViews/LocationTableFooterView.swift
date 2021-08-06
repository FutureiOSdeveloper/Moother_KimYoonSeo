//
//  LocationTableFooterView.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/06.
//

import UIKit

import SnapKit
import Then

class LocationTableFooterView: UITableViewHeaderFooterView {
    
    private let FtoCButton = UIButton().then {
        $0.setTitle("C/F", for: .normal)
    }
    
    private let safariImageView = UIImageView().then {
        $0.image = UIImage(systemName: "safari")
        $0.tintColor = .white
    }
    
    private let searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .white
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder doesn't exist")
    }
    
    private func setLayout() {
        let backgroundView = UIView(frame: .zero)
        self.backgroundView = backgroundView
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.addSubviews(FtoCButton, safariImageView, searchButton)
        
        FtoCButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.Spacing.s20)
            $0.centerY.equalToSuperview()
        }
        
        safariImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.s20)
            $0.centerY.equalToSuperview()
        }
    }
    
}
