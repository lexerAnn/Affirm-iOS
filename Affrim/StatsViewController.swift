//
//  StatsViewController.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import UIKit

class StatsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkForFirstTime()
    }
    
    private func checkForFirstTime() {
        // Check if user has set up goals before
        let hasSetupGoals = UserDefaults.standard.bool(forKey: "hasSetupGoals")
        
        if !hasSetupGoals {
            // Show Daily Goals welcome screen
            showDailyGoalsWelcome()
        } else {
            // Show daily goals progress UI
            setupDailyGoalsUI()
        }
    }
    
    private func showDailyGoalsWelcome() {
        // Remove any existing views
        view.subviews.forEach { $0.removeFromSuperview() }
        
        // Create and add the Daily Goals welcome view controller as a child
        let dailyGoalsWelcomeVC = DailyGoalsWelcomeViewController()
        addChild(dailyGoalsWelcomeVC)
        view.addSubview(dailyGoalsWelcomeVC.view)
        dailyGoalsWelcomeVC.didMove(toParent: self)
        
        // Set up constraints
        dailyGoalsWelcomeVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dailyGoalsWelcomeVC.view.topAnchor.constraint(equalTo: view.topAnchor),
            dailyGoalsWelcomeVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dailyGoalsWelcomeVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dailyGoalsWelcomeVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Check if goals are set up and refresh UI accordingly
        checkForFirstTime()
    }
    
    private func setupDailyGoalsUI() {
        // Remove any existing views first
        view.subviews.forEach { $0.removeFromSuperview() }
        
        // Set background color
        view.backgroundColor = .systemBackground
        
        // Hide navigation bar for clean look
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Get saved data
        let dailyTarget = UserDefaults.standard.integer(forKey: "dailyTarget")
        
        // For demo purposes, set completed to 2 since we're showing 2 affirmations
        let completedToday = 2
        UserDefaults.standard.set(completedToday, forKey: "completedToday")
        
        let remaining = max(0, dailyTarget - completedToday)
        
        // Main title
        let titleLabel = UILabel()
        titleLabel.text = "Daily Goals"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        
        // Progress fraction
        let progressLabel = UILabel()
        progressLabel.text = "\(completedToday)/\(dailyTarget)"
        progressLabel.font = UIFont.systemFont(ofSize: 72, weight: .bold)
        progressLabel.textColor = .label
        progressLabel.textAlignment = .center
        
        // Completed today text
        let completedLabel = UILabel()
        completedLabel.text = "completed today"
        completedLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        completedLabel.textColor = .systemGray
        completedLabel.textAlignment = .center
        
        // Progress bar
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = dailyTarget > 0 ? Float(completedToday) / Float(dailyTarget) : 0.0
        progressView.progressTintColor = .label
        progressView.trackTintColor = .systemGray5
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 3.0) // Make it thicker
        
        // Remaining text
        let remainingLabel = UILabel()
        remainingLabel.text = "\(remaining) more to go!"
        remainingLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        remainingLabel.textColor = .systemGray
        remainingLabel.textAlignment = .center
        
        // Today's Affirmations title
        let affirmationsTitleLabel = UILabel()
        affirmationsTitleLabel.text = "Today's Affirmations"
        affirmationsTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        affirmationsTitleLabel.textColor = .label
        affirmationsTitleLabel.textAlignment = .left
        
        // Affirmations list (placeholder for now)
        let affirmationsListView = createAffirmationsList()
        
        // Add all subviews
        view.addSubview(titleLabel)
        view.addSubview(progressLabel)
        view.addSubview(completedLabel)
        view.addSubview(progressView)
        view.addSubview(remainingLabel)
        view.addSubview(affirmationsTitleLabel)
        view.addSubview(affirmationsListView)
        
        // Set up constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        completedLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        remainingLabel.translatesAutoresizingMaskIntoConstraints = false
        affirmationsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        affirmationsListView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Progress label
            progressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            progressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Completed label
            completedLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 8),
            completedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Progress view
            progressView.topAnchor.constraint(equalTo: completedLabel.bottomAnchor, constant: 30),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            progressView.heightAnchor.constraint(equalToConstant: 6),
            
            // Remaining label
            remainingLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16),
            remainingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Affirmations title
            affirmationsTitleLabel.topAnchor.constraint(equalTo: remainingLabel.bottomAnchor, constant: 50),
            affirmationsTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            affirmationsTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Affirmations list
            affirmationsListView.topAnchor.constraint(equalTo: affirmationsTitleLabel.bottomAnchor, constant: 20),
            affirmationsListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            affirmationsListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            affirmationsListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func createAffirmationsList() -> UIView {
        let containerView = UIView()
        
        // Show 2 completed affirmations (matches the completed count of 2)
        let affirmations = [
            ("I am confident and capable of achieving my dreams.", "CONFIDENCE", "2:45 PM"),
            ("I nourish my body with healthy choices every day.", "HEALTH", "10:20 AM")
        ]
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        
        for (text, category, time) in affirmations {
            let affirmationView = createAffirmationItem(text: text, category: category, time: time)
            stackView.addArrangedSubview(affirmationView)
        }
        
        containerView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    private func createAffirmationItem(text: String, category: String, time: String) -> UIView {
        let containerView = UIView()
        
        // Left border line
        let borderView = UIView()
        borderView.backgroundColor = .label
        
        // Affirmation text
        let textLabel = UILabel()
        textLabel.text = "\"\(text)\""
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textLabel.textColor = .label
        textLabel.numberOfLines = 0
        
        // Category and time container
        let bottomView = UIView()
        
        let categoryLabel = UILabel()
        categoryLabel.text = category
        categoryLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        categoryLabel.textColor = .systemGray
        
        let timeLabel = UILabel()
        timeLabel.text = time
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        timeLabel.textColor = .systemGray
        timeLabel.textAlignment = .right
        
        // Add subviews
        containerView.addSubview(borderView)
        containerView.addSubview(textLabel)
        containerView.addSubview(bottomView)
        bottomView.addSubview(categoryLabel)
        bottomView.addSubview(timeLabel)
        
        // Set up constraints
        borderView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Border view
            borderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            borderView.topAnchor.constraint(equalTo: containerView.topAnchor),
            borderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            borderView.widthAnchor.constraint(equalToConstant: 4),
            
            // Text label
            textLabel.leadingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            
            // Bottom view
            bottomView.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomView.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 8),
            bottomView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 20),
            
            // Category label
            categoryLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            
            // Time label
            timeLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            timeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: categoryLabel.trailingAnchor, constant: 16)
        ])
        
        return containerView
    }
    
    private func createStatView(title: String, value: String, color: UIColor) -> UIView {
        let containerView = UIView()
        containerView.backgroundColor = color.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 12
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = .label
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        valueLabel.textColor = color
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            valueLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        return containerView
    }
}
