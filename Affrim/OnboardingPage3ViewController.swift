//
//  OnboardingPage3ViewController.swift
//  Affrim
//
//  Created by Assistant on 13/08/2025.
//

import UIKit

class OnboardingPage3ViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: OnboardingPageDelegate?
    
    // MARK: - UI Components
    private lazy var beforeAfterContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var beforeLabel: UILabel = {
        let label = UILabel()
        label.text = "Before"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemRed
        label.textAlignment = .center
        return label
    }()
    
    private lazy var afterLabel: UILabel = {
        let label = UILabel()
        label.text = "After"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemGreen
        label.textAlignment = .center
        return label
    }()
    
    private lazy var beforeView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var afterView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Stop Pretending You Did Your Affirmations"
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Finally, accountability that actually works"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var problemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var solutionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Being Honest", for: .normal)
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
        createProblemsAndSolutions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startBeforeAfterAnimation()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(beforeAfterContainerView)
        beforeAfterContainerView.addSubview(beforeLabel)
        beforeAfterContainerView.addSubview(afterLabel)
        beforeAfterContainerView.addSubview(beforeView)
        beforeAfterContainerView.addSubview(afterView)
        
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(problemsStackView)
        view.addSubview(solutionsStackView)
        view.addSubview(continueButton)
        
        setupBeforeAfterViews()
        setupConstraints()
    }
    
    private func setupBeforeAfterViews() {
        // Before view - scattered circles
        for i in 0..<6 {
            let circle = UIView()
            circle.backgroundColor = .systemRed.withAlphaComponent(0.6)
            circle.layer.cornerRadius = 8
            circle.translatesAutoresizingMaskIntoConstraints = false
            beforeView.addSubview(circle)
            
            NSLayoutConstraint.activate([
                circle.widthAnchor.constraint(equalToConstant: 16),
                circle.heightAnchor.constraint(equalToConstant: 16),
                circle.centerXAnchor.constraint(equalTo: beforeView.centerXAnchor, constant: CGFloat.random(in: -30...30)),
                circle.centerYAnchor.constraint(equalTo: beforeView.centerYAnchor, constant: CGFloat.random(in: -20...20))
            ])
        }
        
        // After view - organized circles
        for i in 0..<6 {
            let circle = UIView()
            circle.backgroundColor = .systemGreen.withAlphaComponent(0.8)
            circle.layer.cornerRadius = 8
            circle.translatesAutoresizingMaskIntoConstraints = false
            afterView.addSubview(circle)
            
            let row = i / 3
            let col = i % 3
            
            NSLayoutConstraint.activate([
                circle.widthAnchor.constraint(equalToConstant: 16),
                circle.heightAnchor.constraint(equalToConstant: 16),
                circle.centerXAnchor.constraint(equalTo: afterView.centerXAnchor, constant: CGFloat(col - 1) * 20),
                circle.centerYAnchor.constraint(equalTo: afterView.centerYAnchor, constant: CGFloat(row) * 20 - 10)
            ])
        }
    }
    
    private func setupConstraints() {
        beforeAfterContainerView.translatesAutoresizingMaskIntoConstraints = false
        beforeLabel.translatesAutoresizingMaskIntoConstraints = false
        afterLabel.translatesAutoresizingMaskIntoConstraints = false
        beforeView.translatesAutoresizingMaskIntoConstraints = false
        afterView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        problemsStackView.translatesAutoresizingMaskIntoConstraints = false
        solutionsStackView.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Before/After container
            beforeAfterContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            beforeAfterContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            beforeAfterContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            beforeAfterContainerView.heightAnchor.constraint(equalToConstant: 120),
            
            // Before label
            beforeLabel.topAnchor.constraint(equalTo: beforeAfterContainerView.topAnchor, constant: 8),
            beforeLabel.leadingAnchor.constraint(equalTo: beforeAfterContainerView.leadingAnchor, constant: 20),
            beforeLabel.trailingAnchor.constraint(equalTo: beforeAfterContainerView.centerXAnchor, constant: -10),
            
            // After label
            afterLabel.topAnchor.constraint(equalTo: beforeAfterContainerView.topAnchor, constant: 8),
            afterLabel.leadingAnchor.constraint(equalTo: beforeAfterContainerView.centerXAnchor, constant: 10),
            afterLabel.trailingAnchor.constraint(equalTo: beforeAfterContainerView.trailingAnchor, constant: -20),
            
            // Before view
            beforeView.topAnchor.constraint(equalTo: beforeLabel.bottomAnchor, constant: 8),
            beforeView.leadingAnchor.constraint(equalTo: beforeAfterContainerView.leadingAnchor, constant: 20),
            beforeView.trailingAnchor.constraint(equalTo: beforeAfterContainerView.centerXAnchor, constant: -10),
            beforeView.bottomAnchor.constraint(equalTo: beforeAfterContainerView.bottomAnchor, constant: -8),
            
            // After view
            afterView.topAnchor.constraint(equalTo: afterLabel.bottomAnchor, constant: 8),
            afterView.leadingAnchor.constraint(equalTo: beforeAfterContainerView.centerXAnchor, constant: 10),
            afterView.trailingAnchor.constraint(equalTo: beforeAfterContainerView.trailingAnchor, constant: -20),
            afterView.bottomAnchor.constraint(equalTo: beforeAfterContainerView.bottomAnchor, constant: -8),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: beforeAfterContainerView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Problems
            problemsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 25),
            problemsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            problemsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Solutions
            solutionsStackView.topAnchor.constraint(equalTo: problemsStackView.bottomAnchor, constant: 20),
            solutionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            solutionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Continue button
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createProblemsAndSolutions() {
        let problems = [
            "❌ Skipping days and lying to yourself",
            "❌ Rushing through without really focusing",
            "❌ Wondering if affirmations actually work"
        ]
        
        let solutions = [
            "✅ Now get real accountability",
            "✅ Build genuine habits that stick",
            "✅ See measurable progress every day"
        ]
        
        for problem in problems {
            let label = UILabel()
            label.text = problem
            label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            label.textColor = .secondaryLabel
            label.numberOfLines = 0
            problemsStackView.addArrangedSubview(label)
        }
        
        for solution in solutions {
            let label = UILabel()
            label.text = solution
            label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label.textColor = .systemGreen
            label.numberOfLines = 0
            solutionsStackView.addArrangedSubview(label)
        }
    }
    
    private func startBeforeAfterAnimation() {
        // Animate the before circles (chaotic movement)
        for subview in beforeView.subviews {
            UIView.animate(withDuration: 2.0, delay: Double.random(in: 0...1), options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
                subview.transform = CGAffineTransform(
                    translationX: CGFloat.random(in: -15...15),
                    y: CGFloat.random(in: -10...10)
                )
            })
        }
        
        // Animate the after circles (gentle, organized pulse)
        for (index, subview) in afterView.subviews.enumerated() {
            UIView.animate(withDuration: 1.5, delay: Double(index) * 0.1, options: [.repeat, .autoreverse], animations: {
                subview.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            })
        }
    }
    
    // MARK: - Actions
    @objc private func continueButtonTapped() {
        delegate?.moveToNextPage()
    }
}
