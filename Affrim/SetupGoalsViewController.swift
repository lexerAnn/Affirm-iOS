//
//  SetupGoalsViewController.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import UIKit

class SetupGoalsViewController: UIViewController {
    
    // MARK: - Properties
    private var selectedDailyTarget: Int = 0
    private var selectedFocusAreas: Set<String> = []
    private var customTargetValue: Int = 0
    
    // MARK: - UI Components
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Set Up Goals"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .label
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var yourGoalLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Goal"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var goalSummaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Complete 0 affirmations daily from 0 focus areas."
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dailyTargetTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Daily Target"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var dailyTargetDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "How many affirmations would you like to complete each day?"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var targetButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var customTargetLabel: UILabel = {
        let label = UILabel()
        label.text = "Or enter a custom number:"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private lazy var customTargetTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter 1-100"
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(customTargetChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var focusAreasTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Focus Areas"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private lazy var focusAreasDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose the areas you want to focus on. You can select multiple categories."
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var focusAreasStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        return stackView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createTargetButtons()
        createFocusAreaButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Hide tab bar
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show tab bar again when leaving
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add main views
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(saveButton)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add content to scroll view
        contentView.addSubview(yourGoalLabel)
        contentView.addSubview(goalSummaryLabel)
        contentView.addSubview(dailyTargetTitleLabel)
        contentView.addSubview(dailyTargetDescriptionLabel)
        contentView.addSubview(targetButtonsStackView)
        contentView.addSubview(customTargetLabel)
        contentView.addSubview(customTargetTextField)
        contentView.addSubview(focusAreasTitleLabel)
        contentView.addSubview(focusAreasDescriptionLabel)
        contentView.addSubview(focusAreasStackView)
        
        setupConstraints()
    }
    
    private func createTargetButtons() {
        let targets = [3, 5, 10, 15, 20, 25, 30, 50]
        
        // Create two rows of 4 buttons each
        let topRowStack = UIStackView()
        topRowStack.axis = .horizontal
        topRowStack.spacing = 12
        topRowStack.distribution = .fillEqually
        
        let bottomRowStack = UIStackView()
        bottomRowStack.axis = .horizontal
        bottomRowStack.spacing = 12
        bottomRowStack.distribution = .fillEqually
        
        for (index, target) in targets.enumerated() {
            let button = createTargetButton(target: target)
            if index < 4 {
                topRowStack.addArrangedSubview(button)
            } else {
                bottomRowStack.addArrangedSubview(button)
            }
        }
        
        targetButtonsStackView.addArrangedSubview(topRowStack)
        targetButtonsStackView.addArrangedSubview(bottomRowStack)
    }
    
