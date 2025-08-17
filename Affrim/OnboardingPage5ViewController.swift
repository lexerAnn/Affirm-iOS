//
//  OnboardingPage5ViewController.swift
//  Affrim
//
//  Created by Assistant on 13/08/2025.
//

import UIKit

class OnboardingPage5ViewController: UIViewController {
    
    // MARK: - Properties
    var onSignUpCompleted: (() -> Void)?
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ready to Stop Lying to Yourself?"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your transformation starts with your first honest affirmation"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var freeTrialView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemBlue.cgColor
        return view
    }()
    
    private lazy var freeTrialTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "🎁 7-Day Free Trial Includes:"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        return label
    }()
    
    private lazy var freeTrialFeaturesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var premiumView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple.withAlphaComponent(0.1)
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.systemPurple.cgColor
        return view
    }()
    
    private lazy var premiumTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "💎 Premium Members Get:"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemPurple
        label.textAlignment = .center
        return label
    }()
    
    private lazy var premiumFeaturesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var urgencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Limited spots available - Join 500+ people starting this week"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemOrange
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var freeTrialButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Free Trial", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(freeTrialButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var premiumButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue with Premium", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.systemPurple, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemPurple.cgColor
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(premiumButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var trustSignalsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createFeatureLists()
        createTrustSignals()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startUrgencyAnimation()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(freeTrialView)
        freeTrialView.addSubview(freeTrialTitleLabel)
        freeTrialView.addSubview(freeTrialFeaturesStackView)
        
        view.addSubview(premiumView)
        premiumView.addSubview(premiumTitleLabel)
        premiumView.addSubview(premiumFeaturesStackView)
        
        view.addSubview(urgencyLabel)
        view.addSubview(freeTrialButton)
        view.addSubview(premiumButton)
        view.addSubview(trustSignalsStackView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        freeTrialView.translatesAutoresizingMaskIntoConstraints = false
        freeTrialTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        freeTrialFeaturesStackView.translatesAutoresizingMaskIntoConstraints = false
        premiumView.translatesAutoresizingMaskIntoConstraints = false
        premiumTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        premiumFeaturesStackView.translatesAutoresizingMaskIntoConstraints = false
        urgencyLabel.translatesAutoresizingMaskIntoConstraints = false
        freeTrialButton.translatesAutoresizingMaskIntoConstraints = false
        premiumButton.translatesAutoresizingMaskIntoConstraints = false
        trustSignalsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Free trial view
            freeTrialView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 25),
            freeTrialView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            freeTrialView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            freeTrialView.heightAnchor.constraint(equalToConstant: 140),
            
            // Free trial title
            freeTrialTitleLabel.topAnchor.constraint(equalTo: freeTrialView.topAnchor, constant: 16),
            freeTrialTitleLabel.leadingAnchor.constraint(equalTo: freeTrialView.leadingAnchor, constant: 16),
            freeTrialTitleLabel.trailingAnchor.constraint(equalTo: freeTrialView.trailingAnchor, constant: -16),
            
            // Free trial features
            freeTrialFeaturesStackView.topAnchor.constraint(equalTo: freeTrialTitleLabel.bottomAnchor, constant: 12),
            freeTrialFeaturesStackView.leadingAnchor.constraint(equalTo: freeTrialView.leadingAnchor, constant: 20),
            freeTrialFeaturesStackView.trailingAnchor.constraint(equalTo: freeTrialView.trailingAnchor, constant: -16),
            
            // Premium view
            premiumView.topAnchor.constraint(equalTo: freeTrialView.bottomAnchor, constant: 16),
            premiumView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            premiumView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            premiumView.heightAnchor.constraint(equalToConstant: 120),
            
            // Premium title
            premiumTitleLabel.topAnchor.constraint(equalTo: premiumView.topAnchor, constant: 16),
            premiumTitleLabel.leadingAnchor.constraint(equalTo: premiumView.leadingAnchor, constant: 16),
            premiumTitleLabel.trailingAnchor.constraint(equalTo: premiumView.trailingAnchor, constant: -16),
            
            // Premium features
            premiumFeaturesStackView.topAnchor.constraint(equalTo: premiumTitleLabel.bottomAnchor, constant: 12),
            premiumFeaturesStackView.leadingAnchor.constraint(equalTo: premiumView.leadingAnchor, constant: 20),
            premiumFeaturesStackView.trailingAnchor.constraint(equalTo: premiumView.trailingAnchor, constant: -16),
            
            // Urgency label
            urgencyLabel.topAnchor.constraint(equalTo: premiumView.bottomAnchor, constant: 20),
            urgencyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            urgencyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Free trial button
            freeTrialButton.topAnchor.constraint(equalTo: urgencyLabel.bottomAnchor, constant: 25),
            freeTrialButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            freeTrialButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            freeTrialButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Premium button
            premiumButton.topAnchor.constraint(equalTo: freeTrialButton.bottomAnchor, constant: 12),
            premiumButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            premiumButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            premiumButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Trust signals
            trustSignalsStackView.topAnchor.constraint(equalTo: premiumButton.bottomAnchor, constant: 20),
            trustSignalsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            trustSignalsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            trustSignalsStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func createFeatureLists() {
        let freeFeatures = [
            "• Unlimited affirmation tracking",
            "• All 8 focus categories",
            "• Daily progress reports",
            "• Voice accuracy scoring"
        ]
        
        let premiumFeatures = [
            "• Personalized affirmation creation",
            "• Advanced analytics",
            "• Priority support"
        ]
        
        for feature in freeFeatures {
            let label = UILabel()
            label.text = feature
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = .systemBlue
            label.numberOfLines = 0
            freeTrialFeaturesStackView.addArrangedSubview(label)
        }
        
        for feature in premiumFeatures {
            let label = UILabel()
            label.text = feature
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textColor = .systemPurple
            label.numberOfLines = 0
            premiumFeaturesStackView.addArrangedSubview(label)
        }
    }
    
    private func createTrustSignals() {
        let trustSignals = [
            "No credit card required",
            "Cancel anytime",
            "30-day guarantee"
        ]
        
        for signal in trustSignals {
            let label = UILabel()
            label.text = signal
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label.textColor = .systemGray
            label.textAlignment = .center
            label.numberOfLines = 0
            trustSignalsStackView.addArrangedSubview(label)
        }
    }
    
    private func startUrgencyAnimation() {
        // Pulse the urgency label
        UIView.animate(withDuration: 1.5, delay: 1.0, options: [.repeat, .autoreverse], animations: {
            self.urgencyLabel.alpha = 0.7
        })
        
        // Highlight the free trial button
        UIView.animate(withDuration: 0.8, delay: 2.0, options: [.repeat, .autoreverse], animations: {
            self.freeTrialButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        })
    }
    
    // MARK: - Actions
    @objc private func freeTrialButtonTapped() {
        // Show loading state
        freeTrialButton.isEnabled = false
        freeTrialButton.setTitle("Starting Trial...", for: .normal)
        
        // Simulate signup process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            // Mark as signed up
            UserDefaults.standard.set(true, forKey: "hasSignedUp")
            UserDefaults.standard.set("free_trial", forKey: "subscriptionType")
            
            // Complete onboarding
            self?.onSignUpCompleted?()
        }
    }
    
    @objc private func premiumButtonTapped() {
        // Show loading state
        premiumButton.isEnabled = false
        premiumButton.setTitle("Starting Premium...", for: .normal)
        
        // Simulate premium signup process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            // Mark as signed up with premium
            UserDefaults.standard.set(true, forKey: "hasSignedUp")
            UserDefaults.standard.set("premium", forKey: "subscriptionType")
            
            // Complete onboarding
            self?.onSignUpCompleted?()
        }
    }
}
