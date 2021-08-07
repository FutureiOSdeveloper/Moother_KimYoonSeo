//
//  SearchViewController.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/08/06.
//

import Foundation
import UIKit

import MapKit
import SnapKit
import Then

class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar().then {
        $0.backgroundColor = .clear
        $0.barTintColor = .darkGray
        $0.searchTextField.backgroundColor = .gray.withAlphaComponent(0.6)
        $0.backgroundImage = UIImage()
        $0.tintColor = .white
        
        let textFieldInsideSearchBar = $0.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .white
    }
    
    private let dismissButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.tintColor = .white
        $0.addTarget(self, action: #selector(tapDismissButton), for: .touchUpInside)
    }
    
    private let discriptionLabel = UILabel().then {
        $0.text = "도시,우편번호 또는 공항 위치 입력"
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 12)
    }
    
    private let backgroundView = UIView().then {
        $0.backgroundColor = .darkGray
    }
    
    private let resultTableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
    }
    
    private var searchCompleter = MKLocalSearchCompleter()
    private var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    private var searchResults = [MKLocalSearchCompletion]()
    
    private var places: MKMapItem? {
        didSet {
            resultTableView.reloadData()
        }
    }
    
    private var localSearch: MKLocalSearch? {
        willSet {
            // Clear the results and cancel the currently running local search before starting a new search.
            places = nil
            localSearch?.cancel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setSearchBar()
        registerResultTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
           super.viewDidDisappear(animated)
//           searchCompleter = nil
       }
    
    private func registerResultTableView() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    private func setSearchBar() {
        searchBar.becomeFirstResponder()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        searchCompleter.region = searchRegion
        searchBar.delegate = self
    }
    
    private func setLayout() {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        view.addSubview(visualEffectView)
        
        view.addSubviews(backgroundView, resultTableView)
        backgroundView.addSubviews(searchBar, dismissButton, discriptionLabel)
        
        backgroundView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        dismissButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.Spacing.s20)
            $0.centerY.equalTo(searchBar.snp.centerY)
            $0.width.height.equalTo(40)
        }
        
        searchBar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-4)
            $0.trailing.equalTo(dismissButton.snp.leading)
        }
        
        discriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(8)
        }
        
        resultTableView.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    @objc
    private func tapDismissButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults.removeAll()
            resultTableView.reloadData()
        }
        searchCompleter.queryFragment = searchText
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
}

extension SearchViewController: MKLocalSearchCompleterDelegate {
  
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        resultTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        if let error = error as NSError? {
            print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
        }
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let selectedResult = searchResults[indexPath.row]
       let searchRequest = MKLocalSearch.Request(completion: selectedResult)
       let search = MKLocalSearch(request: searchRequest)
       search.start { response, error in
           guard error == nil else {
            dump(error)
               return
           }
           guard let placeMark = response?.mapItems[0].placemark else {
               return
           }
        
        dump(response?.mapItems[0].name)
        
        self.present(MainViewController(), animated: true, completion: nil)
       }
   }
}

extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let searchResult = searchResults[indexPath.row]
        
        cell.textLabel?.font = .systemFont(ofSize: 16)
        cell.textLabel?.textColor = .gray
        cell.backgroundColor = .clear
        
        if let highlightText = searchBar.text {
            cell.textLabel?.setHighlighted(searchResult.title, with: highlightText)
        }
        
        return cell
    } 
}

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
