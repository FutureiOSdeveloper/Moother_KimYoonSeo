//
//  ViewController.swift
//  Apple-Weather
//
//  Created by 김윤서 on 2021/07/24.
//

import UIKit

import SnapKit
import Then

class MainPageViewController: UIViewController {
    
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .white
        $0.pageIndicatorTintColor = .white.withAlphaComponent(0.3)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "backImage")
    }

    private func instantiateViewController(index: Int) -> UIViewController {
       let vc = MainViewController()
       vc.view.tag = index
       return vc
    }
    
    private let seperatorView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private var viewControllerList: [UIViewController] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayoutPageViewController()
        
        setPageViewController()
        
        setViewControllerList()
        
        setPageControlBar()
       
    }
    
    private func setLayoutPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
         
        view.addSubviews(backgroundImageView, seperatorView, pageViewController.view)
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        seperatorView.snp.makeConstraints {
            $0.height.equalTo(Constants.Seperator.height)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        addChild(pageViewController)

        pageViewController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setPageViewController() {
        pageViewController.setViewControllers([instantiateViewController(index: 0)], direction: .forward, animated: true, completion: nil)
        pageViewController.didMove(toParent: self)
   }
    
    private func setPageControlBar() {
        pageControl.addTarget(self, action: #selector(pageControltapped(_:)), for: .valueChanged)
        
        let pageControl = UIBarButtonItem(customView: pageControl)
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        navigationController?.toolbar.backgroundColor = .clear
        navigationController?.toolbar.clipsToBounds = true

        toolbarItems = [pageControl]
        
    }
    
    private func setViewControllerList() {
        viewControllerList.append(instantiateViewController(index: 0))
        viewControllerList.append(instantiateViewController(index: 1))
        viewControllerList.append(instantiateViewController(index: 2))
        
        pageControl.numberOfPages = viewControllerList.count
        pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
    }
    
}

extension MainPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = pageViewController.viewControllers?.first?.view.tag else { return UIViewController() }

        let nextIndex = index > 0 ? index - 1 : 3 - 1

        let nextVC = viewControllerList[nextIndex]
        return nextVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.first?.view.tag else { return UIViewController() }
        
        let nextIndex = (index + 1) % 3
        let nextVC = viewControllerList[nextIndex]
        
        return nextVC
    }
    
}

extension MainPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
       guard completed else { return }
       
       if let vc = pageViewController.viewControllers?.first {
           pageControl.currentPage = vc.view.tag
       }
    }
    
    @objc
    func pageControltapped(_ sender: UIPageControl) {
        pageViewController.setViewControllers([viewControllerList[sender.currentPage]], direction: .forward, animated: true, completion: nil)
    }
}
