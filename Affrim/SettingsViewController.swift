//
//  SettingsViewController.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import UIKit

class SettingsViewController: UIViewController {

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
        label.text = "Settings"
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show navigation bar for settings
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Set background color
        view.backgroundColor = .systemBackground
        
        // Add main views
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(mainStackView)
        
        // Create sections
        createAppSettingsSection()
        createSupportFeedbackSection()
        createFollowUsSection()
        createLegalSection()
        createAccountSection()
        createVersionLabel()
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Main stack view constraints
            mainStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Section Creation
    private func createAppSettingsSection() {
        let sectionView = createSectionView(title: "APP SETTINGS")
        
        let notificationsView = createSettingItemView(
            title: "Notifications",
            subtitle: "Daily reminders and alerts",
            hasToggle: true,
            action: #selector(notificationsTapped)
        )
        
        let privacyView = createSettingItemView(
            title: "Privacy & Data",
            subtitle: "Control your data and privacy",
            hasToggle: false,
            action: #selector(privacyTapped)
        )
        
        sectionView.addArrangedSubview(notificationsView)
        sectionView.addArrangedSubview(privacyView)
        mainStackView.addArrangedSubview(sectionView)
    }
    
    private func createSupportFeedbackSection() {
        let sectionView = createSectionView(title: "SUPPORT & FEEDBACK")
        
        let reviewView = createSettingItemView(
            title: "Leave a Review",
            subtitle: "Rate us on the App Store",
            hasToggle: false,
            action: #selector(reviewTapped)
        )
        
        let supportView = createSettingItemView(
            title: "Contact Support",
            subtitle: "Tell your friends about VoiceGrow",
            hasToggle: false,
            action: #selector(contactTapped)
        )
        
        sectionView.addArrangedSubview(reviewView)
        sectionView.addArrangedSubview(supportView)
        mainStackView.addArrangedSubview(sectionView)
    }
    
    private func createFollowUsSection() {
        let sectionView = createSectionView(title: "FOLLOW US")
        
        let socialView = createSettingItemView(
            title: "Social Media",
            subtitle: "Follow us for updates and tips",
            hasToggle: false,
            action: #selector(socialTapped)
        )
        
        let shareView = createSettingItemView(
            title: "Share App",
            subtitle: "Tell your friends about VoiceGrow",
            hasToggle: false,
            action: #selector(shareTapped)
        )
        
        sectionView.addArrangedSubview(socialView)
        sectionView.addArrangedSubview(shareView)
        mainStackView.addArrangedSubview(sectionView)
    }
    
    private func createLegalSection() {
        let sectionView = createSectionView(title: "LEGAL")
        
        let termsView = createSettingItemView(
            title: "Terms of Service",
            subtitle: nil,
            hasToggle: false,
            action: #selector(termsTapped)
        )
        
        let privacyPolicyView = createSettingItemView(
            title: "Privacy Policy",
            subtitle: nil,
            hasToggle: false,
            action: #selector(privacyPolicyTapped)
        )
        
        sectionView.addArrangedSubview(termsView)
        sectionView.addArrangedSubview(privacyPolicyView)
        mainStackView.addArrangedSubview(sectionView)
    }
    
    private func createAccountSection() {
        let sectionView = createSectionView(title: "ACCOUNT")
        
        let logoutView = createLogoutItemView()
        
        sectionView.addArrangedSubview(logoutView)
        mainStackView.addArrangedSubview(sectionView)
    }
    
    private func createVersionLabel() {
        let versionLabel = UILabel()
        versionLabel.text = "VoiceGrow v1.2.0"
        versionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        versionLabel.textColor = .systemGray
        versionLabel.textAlignment = .center
        
        mainStackView.addArrangedSubview(versionLabel)
    }
    
    // MARK: - Helper Methods
    private func createSectionView(title: String) -> UIStackView {
        let sectionStackView = UIStackView()
        sectionStackView.axis = .vertical
        sectionStackView.spacing = 0
        sectionStackView.alignment = .fill
        
        let sectionHeaderLabel = UILabel()
        sectionHeaderLabel.text = title
        sectionHeaderLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        sectionHeaderLabel.textColor = .systemGray
        
        sectionStackView.addArrangedSubview(sectionHeaderLabel)
        
        // Add spacing after header
        let spacerView = UIView()
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        sectionStackView.addArrangedSubview(spacerView)
        
        return sectionStackView
    }
    
    private func createSettingItemView(title: String, subtitle: String?, hasToggle: Bool, action: Selector) -> UIView {
        let containerView = UIView()
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = .label
        
        containerView.addSubview(button)
        containerView.addSubview(titleLabel)
        
        if let subtitle = subtitle {
            let subtitleLabel = UILabel()
            subtitleLabel.text = subtitle
            subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            subtitleLabel.textColor = .systemGray
            containerView.addSubview(subtitleLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
                subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                subtitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
            ])
        } else {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
                titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15)
            ])
        }
        
        if hasToggle {
            let toggle = UISwitch()
            toggle.isOn = true
            toggle.addTarget(self, action: #selector(toggleValueChanged(_:)), for: .valueChanged)
            containerView.addSubview(toggle)
            
            toggle.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                toggle.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                toggle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            ])
        } else {
            let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
            chevronImageView.tintColor = .systemGray3
            chevronImageView.contentMode = .scaleAspectFit
            containerView.addSubview(chevronImageView)
            
            chevronImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
                chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                chevronImageView.widthAnchor.constraint(equalToConstant: 12),
                chevronImageView.heightAnchor.constraint(equalToConstant: 12)
            ])
        }
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: containerView.topAnchor),
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        return containerView
    }
    
    private func createLogoutItemView() -> UIView {
        let containerView = UIView()
        
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        
        let titleLabel = UILabel()
        titleLabel.text = "Logout"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = .systemRed
        
        containerView.addSubview(button)
        containerView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            
            button.topAnchor.constraint(equalTo: containerView.topAnchor),
            button.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    // MARK: - Actions
    @objc private func notificationsTapped() {
        print("Notifications tapped")
    }
    
    @objc private func privacyTapped() {
        print("Privacy & Data tapped")
        
        // For testing - allow reset of goals setup
        let alert = UIAlertController(
            title: "Privacy & Data",
            message: "Reset daily goals setup (for testing)?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "hasSetupGoals")
            UserDefaults.standard.removeObject(forKey: "dailyTarget")
            UserDefaults.standard.removeObject(forKey: "focusAreas")
            print("Goals setup reset")
        })
        
        present(alert, animated: true)
    }
    
    @objc private func reviewTapped() {
        print("Leave a Review tapped")
    }
    
    @objc private func contactTapped() {
        print("Contact Support tapped")
    }
    
    @objc private func socialTapped() {
        print("Social Media tapped")
    }
    
    @objc private func shareTapped() {
        print("Share App tapped")
    }
    
    @objc private func termsTapped() {
        print("Terms of Service tapped")
    }
    
    @objc private func privacyPolicyTapped() {
        print("Privacy Policy tapped")
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            print("User logged out")
        })
        
        present(alert, animated: true)
    }
    
    @objc private func toggleValueChanged(_ sender: UISwitch) {
        print("Toggle changed to: \(sender.isOn)")
    }
}
