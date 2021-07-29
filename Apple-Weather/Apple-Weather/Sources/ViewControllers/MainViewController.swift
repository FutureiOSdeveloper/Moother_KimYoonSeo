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
    }
    
    private let spacingView = UIView()
    private let locationView = LocationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        initMainTableView()
        layoutMainViewController()
    }
    
    private func layoutMainViewController() {
        view.addSubviews(locationView, mainTableView)

        locationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(160)
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
    
}

extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = mainTableView.cellForRow(at: indexPath)
        
        if translation.y > 0 {
            if 100 + translation.y < 160 && locationView.frame.height < 140 {
                locationView.snp.remakeConstraints {
                    $0.top.equalTo(view.safeAreaLayoutGuide)
                    $0.leading.trailing.equalToSuperview()
                    $0.height.equalTo(100 + translation.y)
                }
                cell?.contentView.alpha = translation.y / 60
            } else {
                cell?.contentView.alpha = 1
            }
        } else {
            if 160 + translation.y > 100 && locationView.frame.height > 110 {
                locationView.snp.remakeConstraints {
                    $0.top.equalTo(view.safeAreaLayoutGuide)
                    $0.leading.trailing.equalToSuperview()
                    $0.height.equalTo(160 + translation.y)
                }
                cell?.contentView.alpha = 1 + translation.y / 60
            } else {
                cell?.contentView.alpha = 0
            }
        }
        print(translation.y)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 350
        case 1:
            return 580
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
            guard let cell = mainTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.temperature, for: indexPath) as? TemperatureTableViewCell
            else { return UITableViewCell() }
            cell.backgroundColor = .clear
            return cell
        case 1:
            guard  let cell = mainTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.week, for: indexPath) as? WeekTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
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
            return 120
        default:
            return UITableView.automaticDimension
        }
    }
}
