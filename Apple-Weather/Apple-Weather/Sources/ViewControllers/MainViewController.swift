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
    
    private let mainTableView = UITableView(frame: .zero, style: .plain).then {
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50 * Constants.Ratio.iPhone11 )
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
        print(Constants.Ratio.iPhone11)
        
        let percentage = lastContentOffset / 292 * 4 * Constants.Ratio.iPhone11
        
        guard let weekWeatherTableViewCell = mainTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? WeekTableViewCell else { return }
        
        if lastContentOffset <= 0 {
            weekWeatherTableViewCell.setEnabledScroll(isScrollEnabled: false)
            temperatureView.setAlphaStackView(alpha: 1)
            temperatureView.setAlphaTemperatureLabel(alpha: 1)
            scrollView.bounces = true
            
        } else if lastContentOffset > 0 && lastContentOffset < 50 * Constants.Ratio.iPhone11 {
            weekWeatherTableViewCell.setEnabledScroll(isScrollEnabled: true)
            locationView.snp.remakeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(50 * Constants.Ratio.iPhone11 * (1 - percentage))
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(100)
            }
            temperatureView.setAlphaStackView(alpha: 1 - percentage * 2)
            temperatureView.setAlphaTemperatureLabel(alpha: 1 - percentage)
            
            scrollView.bounces = true
            
        } else if lastContentOffset >= 50 * Constants.Ratio.iPhone11 && lastContentOffset < 80 * Constants.Ratio.iPhone11 {
            weekWeatherTableViewCell.setEnabledScroll(isScrollEnabled: false)
            locationView.snp.remakeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(50 * Constants.Ratio.iPhone11 * (1 - percentage))
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(100)
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
        print(lastContentOffset)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 400 * Constants.Ratio.iPhone11
        case 1:
            return 530 * Constants.Ratio.iPhone11
        default:
            return UITableView.automaticDimension
        }
    }
    
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.TableViewHeaders.dailyWeather) as? DailyWeatherHeaderView
            else {
                return UIView()
            }
        
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = UITableViewCell()
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        case 1:
            guard  let cell = mainTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.week, for: indexPath) as? WeekTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 120 * Constants.Ratio.iPhone11
        default:
            return UITableView.automaticDimension
        }
    }
}
