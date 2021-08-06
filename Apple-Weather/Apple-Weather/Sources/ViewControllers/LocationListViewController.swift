//
//  LocationListViewController.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/06.
//

import UIKit

import SnapKit
import Then

class LocationListViewController: UIViewController {
    
    private let locationTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocationListViewController()
        setLayout()
        
        registerLocationTableView()
        registerNotification()
    }
    
    private func initLocationListViewController() {
        view.backgroundColor = .darkGray
    }
    
    private func setLayout() {
        view.addSubviews(locationTableView)
        locationTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func registerLocationTableView() {
        locationTableView.delegate = self
        locationTableView.dataSource = self
        
        locationTableView.register(LocationTableViewCell.self, forCellReuseIdentifier: Constants.TableViewCells.location)
        locationTableView.register(LocationTableFooterView.self, forHeaderFooterViewReuseIdentifier: Constants.TableViewFooters.location)
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveTestNotification(_:)), name: .tapSearchButton, object: nil)
    }
    
    @objc
    func didRecieveTestNotification(_ notification: Notification) {
        let searchViewController = SearchViewController()
        present(searchViewController, animated: true, completion: nil)
    }

}

extension LocationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return LocationTableFooterView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: nil) { _, _, completion in
            completion(true)
        }

        action.title = "삭제"
        action.backgroundColor = UIColor(red: 1, green: 0.322, blue: 0.322, alpha: 1)

        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true

        return configuration
    }
    
}

extension LocationListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = locationTableView.dequeueReusableCell(withIdentifier: Constants.TableViewCells.location, for: indexPath) as? LocationTableViewCell
        else { return UITableViewCell() }
        
        return cell
    }
    
}
