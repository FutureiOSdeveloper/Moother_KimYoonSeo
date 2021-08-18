//
//  MainViewController.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/25.
//

import UIKit

import Lottie
import SnapKit
import Then

class MainViewController: UIViewController {
    
    private var weather: MainWeatherModel?
    
    private let mainTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }
    
    private let locationLabel = UILabel().then {
        $0.text = "--"
        $0.font = .systemFont(ofSize: 28)
        $0.textColor = .white
    }
    
    private let weatherLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let locationStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 5
        $0.alignment = .center
    }
    
    private let temperatureLabel = UILabel().then {
        $0.text = 34.addTemperatureSymbol()
        $0.font = .systemFont(ofSize: 80, weight: .thin)
        $0.textColor = .white
    }
    
    private let highTemperatureLabel = UILabel().then {
        $0.text = "최고:" + 34.addTemperatureSymbol()
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let lowTemperatureLabel = UILabel().then {
        $0.text = "최저:" + 24.addTemperatureSymbol()
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let temperatureStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    private var lottieView = AnimationView(name: "4796-weather-cloudynight")
    
    private let dismissButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.isHidden = true
    }
    
    private let addButton = UIButton().then {
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.isHidden = true
    }
    
    private let locationViewTopConstraint: CGFloat = 50 * Constants.Ratio.iPhone12Pro
    private var lastContentOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initMainTableView()
        
        setLottieView()
        setLayoutMainViewController()
        setTargets()
        setButton()
        
        registerNotification()
   
    }
    
    private func setButton() {
        addButton.isHidden = !isModal
        dismissButton.isHidden = !isModal
    }
    
    private func setLottieView() {
        lottieView = .init(name: self.setLottieImage(weather?.timezonwOffset ?? 0))
    }
    
    private func setTargets() {
        dismissButton.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
    }
    
    private func setLayoutMainViewController() {

        view.backgroundColor = .black
    
        view.addSubviews(lottieView, locationStackView, mainTableView, dismissButton, addButton)
        
        lottieView.snp.makeConstraints {
            $0.width.height.equalTo(200)
            $0.center.equalToSuperview()
        }
        
        locationStackView.addArrangedSubviews(locationLabel, weatherLabel, temperatureLabel, temperatureStackView)
        temperatureStackView.addArrangedSubviews(highTemperatureLabel, lowTemperatureLabel)
        
        locationStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(locationViewTopConstraint)
            $0.leading.trailing.equalToSuperview()
        }

        mainTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.bottom.leading.equalToSuperview()
        }
        
        dismissButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Spacing.s20)
            $0.leading.equalToSuperview().offset(Constants.Spacing.s20)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.Spacing.s20)
            $0.trailing.equalToSuperview().offset(-Constants.Spacing.s20)
        }
    }
    
    private func initMainTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        mainTableView.register(DailyWeatherHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.TableViewHeaders.dailyWeather)
        mainTableView.register(WeekContainerTableViewCell.self, forCellReuseIdentifier: Constants.TableViewCells.week)
    }
    
    public func setData(weather: MainWeatherModel) {
        self.weather = weather
        setData()
    }
    
    private func setData() {
        if let weather = self.weather {
            locationLabel.text = weather.location
            temperatureLabel.text = weather.temperature.isFahrenheit().addTemperatureSymbol()
            lowTemperatureLabel.text = "최저:\(weather.lowTemperatuer.isFahrenheit().addTemperatureSymbol())"
            highTemperatureLabel.text = "최고:\(weather.highTemperature.isFahrenheit().addTemperatureSymbol())"
            weatherLabel.text = weather.weather
        }
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveNotification(_:)), name: .changeFtoC, object: nil)
    }
}

extension MainViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollRatio = abs(lastContentOffset / UIScreen.main.bounds.height) * 2.5
        
        guard let weekWeatherTableViewCell = mainTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? WeekContainerTableViewCell else { return }
        
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
        
        if let weather = weather {
            header.setData(dailyWeather: weather.hourlyWeather)
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
        guard  let cell = mainTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.week, for: indexPath) as? WeekContainerTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        if let detailWeather = weather?.dailyWeather {
            cell.setData(dailyWeathers: detailWeather)
        }
        return cell
    }

}

extension MainViewController {
    @objc
    private func tapButton(_ sender: UIButton) {
        switch sender {
        case dismissButton:
            dismiss(animated: true, completion: nil)
        case addButton:
            NotificationCenter.default.post(name: .addLocation, object: weather, userInfo: nil)
            presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }
    
    @objc
    func didRecieveNotification(_ notification: Notification) {
        switch notification.name {
        case .changeFtoC:
            setData()
            mainTableView.reloadData()
        default:
            break
        }
    }

}
