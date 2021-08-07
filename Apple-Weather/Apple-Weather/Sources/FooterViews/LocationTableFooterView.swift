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
    
    private var isToggle: Bool = true
    
    private let FtoCButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 20)
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
        setTarget()
        
        setFtoCButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder doesn't exist")
    }
    
    private func setFtoCButton() {
        FtoCButton.setTitleColor(.gray, for: .normal)
        isToggle = UserDefaults.standard.object(forKey: UserDefaultsKey.FtoCButtonState) as? Bool ?? true
        if isToggle {
            FtoCButton.setAttributedTitle("°C/°F".setHighlighted(with: "°C", font: .systemFont(ofSize: 20), color: .white), for: .normal)
        } else {
            FtoCButton.setAttributedTitle("°C/°F".setHighlighted(with: "°F", font: .systemFont(ofSize: 20), color: .white), for: .normal)
        }
    }
    
    private func setTarget() {
        searchButton.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        FtoCButton.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
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
            $0.width.equalTo(50)
        }
        
        safariImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.s20)
            $0.centerY.equalToSuperview()
        }
    }
    
    @objc
    func tapButton(_ sender: UIButton) {
        switch sender {
        case searchButton:
            NotificationCenter.default.post(name: .tapSearchButton, object: nil, userInfo: nil)
        case FtoCButton:
            NotificationCenter.default.post(name: .tapFtoCButton, object: nil, userInfo: nil)
            isToggle.toggle()
            UserDefaults.standard.set(isToggle, forKey: UserDefaultsKey.FtoCButtonState)
            setFtoCButton()
        default:
            break
        }
    }
    
}
