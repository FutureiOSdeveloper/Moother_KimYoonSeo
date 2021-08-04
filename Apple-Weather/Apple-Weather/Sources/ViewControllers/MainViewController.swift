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
    
    private let locationLabel = UILabel().then {
        $0.text = "용인시"
        $0.font = .systemFont(ofSize: 28)
        $0.textColor = .white
    }
    
    private let weatherLabel = UILabel().then {
        $0.text = "한때 흐림"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let locationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
    }
    
    private let temperatureLabel = UILabel().then {
        $0.text = "34"
        $0.font = .systemFont(ofSize: 80, weight: .thin)
        $0.textColor = .white
    }
    
    private let highTemperatureLabel = UILabel().then {
        $0.text = "최고:34"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let lowTemperatureLabel = UILabel().then {
        $0.text = "최저:24"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let temperatureStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    private let locationViewTopConstraint: CGFloat = 50 * Constants.Ratio.iPhone12Pro

    override func viewDidLoad() {
        super.viewDidLoad()
        initMainTableView()
        setLayoutMainViewController()
    }
    
    private func setLayoutMainViewController() {
        view.addSubviews(backgroundImageView, locationStackView, mainTableView)
        
        locationStackView.addArrangedSubviews(locationLabel, weatherLabel, temperatureLabel, temperatureStackView)
        temperatureStackView.addArrangedSubviews(highTemperatureLabel, lowTemperatureLabel)
        
        locationStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(locationViewTopConstraint)
            $0.leading.trailing.equalToSuperview()
        }
       
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        
        let scrollRatio = abs(lastContentOffset / UIScreen.main.bounds.height) * 2.5
        
        guard let weekWeatherTableViewCell = mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? WeekTableViewCell else { return }
        
        if lastContentOffset <= 0 {
            locationStackView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(max(locationViewTopConstraint, locationViewTopConstraint * (1 - scrollRatio)))
            }
            weekWeatherTableViewCell.setEnabledScroll(isScrollEnabled: false)
            temperatureLabel.alpha = 1
            temperatureStackView.alpha = 1
            scrollView.bounces = true
            
        } else if scrollRatio > 0 && scrollRatio < 0.04 {
            weekWeatherTableViewCell.setEnabledScroll(isScrollEnabled: true)
            locationStackView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(locationViewTopConstraint * (1 - scrollRatio))
            }
            temperatureLabel.alpha = 1 - scrollRatio
            temperatureStackView.alpha = 1 - scrollRatio * 2
            scrollView.bounces = true
            
        } else if scrollRatio >= 0.04 && scrollRatio < 0.25 {
            weekWeatherTableViewCell.setEnabledScroll(isScrollEnabled: false)
            locationStackView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(locationViewTopConstraint * (1 - scrollRatio))
            }
            temperatureLabel.alpha = 1 - scrollRatio * 2
            temperatureStackView.alpha = 0
            scrollView.bounces = false
        } else {
            locationStackView.snp.updateConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(max(5 * Constants.Ratio.iPhone12Pro, locationViewTopConstraint * (1 - scrollRatio)))
            }
            weekWeatherTableViewCell.setEnabledScroll(isScrollEnabled: true)
            temperatureLabel.alpha = 0
            temperatureStackView.alpha = 0
            scrollView.bounces = false
        }
        
        lastContentOffset = scrollView.contentOffset.y
        
//        print(UIScreen.main.bounds.height)
        print(UIScreen.main.bounds.height)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 530 * Constants.Ratio.iPhone12Pro
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return UIScreen.main.bounds.height / 2
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
   
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = mainTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.week, for: indexPath) as? WeekTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        return cell
    }

}
