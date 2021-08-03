//
//  MainViewController.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/25.
//

import UIKit

import SnapKit
import Then

class MainViewController: UIViewController {
    
    private let mainTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }
    
    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "backImage")
    }
    
    private let spacingView = UIView()
    private let locationView = LocationView()
    private let temperatureView = TemperatureView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initMainTableView()
        layoutMainViewController()
    }
    
    private func layoutMainViewController() {
        view.addSubviews(backgroundImageView, locationView, temperatureView, mainTableView)

        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        locationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        temperatureView.snp.makeConstraints {
            $0.top.equalTo(locationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        mainTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-70)
        }
        
    }
    
    private func initMainTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.register(DailyWeatherHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.TableViewHeaders.dailyWeather)
        mainTableView.register(TemperatureTableViewCell.self, forCellReuseIdentifier: Constants.TableViewCells.temperature)
        mainTableView.register(WeekTableViewCell.self, forCellReuseIdentifier: Constants.TableViewCells.week)
    }
    
    private var lastContentOffset: CGFloat = 0
    
}

extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let percentage = lastContentOffset / 292 * 4
        let scrollRatio = abs(lastContentOffset / UIScreen.main.bounds.height)
        
        guard let weekWeatherTableViewCell = mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? WeekTableViewCell else { return }
        
        if lastContentOffset <= 0 {
            weekWeatherTableViewCell.setEnabledScroll(isScrollEnabled: false)
            temperatureView.setAlphaStackView(alpha: 1)
            temperatureView.setAlphaTemperatureLabel(alpha: 1)
            scrollView.bounces = true
            
        } else if scrollRatio > 0 && scrollRatio < 0.04 {
            weekWeatherTableViewCell.setEnabledScroll(isScrollEnabled: true)
            locationView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(50 * (1 - percentage))
            }
            temperatureView.setAlphaStackView(alpha: 1 - percentage * 2)
            temperatureView.setAlphaTemperatureLabel(alpha: 1 - percentage)
            
            scrollView.bounces = true
            
        } else if scrollRatio >= 0.04 && lastContentOffset < 0.3 {
            weekWeatherTableViewCell.setEnabledScroll(isScrollEnabled: false)
            locationView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(50 * (1 - percentage))
            }
            temperatureView.setAlphaStackView(alpha: 0)
            temperatureView.setAlphaTemperatureLabel(alpha: 1 - percentage)
            
            scrollView.bounces = false
        } else {
            weekWeatherTableViewCell.setEnabledScroll(isScrollEnabled: true)
            temperatureView.setAlphaStackView(alpha: 0)
            temperatureView.setAlphaTemperatureLabel(alpha: 0)
            
            scrollView.bounces = false
        }
        
        lastContentOffset = scrollView.contentOffset.y
        
//        print(UIScreen.main.bounds.height)
        print(abs(lastContentOffset/UIScreen.main.bounds.height))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 530
    }
    
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.TableViewHeaders.dailyWeather) as? DailyWeatherHeaderView
        else {
            return UIView()
        }
    
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = mainTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.week, for: indexPath) as? WeekTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return UIScreen.main.bounds.height / 2
    }
}
