//
//  StatsViewController.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import UIKit
import AVFoundation

class StatsViewController: UIViewController {
    
    // MARK: - Properties
    private var characterVideoView: CharacterVideoView?

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
        
        // Update character progress if it exists
        updateCharacterProgress()
    }
    
    private func setupDailyGoalsUI() {
        // Remove any existing views first
        view.subviews.forEach { $0.removeFromSuperview() }
        
        // Set background color
        view.backgroundColor = .systemBackground
        
        // Hide navigation bar for clean look
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Simple parameters for demo - you can change these
        let totalAffirmations = 5
        let completedAffirmations = 0
        
        // Update UserDefaults
        UserDefaults.standard.set(totalAffirmations, forKey: "dailyTarget")
        UserDefaults.standard.set(completedAffirmations, forKey: "completedToday")
        
        let remaining = max(0, totalAffirmations - completedAffirmations)
        
        // Main title
        let titleLabel = UILabel()
        titleLabel.text = "Daily Goals"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        
        // Character Video View
        characterVideoView = CharacterVideoView()
        let currentProgress = totalAffirmations > 0 ? Float(completedAffirmations) / Float(totalAffirmations) : 0.0
        characterVideoView?.setProgress(currentProgress, animated: true)
        
        // Progress fraction (smaller, below character)
        let progressLabel = UILabel()
        progressLabel.text = "\(completedAffirmations)/\(totalAffirmations)"
        progressLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
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
        progressView.progress = totalAffirmations > 0 ? Float(completedAffirmations) / Float(totalAffirmations) : 0.0
        progressView.progressTintColor = .label
        progressView.trackTintColor = .systemGray5
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 3.0) // Make it thicker
        
        // Remaining text
        let remainingLabel = UILabel()
        if remaining > 0 {
            remainingLabel.text = "\(remaining) more to go!"
            remainingLabel.textColor = .systemGray
        } else {
            remainingLabel.text = "🎉 Daily goal completed! Your light is radiant! 🌟"
            remainingLabel.textColor = .systemOrange
        }
        remainingLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        remainingLabel.textAlignment = .center
        
        // Today's Affirmations title
        let affirmationsTitleLabel = UILabel()
        affirmationsTitleLabel.text = "Today's Affirmations"
        affirmationsTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        affirmationsTitleLabel.textColor = .label
        affirmationsTitleLabel.textAlignment = .left
        
        // Show scrollable affirmations list
        let affirmationsListView = createScrollableAffirmationsList(completed: completedAffirmations, total: totalAffirmations)
        
        // Add all subviews
        view.addSubview(titleLabel)
        if let characterVideoView = characterVideoView {
            view.addSubview(characterVideoView)
        }
        view.addSubview(progressLabel)
        view.addSubview(completedLabel)
        view.addSubview(progressView)
        view.addSubview(remainingLabel)
        view.addSubview(affirmationsTitleLabel)
        view.addSubview(affirmationsListView)
        
        // Set up constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        characterVideoView?.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        completedLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        remainingLabel.translatesAutoresizingMaskIntoConstraints = false
        affirmationsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        affirmationsListView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints: [NSLayoutConstraint] = [
            // Title label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        // Add character constraints if character exists
        if let character = characterVideoView {
            constraints.append(contentsOf: [
                character.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
                character.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                character.widthAnchor.constraint(equalToConstant: 160),
                character.heightAnchor.constraint(equalToConstant: 160),
                
                // Progress label (below character)
                progressLabel.topAnchor.constraint(equalTo: character.bottomAnchor, constant: 16),
                progressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        } else {
            constraints.append(contentsOf: [
                // Progress label (below title if no character)
                progressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
                progressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
        
        constraints.append(contentsOf: [
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
        
        NSLayoutConstraint.activate(constraints)
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
    
    private func createScrollableAffirmationsList(completed: Int, total: Int) -> UIView {
        let containerView = UIView()
        
        // Create scroll view
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        
        // All possible affirmations
        let allAffirmations = [
            ("I am confident and capable of achieving my dreams.", "CONFIDENCE", "9:15 AM"),
            ("I nourish my body with healthy choices every day.", "HEALTH", "11:30 AM"),
            ("I attract abundance and prosperity into my life.", "WEALTH", "1:45 PM"),
            ("I am at peace with myself and the world around me.", "PEACE", "4:20 PM"),
            ("I radiate creativity and express my authentic self.", "CREATIVITY", "7:10 PM"),
            ("I am grateful for all the blessings in my life.", "GRATITUDE", "8:30 PM"),
            ("I choose to see the good in every situation.", "POSITIVITY", "9:45 PM"),
            ("I trust in my ability to overcome any challenge.", "STRENGTH", "10:15 PM")
        ]
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        
        // Show completed affirmations
        for i in 0..<min(completed, allAffirmations.count) {
            let (text, category, time) = allAffirmations[i]
            let affirmationView = createAffirmationItem(text: text, category: category, time: time)
            stackView.addArrangedSubview(affirmationView)
        }
        
        // Add empty state if no affirmations completed
        if completed == 0 {
            let emptyMessageLabel = UILabel()
            emptyMessageLabel.text = "No affirmations completed yet.\nStart your journey to awaken your inner light! ✨"
            emptyMessageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            emptyMessageLabel.textColor = .systemGray2
            emptyMessageLabel.textAlignment = .center
            emptyMessageLabel.numberOfLines = 0
            stackView.addArrangedSubview(emptyMessageLabel)
        }
        
        // Add scroll view and stack view
        containerView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Stack view constraints
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        return containerView
    }
    
    private func createCompletedAffirmationsList() -> UIView {
        let containerView = UIView()
        
        // Show 5 completed affirmations with different categories and times
        let affirmations = [
            ("I am confident and capable of achieving my dreams.", "CONFIDENCE", "9:15 AM"),
            ("I nourish my body with healthy choices every day.", "HEALTH", "11:30 AM"),
            ("I attract abundance and prosperity into my life.", "WEALTH", "1:45 PM"),
            ("I am at peace with myself and the world around me.", "PEACE", "4:20 PM"),
            ("I radiate creativity and express my authentic self.", "CREATIVITY", "7:10 PM")
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
    
    private func createEmptyAffirmationsList() -> UIView {
        let containerView = UIView()
        
        // Empty state message
        let emptyMessageLabel = UILabel()
        emptyMessageLabel.text = "No affirmations completed yet.\nStart your journey to awaken your inner light! ✨"
        emptyMessageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        emptyMessageLabel.textColor = .systemGray2
        emptyMessageLabel.textAlignment = .center
        emptyMessageLabel.numberOfLines = 0
        
        containerView.addSubview(emptyMessageLabel)
        emptyMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyMessageLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            emptyMessageLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            emptyMessageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            emptyMessageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
        
        return containerView
    }
    
    // MARK: - Public Methods
    /// Call this method when an affirmation is completed to update the character
    func updateCharacterProgress() {
        guard let character = characterVideoView else { return }
        
        let totalAffirmations = UserDefaults.standard.integer(forKey: "dailyTarget")
        let completedAffirmations = UserDefaults.standard.integer(forKey: "completedToday")
        
        let currentProgress = totalAffirmations > 0 ? Float(completedAffirmations) / Float(totalAffirmations) : 0.0
        character.setProgress(currentProgress, animated: true)
    }
    
    /// Get current character stage for external reference
    func getCurrentCharacterStage() -> String {
        let totalAffirmations = UserDefaults.standard.integer(forKey: "dailyTarget")
        let completedAffirmations = UserDefaults.standard.integer(forKey: "completedToday")
        
        let progress = totalAffirmations > 0 ? Float(completedAffirmations) / Float(totalAffirmations) : 0.0
        
        if progress == 0.0 {
            return "Poor - No affirmations completed yet"
        } else if progress < 1.0 {
            return "Medium - Making progress on your affirmations"
        } else {
            return "Good - All affirmations completed! 🎉"
        }
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
