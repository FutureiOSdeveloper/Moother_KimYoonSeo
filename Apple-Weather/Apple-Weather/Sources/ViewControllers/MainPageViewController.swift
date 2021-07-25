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
    
    private let backgroundColors: [UIColor] = [.green, .blue, .brown]
    private let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .white
        $0.pageIndicatorTintColor = .white.withAlphaComponent(0.3)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let pageControlBarView = UIView().then {
        let topLineView = UIView().then {
            $0.backgroundColor = .white
        }
        
        $0.addSubview(topLineView)
        
        topLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
        }
    }
    
    private func instantiateViewController(index: Int, color: UIColor) -> UIViewController {
       let vc = MainViewController()
       vc.view.tag = index
       vc.view.backgroundColor = color
       return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setPageViewController()
        setPageControlBarView()
    }
    
    private func setPageViewController() {
       pageViewController.dataSource = self
       pageViewController.delegate = self
       
       let firstViewController = instantiateViewController(index: 0, color: backgroundColors[0])
       pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
       
       addChild(pageViewController)
       view.addSubview(pageViewController.view)
       pageViewController.didMove(toParent: self)
   }
    
    private func setPageControlBarView() {
        
        view.addSubview(pageControlBarView)
        
        pageControlBarView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(70)
        }
        
        pageControl.numberOfPages = backgroundColors.count
       
        pageControlBarView.addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(10)
            $0.width.equalTo(150)
            $0.height.equalTo(20)
        }
    }
    
}

extension MainPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = pageViewController.viewControllers?.first?.view.tag else { return UIViewController() }

        let nextIndex = index > 0 ? index - 1 : backgroundColors.count - 1

        let nextVC = instantiateViewController(index: nextIndex, color: backgroundColors[nextIndex])
        return nextVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViewController.viewControllers?.first?.view.tag else { return UIViewController() }
        
        let nextIndex = (index + 1) % backgroundColors.count
        let nextVC = instantiateViewController(index: nextIndex, color: backgroundColors[nextIndex])
        
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
