//
//  LocationSectionHeaderView.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/27.
//

import UIKit

class DailyWeatherHeaderView: UITableViewHeaderFooterView {
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.collectionViewLayout = layout
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initCollectionView()
        layoutLocationSectionHeaderView()
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
        
        addSubviews(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension DailyWeatherHeaderView: UICollectionViewDelegate {
    
}

extension DailyWeatherHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CollectionViewCells.dailyWeather, for: indexPath) as? DailyWeatherCollectionViewCell
        else { return UICollectionViewCell() }
        
        return cell
    }
    
}

extension DailyWeatherCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width / 414 * 59
        let height = width * 2
        return CGSize(width: width, height: height)
    }
}
