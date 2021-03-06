//
//  WeekContainerTableViewCell.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/28.
//

import UIKit

import SnapKit
import Then

class WeekContainerTableViewCell: UITableViewCell {
    
    private var dailyWeathers: DailyWeatherModel?
    
    private let weekWeatherTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }
    
    public func setEnabledScroll(isScrollEnabled: Bool) {
        weekWeatherTableView.isScrollEnabled = isScrollEnabled
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initWeekWeatherTableView()
        layoutWeekWeatherTableViewCell()
        
        registerNotification()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initWeekWeatherTableView() {
        weekWeatherTableView.delegate = self
        weekWeatherTableView.dataSource = self
        
        weekWeatherTableView.register(WeekWeatherTableViewCell.self, forCellReuseIdentifier: Constants.TableViewCells.weekWeather)
        weekWeatherTableView.register(WeekWeatherFooterView.self, forHeaderFooterViewReuseIdentifier: Constants.TableViewFooters.weekWeather)
        weekWeatherTableView.register(WeatherDetailTableViewCell.self, forCellReuseIdentifier: Constants.TableViewCells.weatherDetail)
        weekWeatherTableView.register(WeatherDetailFooterView.self, forHeaderFooterViewReuseIdentifier: Constants.TableViewFooters.weatherDetail)
    }
    
    private func layoutWeekWeatherTableViewCell() {
        backgroundColor = .clear
        contentView.addSubviews(weekWeatherTableView)
        
        weekWeatherTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func setData(dailyWeathers: DailyWeatherModel) {
        self.dailyWeathers = dailyWeathers
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: .tapFtoCButton, object: nil)
    }
    
    @objc
    func didRecieveNotification(_ notification: Notification) {
        switch notification.name {
        case .tapFtoCButton:
            weekWeatherTableView.reloadData()
        default:
            break
        }
        
    }
}

extension WeekContainerTableViewCell: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = scrollView.contentOffset.y > 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 35
        case 1:
            return 50
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.TableViewFooters.weekWeather) as? WeekWeatherFooterView
            else {
                return UIView()
            }
            return footer
        case 1:
            guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.TableViewFooters.weatherDetail) as? WeatherDetailFooterView
            else {
                return UIView()
            }
            return footer
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 100
        case 1:
            return 50
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

extension WeekContainerTableViewCell: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dailyWeathers?.weekWeather.count ?? 0
        case 1:
            return (dailyWeathers?.detail.count ?? 0) / 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = weekWeatherTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.weekWeather, for: indexPath) as? WeekWeatherTableViewCell
            else { return UITableViewCell() }
            cell.selectionStyle = .none
            if let dailyWeathers = dailyWeathers {
                cell.setData(weekWeather: dailyWeathers.weekWeather[indexPath.row])
            }
            return cell
        case 1:
            guard let cell = weekWeatherTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.weatherDetail, for: indexPath) as? WeatherDetailTableViewCell
            else { return UITableViewCell() }
            cell.selectionStyle = .none
            if let dailyWeathers = dailyWeathers {
                cell.setData(left: dailyWeathers.detail[2 * indexPath.row], right: dailyWeathers.detail[2 * indexPath.row + 1])
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
}
