//
//  DailyGoalsWelcomeViewController.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import UIKit

class DailyGoalsWelcomeViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Daily Goals"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Start your affirmation journey by setting up your daily practice. Choose how many affirmation you'd like to complete and pick your focus areas"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var benefitsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var setupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set Up Your Goals", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(setupButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add main views
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(benefitsStackView)
        contentView.addSubview(setupButton)
        
        // Create benefit items
        createBenefitItems()
        
        setupConstraints()
    }
    
    private func createBenefitItems() {
        let benefits = [
            "Track your daily progress",
            "Build a consistent practice",
            "Choose your focus area",
            "Achieve your daily goals"
        ]
        
        for benefit in benefits {
            let benefitLabel = UILabel()
            benefitLabel.text = benefit
            benefitLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            benefitLabel.textColor = .label
            benefitLabel.textAlignment = .center
            benefitsStackView.addArrangedSubview(benefitLabel)
        }
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        benefitsStackView.translatesAutoresizingMaskIntoConstraints = false
        setupButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title label constraints
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            // Description label constraints
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            // Benefits stack view constraints
            benefitsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 60),
            benefitsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            benefitsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            
            // Setup button constraints
            setupButton.topAnchor.constraint(equalTo: benefitsStackView.bottomAnchor, constant: 80),
            setupButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            setupButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            setupButton.heightAnchor.constraint(equalToConstant: 50),
            setupButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    // MARK: - Actions
    @objc private func setupButtonTapped() {
        let setupGoalsVC = SetupGoalsViewController()
        navigationController?.pushViewController(setupGoalsVC, animated: true)
    }
}
