//
//  OnboardingPage1ViewController.swift
//  Affrim
//
//  Created by Assistant on 13/08/2025.
//

import UIKit

// MARK: - Onboarding Delegate Protocol
protocol OnboardingPageDelegate: AnyObject {
    func moveToNextPage()
}

class OnboardingPage1ViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: OnboardingPageDelegate?
    
    // MARK: - UI Components
    private lazy var microphoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mic.fill")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var soundWave1: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var soundWave2: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.5)
        view.layer.cornerRadius = 6
        return view
    }()
    
    private lazy var soundWave3: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue.withAlphaComponent(0.7)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Voice Has Power"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Speak your affirmations, and watch them come to life"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Transform your daily practice with the world's first voice-powered affirmation app. Simply speak your intentions, and our AI listens to ensure you're building the habit that changes everything."
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Discover Your Voice", for: .normal)
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSoundWaveAnimation()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(microphoneImageView)
        view.addSubview(soundWave1)
        view.addSubview(soundWave2)
        view.addSubview(soundWave3)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(continueButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        microphoneImageView.translatesAutoresizingMaskIntoConstraints = false
        soundWave1.translatesAutoresizingMaskIntoConstraints = false
        soundWave2.translatesAutoresizingMaskIntoConstraints = false
        soundWave3.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Microphone image
            microphoneImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            microphoneImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            microphoneImageView.widthAnchor.constraint(equalToConstant: 80),
            microphoneImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Sound waves
            soundWave1.centerYAnchor.constraint(equalTo: microphoneImageView.centerYAnchor),
            soundWave1.leadingAnchor.constraint(equalTo: microphoneImageView.trailingAnchor, constant: 20),
            soundWave1.widthAnchor.constraint(equalToConstant: 8),
            soundWave1.heightAnchor.constraint(equalToConstant: 30),
            
            soundWave2.centerYAnchor.constraint(equalTo: microphoneImageView.centerYAnchor),
            soundWave2.leadingAnchor.constraint(equalTo: soundWave1.trailingAnchor, constant: 8),
            soundWave2.widthAnchor.constraint(equalToConstant: 12),
            soundWave2.heightAnchor.constraint(equalToConstant: 50),
            
            soundWave3.centerYAnchor.constraint(equalTo: microphoneImageView.centerYAnchor),
            soundWave3.leadingAnchor.constraint(equalTo: soundWave2.trailingAnchor, constant: 8),
            soundWave3.widthAnchor.constraint(equalToConstant: 16),
            soundWave3.heightAnchor.constraint(equalToConstant: 70),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: microphoneImageView.bottomAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            // Continue button
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func startSoundWaveAnimation() {
        // Animate sound waves
        UIView.animate(withDuration: 0.8, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.soundWave1.transform = CGAffineTransform(scaleX: 1, y: 1.5)
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [.repeat, .autoreverse], animations: {
            self.soundWave2.transform = CGAffineTransform(scaleX: 1, y: 1.3)
        })
        
        UIView.animate(withDuration: 1.0, delay: 0.4, options: [.repeat, .autoreverse], animations: {
            self.soundWave3.transform = CGAffineTransform(scaleX: 1, y: 1.2)
        })
    }
    
    // MARK: - Actions
    @objc private func continueButtonTapped() {
        delegate?.moveToNextPage()
    }
}
