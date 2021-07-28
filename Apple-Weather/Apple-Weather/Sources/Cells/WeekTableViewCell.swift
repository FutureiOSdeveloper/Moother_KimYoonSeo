//
//  WeekTableViewCell.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/28.
//

import UIKit

import SnapKit
import Then

class WeekTableViewCell: UITableViewCell {
    
    private let weekWeatherTableView = UITableView(frame: .zero, style: .grouped).then { $0.backgroundColor = .clear
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initWeekWeatherTableView()
        layoutWeekWeatherTableViewCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initWeekWeatherTableView() {
        weekWeatherTableView.delegate = self
        weekWeatherTableView.dataSource = self
        
        weekWeatherTableView.register(WeekWeatherTableViewCell.self, forCellReuseIdentifier: Constants.TableViewCells.weekWeather)
        weekWeatherTableView.register(WeekWeatherFooterView.self, forHeaderFooterViewReuseIdentifier: Constants.TableViewFooters.weekWeather)
    }
    
    private func layoutWeekWeatherTableViewCell() {
        contentView.addSubviews(weekWeatherTableView)
        
        weekWeatherTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        print(weekWeatherTableView.frame.height)
    }
}

extension WeekTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.TableViewFooters.weekWeather) as? WeekWeatherFooterView
        else {
            return UIView()
        }
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension WeekTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weekWeatherTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.weekWeather, for: indexPath) as? WeekWeatherTableViewCell else { return UITableViewCell() }
        print(weekWeatherTableView.frame.height)
        return cell
    }
    
}
