//
//  SearchViewController.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/06.
//

import UIKit

import SnapKit
import Then

class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar().then {
        $0.backgroundColor = .clear
        $0.barTintColor = .darkGray
        $0.searchTextField.backgroundColor = .gray.withAlphaComponent(0.6)
        $0.backgroundImage = UIImage()
    }
    
    private let dismissButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(tapDismissButton), for: .touchUpInside)
    }
    
    private let discriptionLabel = UILabel().then {
        $0.text = "도시,우편번호 또는 공항 위치 입력"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 12)
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .darkGray
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        let blurEffect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        
        view.addSubviews(backgroundView)
        backgroundView.addSubviews(searchBar, dismissButton, discriptionLabel)
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        dismissButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.Spacing.s20)
            $0.centerY.equalTo(searchBar.snp.centerY)
            $0.width.height.equalTo(40)
        }
        
        searchBar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-4)
            $0.trailing.equalTo(dismissButton.snp.leading)
        }
        
        discriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(8)
        }
        
    }
    
    @objc
    private func tapDismissButton(){
        dismiss(animated: true, completion: nil)
    }
}