    private func createTargetButton(target: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle("\(target)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.label, for: .highlighted)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.cornerRadius = 8
        button.tag = target
        button.addTarget(self, action: #selector(targetButtonTapped(_:)), for: .touchUpInside)
        
        // Set height constraint
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }
    
    private func createFocusAreaButtons() {
        let focusAreas = ["Confidence", "Health", "Success", "Love", "Peace", "Creativity", "Wealth", "Happiness"]
        
        // Create rows of 2 buttons each
        for i in stride(from: 0, to: focusAreas.count, by: 2) {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 12
            rowStack.distribution = .fillEqually
            
            let leftButton = createFocusAreaButton(title: focusAreas[i])
            rowStack.addArrangedSubview(leftButton)
            
            if i + 1 < focusAreas.count {
                let rightButton = createFocusAreaButton(title: focusAreas[i + 1])
                rowStack.addArrangedSubview(rightButton)
            } else {
                // Add empty view for even spacing
                let emptyView = UIView()
                rowStack.addArrangedSubview(emptyView)
            }
            
            focusAreasStackView.addArrangedSubview(rowStack)
        }
    }
    
    private func createFocusAreaButton(title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.setTitleColor(.label, for: .highlighted)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(focusAreaButtonTapped(_:)), for: .touchUpInside)
        
        // Set height constraint
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        return button
    }
    
    private func setupConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        yourGoalLabel.translatesAutoresizingMaskIntoConstraints = false
        goalSummaryLabel.translatesAutoresizingMaskIntoConstraints = false
        dailyTargetTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        dailyTargetDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        targetButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        customTargetLabel.translatesAutoresizingMaskIntoConstraints = false
        customTargetTextField.translatesAutoresizingMaskIntoConstraints = false
        focusAreasTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        focusAreasDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        focusAreasStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Header constraints
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.widthAnchor.constraint(equalToConstant: 80),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Scroll view constraints
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content view constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Content constraints
            yourGoalLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            yourGoalLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            goalSummaryLabel.topAnchor.constraint(equalTo: yourGoalLabel.bottomAnchor, constant: 8),
            goalSummaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            goalSummaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            dailyTargetTitleLabel.topAnchor.constraint(equalTo: goalSummaryLabel.bottomAnchor, constant: 40),
            dailyTargetTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dailyTargetDescriptionLabel.topAnchor.constraint(equalTo: dailyTargetTitleLabel.bottomAnchor, constant: 8),
            dailyTargetDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dailyTargetDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            targetButtonsStackView.topAnchor.constraint(equalTo: dailyTargetDescriptionLabel.bottomAnchor, constant: 20),
            targetButtonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            targetButtonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            customTargetLabel.topAnchor.constraint(equalTo: targetButtonsStackView.bottomAnchor, constant: 30),
            customTargetLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            customTargetTextField.topAnchor.constraint(equalTo: customTargetLabel.bottomAnchor, constant: 8),
            customTargetTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            customTargetTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            customTargetTextField.heightAnchor.constraint(equalToConstant: 44),
            
            focusAreasTitleLabel.topAnchor.constraint(equalTo: customTargetTextField.bottomAnchor, constant: 40),
            focusAreasTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            focusAreasDescriptionLabel.topAnchor.constraint(equalTo: focusAreasTitleLabel.bottomAnchor, constant: 8),
            focusAreasDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            focusAreasDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            focusAreasStackView.topAnchor.constraint(equalTo: focusAreasDescriptionLabel.bottomAnchor, constant: 20),
            focusAreasStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            focusAreasStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            focusAreasStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func updateGoalSummary() {
        let target = selectedDailyTarget > 0 ? selectedDailyTarget : customTargetValue
        let focusCount = selectedFocusAreas.count
        goalSummaryLabel.text = "Complete \(target) affirmations daily from \(focusCount) focus areas."
    }
    
    // MARK: - Actions
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        let target = selectedDailyTarget > 0 ? selectedDailyTarget : customTargetValue
        
        if target == 0 {
            showAlert(title: "No Target Set", message: "Please select a daily target or enter a custom number.")
            return
        }
        
        if selectedFocusAreas.isEmpty {
            showAlert(title: "No Focus Areas", message: "Please select at least one focus area.")
            return
        }
        
        // Save the goals to UserDefaults
        UserDefaults.standard.set(target, forKey: "dailyTarget")
        UserDefaults.standard.set(Array(selectedFocusAreas), forKey: "focusAreas")
        UserDefaults.standard.set(true, forKey: "hasSetupGoals")
        
        print("Saving goals: \(target) affirmations, Focus areas: \(selectedFocusAreas)")
        
        // Navigate back to stats or main screen
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func targetButtonTapped(_ sender: UIButton) {
        // Reset all target buttons
        for case let stackView as UIStackView in targetButtonsStackView.arrangedSubviews {
            for case let button as UIButton in stackView.arrangedSubviews {
                button.isSelected = false
                button.backgroundColor = .clear
                button.layer.borderColor = UIColor.systemGray4.cgColor
                button.layer.borderWidth = 1
            }
        }
        
        // Select tapped button - black background with white text
        sender.isSelected = true
        sender.backgroundColor = .black
        sender.layer.borderColor = UIColor.black.cgColor
        sender.layer.borderWidth = 1
        
        selectedDailyTarget = sender.tag
        customTargetTextField.text = ""
        customTargetValue = 0
        
        updateGoalSummary()
    }
    
    @objc private func focusAreaButtonTapped(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        
        if selectedFocusAreas.contains(title) {
            // Deselect
            selectedFocusAreas.remove(title)
            sender.isSelected = false
            sender.backgroundColor = .clear
            sender.layer.borderColor = UIColor.systemGray4.cgColor
            sender.layer.borderWidth = 1
        } else {
            // Select - black background with white text
            selectedFocusAreas.insert(title)
            sender.isSelected = true
            sender.backgroundColor = .black
            sender.layer.borderColor = UIColor.black.cgColor
            sender.layer.borderWidth = 1
        }
        
        updateGoalSummary()
    }
    
    @objc private func customTargetChanged() {
        guard let text = customTargetTextField.text, let value = Int(text), value >= 1, value <= 100 else {
            customTargetValue = 0
            updateGoalSummary()
            return
        }
        
        // Reset target buttons when custom value is entered
        for case let stackView as UIStackView in targetButtonsStackView.arrangedSubviews {
            for case let button as UIButton in stackView.arrangedSubviews {
                button.isSelected = false
                button.backgroundColor = .clear
                button.layer.borderColor = UIColor.systemGray4.cgColor
                button.layer.borderWidth = 1
            }
        }
        
        selectedDailyTarget = 0
        customTargetValue = value
        updateGoalSummary()
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
