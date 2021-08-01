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

    private let pageControlToolBar = UIToolbar(frame: .init(x: 0, y: 0, width: 100, height: 100)).then {
        $0.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        $0.backgroundColor = .clear
        
        let topLineView = UIView().then {
          $0.backgroundColor = .white
        }
        
        $0.addSubview(topLineView)
        
        topLineView.snp.makeConstraints {
            $0.height.equalTo(Constants.Seperator.height)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }
    
    private func instantiateViewController(index: Int) -> UIViewController {
       let vc = MainViewController()
       vc.view.tag = index
       return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setPageViewController()
        setPageControlBar()
       
    }
    
    private func setPageViewController() {
       pageViewController.dataSource = self
       pageViewController.delegate = self
       
       let firstViewController = instantiateViewController(index: 0)
       pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
       
       addChild(pageViewController)
       view.addSubview(pageViewController.view)
       pageViewController.didMove(toParent: self)
   }
    
    private func setPageControlBar() {
        
        pageControl.numberOfPages = 3

        let pageControl = UIBarButtonItem(customView: pageControl)
       
        pageControlToolBar.setItems([pageControl], animated: true)
        
        view.addSubviews(pageControlToolBar)
        pageControlToolBar.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }
    }
    
}

extension MainPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = pageViewController.viewControllers?.first?.view.tag else { return UIViewController() }

        let nextIndex = index > 0 ? index - 1 : 3 - 1

        let nextVC = instantiateViewController(index: nextIndex)
        return nextVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.first?.view.tag else { return UIViewController() }
        
        let nextIndex = (index + 1) % 3
        let nextVC = instantiateViewController(index: nextIndex)
        
        return nextVC
    }
    
}

extension MainPageViewController: UIPageViewControllerDelegate {
       func pageViewController(_ pageViewController: UIPageViewController,
                               didFinishAnimating finished: Bool,
                               previousViewControllers: [UIViewController],
                               transitionCompleted completed: Bool) {
           guard completed else { return }
           
           if let vc = pageViewController.viewControllers?.first {
               pageControl.currentPage = vc.view.tag
           }
       }
}
