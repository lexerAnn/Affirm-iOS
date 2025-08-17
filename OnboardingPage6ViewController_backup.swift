//
//  OnboardingPage6ViewController.swift
//  Affrim
//
//  Created by Assistant on 16/08/2025.
//

import UIKit

class OnboardingPage6ViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: OnboardingPageDelegate?
    var onSignUpCompleted: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Main container
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Meet Your Progress Buddy! 🎭"
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        // Subtitle
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Your character changes based on your daily progress"
        subtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        // Character states container
        let statesContainer = createCharacterStatesView()
        
        // Description
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Complete your daily affirmations to see your character transform from sad to joyful! The more you practice self-care, the happier your buddy becomes."
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .label
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        // Motivation text
        let motivationLabel = UILabel()
        motivationLabel.text = "🌟 Your progress = Your character's happiness! 🌟"
        motivationLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        motivationLabel.textColor = .systemBlue
        motivationLabel.textAlignment = .center
        motivationLabel.numberOfLines = 0
        
        // Continue button
        let continueButton = UIButton(type: .system)
        continueButton.setTitle("Start My Journey!", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = .systemBlue
        continueButton.layer.cornerRadius = 25
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        // Add all views to content view
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(statesContainer)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(motivationLabel)
        contentView.addSubview(continueButton)
        
        // Setup constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        statesContainer.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        motivationLabel.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Character states
            statesContainer.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            statesContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statesContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: statesContainer.bottomAnchor, constant: 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            // Motivation
            motivationLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            motivationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            motivationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Continue button
            continueButton.topAnchor.constraint(equalTo: motivationLabel.bottomAnchor, constant: 40),
            continueButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            continueButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            continueButton.heightAnchor.constraint(equalToConstant: 50),
            continueButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func createCharacterStatesView() -> UIView {
        let container = UIView()
        
        // Create three character state cards
        let poorState = createCharacterStateCard(
            emoji: "😔",
            title: "Poor (0/5)",
            description: "No affirmations completed",
            color: .systemGray
        )
        
        let mediumState = createCharacterStateCard(
            emoji: "😊",
            title: "Medium (1-4/5)",
            description: "Making progress!",
            color: .systemOrange
        )
        
        let goodState = createCharacterStateCard(
            emoji: "🎉",
            title: "Good (5/5)",
            description: "All affirmations complete!",
            color: .systemGreen
        )
        
        // Stack view for cards
        let stackView = UIStackView(arrangedSubviews: [poorState, mediumState, goodState])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        
        container.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func createCharacterStateCard(emoji: String, title: String, description: String, color: UIColor) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = color.withAlphaComponent(0.1)
        cardView.layer.cornerRadius = 16
        cardView.layer.borderWidth = 2
        cardView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        
        // Emoji
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 40)
        emojiLabel.textAlignment = .center
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        titleLabel.textColor = color
        titleLabel.textAlignment = .center
        
        // Description
        let descLabel = UILabel()
        descLabel.text = description
        descLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        descLabel.textColor = .label
        descLabel.textAlignment = .center
        descLabel.numberOfLines = 0
        
        // Add subviews
        cardView.addSubview(emojiLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(descLabel)
        
        // Setup constraints
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 120),
            
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            emojiLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            descLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            descLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -16)
        ])
        
        return cardView
    }
    
    // MARK: - Actions
    @objc private func continueButtonTapped() {
        // Mark character introduction as seen
        UserDefaults.standard.set(true, forKey: "hasSeenCharacterIntro")
        
        // Complete onboarding
        onSignUpCompleted?()
    }
}
