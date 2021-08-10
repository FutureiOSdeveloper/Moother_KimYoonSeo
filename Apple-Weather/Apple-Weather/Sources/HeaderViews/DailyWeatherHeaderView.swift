//
//  LocationSectionHeaderView.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/27.
//

import UIKit

import SnapKit
import Then

class DailyWeatherHeaderView: UITableViewHeaderFooterView {
    
    private var dailyWeather: [HourlyWeatherModel]?
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: 60, height: 110 * Constants.Ratio.iPhone12Pro)
       
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.collectionViewLayout = layout
    }
    
    private let seperatorTopView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let seperatorBottomView = UIView().then {
        $0.backgroundColor = .white
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initCollectionView()
        layoutLocationSectionHeaderView()
        
        registerNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("coder doesn't exist")
    }
    
    private func initCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(DailyWeatherCollectionViewCell.self, forCellWithReuseIdentifier: Constants.CollectionViewCells.dailyWeather)
    }
    
    private func layoutLocationSectionHeaderView() {

        let backgroundView = UIView(frame: .zero)
        self.backgroundView = backgroundView
        
        addSubviews(collectionView, seperatorTopView, seperatorBottomView)
        
        collectionView.snp.makeConstraints {
            $0.height.equalTo(110 * Constants.Ratio.iPhone12Pro)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        seperatorBottomView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.Seperator.height)
        }
        
        seperatorTopView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.Seperator.height)
        }
    }
    
    public func setData(dailyWeather: [HourlyWeatherModel]) {
        self.dailyWeather = dailyWeather
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: .tapFtoCButton, object: nil)
    }
    
    @objc
    func didRecieveNotification(_ notification: Notification) {
        switch notification.name {
        case .tapFtoCButton:
            collectionView.reloadData()
        default:
            break
        }
        
    }
}

extension DailyWeatherHeaderView: UICollectionViewDelegate {
    
}

extension DailyWeatherHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyWeather?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCells.dailyWeather, for: indexPath) as? DailyWeatherCollectionViewCell
        else { return UICollectionViewCell() }
        
        if let dailyWeather = dailyWeather {
            cell.setData(dailyWeather: dailyWeather[indexPath.row])
        }
        
        return cell
    }
    
}
