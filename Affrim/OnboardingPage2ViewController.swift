//
//  OnboardingPage2ViewController.swift
//  Affrim
//
//  Created by Assistant on 13/08/2025.
//

import UIKit

class OnboardingPage2ViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: OnboardingPageDelegate?
    
    // MARK: - UI Components
    private lazy var demoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.wave.2.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var speechBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var speechTextLabel: UILabel = {
        let label = UILabel()
        label.text = "I am confident and capable"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    private lazy var aiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "brain.head.profile")
        imageView.tintColor = .systemPurple
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var matchingLabel: UILabel = {
        let label = UILabel()
        label.text = "✓ Words Matched: 4/4"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .systemGreen
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "We Actually Listen to You"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Real AI that knows if you're doing the work"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var featuresStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See How It Works", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createFeaturesList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startDemoAnimation()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(demoContainerView)
        demoContainerView.addSubview(personImageView)
        demoContainerView.addSubview(speechBubbleView)
        speechBubbleView.addSubview(speechTextLabel)
        demoContainerView.addSubview(aiImageView)
        demoContainerView.addSubview(matchingLabel)
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(featuresStackView)
        view.addSubview(continueButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        demoContainerView.translatesAutoresizingMaskIntoConstraints = false
        personImageView.translatesAutoresizingMaskIntoConstraints = false
        speechBubbleView.translatesAutoresizingMaskIntoConstraints = false
        speechTextLabel.translatesAutoresizingMaskIntoConstraints = false
        aiImageView.translatesAutoresizingMaskIntoConstraints = false
        matchingLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        featuresStackView.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Demo container
            demoContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            demoContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            demoContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            demoContainerView.heightAnchor.constraint(equalToConstant: 140),
            
            // Person image
            personImageView.leadingAnchor.constraint(equalTo: demoContainerView.leadingAnchor, constant: 20),
            personImageView.centerYAnchor.constraint(equalTo: demoContainerView.centerYAnchor, constant: -10),
            personImageView.widthAnchor.constraint(equalToConstant: 40),
            personImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Speech bubble
            speechBubbleView.leadingAnchor.constraint(equalTo: personImageView.trailingAnchor, constant: 10),
            speechBubbleView.topAnchor.constraint(equalTo: personImageView.topAnchor, constant: -10),
            speechBubbleView.trailingAnchor.constraint(equalTo: demoContainerView.centerXAnchor, constant: -10),
            speechBubbleView.heightAnchor.constraint(equalToConstant: 60),
            
            // Speech text
            speechTextLabel.centerXAnchor.constraint(equalTo: speechBubbleView.centerXAnchor),
            speechTextLabel.centerYAnchor.constraint(equalTo: speechBubbleView.centerYAnchor),
            speechTextLabel.leadingAnchor.constraint(equalTo: speechBubbleView.leadingAnchor, constant: 12),
            speechTextLabel.trailingAnchor.constraint(equalTo: speechBubbleView.trailingAnchor, constant: -12),
            
            // AI image
            aiImageView.trailingAnchor.constraint(equalTo: demoContainerView.trailingAnchor, constant: -20),
            aiImageView.centerYAnchor.constraint(equalTo: demoContainerView.centerYAnchor, constant: -10),
            aiImageView.widthAnchor.constraint(equalToConstant: 40),
            aiImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Matching label
            matchingLabel.bottomAnchor.constraint(equalTo: demoContainerView.bottomAnchor, constant: -15),
            matchingLabel.centerXAnchor.constraint(equalTo: demoContainerView.centerXAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: demoContainerView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Features
            featuresStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            featuresStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            featuresStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Continue button
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createFeaturesList() {
        let features = [
            "• Hear every word you speak",
            "• Match it with your chosen affirmation",
            "• Give you real-time feedback",
            "• Track your actual progress, not just app opens"
        ]
        
        for feature in features {
            let label = UILabel()
            label.text = feature
            label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
            featuresStackView.addArrangedSubview(label)
        }
    }
    
    private func startDemoAnimation() {
        // Animate the speech bubble appearing
        speechBubbleView.alpha = 0
        speechBubbleView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.speechBubbleView.alpha = 1
            self.speechBubbleView.transform = CGAffineTransform.identity
        })
        
        // Animate the matching result
        matchingLabel.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 1.5, animations: {
            self.matchingLabel.alpha = 1
        })
        
        // Pulse the AI brain
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [.repeat, .autoreverse], animations: {
            self.aiImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
    }
    
    // MARK: - Actions
    @objc private func continueButtonTapped() {
        delegate?.moveToNextPage()
    }
}
