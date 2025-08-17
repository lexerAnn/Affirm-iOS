//
//  OnboardingContainerViewController.swift
//  Affrim
//
//  Created by Assistant on 13/08/2025.
//

import UIKit

class OnboardingContainerViewController: UIViewController {
    
    // MARK: - Properties
    private var currentPageIndex = 0
    private let totalPages = 5
    private var onboardingPages: [UIViewController] = []
    
    // MARK: - UI Components
    private lazy var pageViewController: UIPageViewController = {
        let pageVC = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pageVC.dataSource = self
        pageVC.delegate = self
        return pageVC
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = totalPages
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.isUserInteractionEnabled = false
        pageControl.hidesForSinglePage = false
        return pageControl
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupOnboardingPages()
        setupFirstPage()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add page view controller
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        // Add page control
        view.addSubview(pageControl)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Page view controller
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -10),
            
            // Page control
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupOnboardingPages() {
        let page1 = OnboardingPage1ViewController()
        let page2 = OnboardingPage2ViewController()
        let page3 = OnboardingPage3ViewController()
        let page4 = OnboardingPage4ViewController()
        let page5 = OnboardingPage5ViewController()
        
        // Set delegates
        page1.delegate = self
        page2.delegate = self
        page3.delegate = self
        page4.delegate = self
        // Note: page5 doesn't use delegate pattern, it uses onSignUpCompleted closure
        
        onboardingPages = [page1, page2, page3, page4, page5]
        
        // Set up delegate for the last page
        page5.onSignUpCompleted = { [weak self] in
            self?.completeOnboarding()
        }
    }
    
    private func setupFirstPage() {
        if let firstPage = onboardingPages.first {
            pageViewController.setViewControllers([firstPage], direction: .forward, animated: false)
        }
    }
    
    // MARK: - Actions
    private func completeOnboarding() {
        // Mark onboarding as completed
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        // Navigate to main app
        if let windowScene = view.window?.windowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.showMainApp()
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingContainerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = onboardingPages.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return onboardingPages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = onboardingPages.firstIndex(of: viewController), index < onboardingPages.count - 1 else {
            return nil
        }
        return onboardingPages[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first,
           let index = onboardingPages.firstIndex(of: currentVC) {
            currentPageIndex = index
            pageControl.currentPage = index
        }
    }
}

// MARK: - OnboardingPageDelegate
extension OnboardingContainerViewController: OnboardingPageDelegate {
    func moveToNextPage() {
        guard currentPageIndex < totalPages - 1 else { return }
        
        currentPageIndex += 1
        let nextPage = onboardingPages[currentPageIndex]
        
        pageViewController.setViewControllers([nextPage], direction: .forward, animated: true)
        pageControl.currentPage = currentPageIndex
    }
}
