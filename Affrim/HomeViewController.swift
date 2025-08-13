//
//  HomeViewController.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var categoriesButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Categories", for: .normal)
        button.setImage(UIImage(systemName: "triangle.fill"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.tintColor = .label
        button.backgroundColor = .clear
        
        // Arrange image and title
        button.semanticContentAttribute = .forceLeftToRight
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        
        // Add target action
        button.addTarget(self, action: #selector(categoriesButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var affirmationListView = AffirmationListView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide navigation bar for clean look
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Refresh selected category in case it changed
        loadSelectedCategory()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // Set background color
        view.backgroundColor = .systemBackground
        
        // Hide navigation bar for clean look
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add subviews
        view.addSubview(categoriesButton)
        view.addSubview(chevronImageView)
        view.addSubview(affirmationListView)
        
        // Set up constraints
        categoriesButton.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        affirmationListView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Categories button constraints
            categoriesButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            categoriesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -15),
            categoriesButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Chevron image constraints
            chevronImageView.centerYAnchor.constraint(equalTo: categoriesButton.centerYAnchor),
            chevronImageView.leadingAnchor.constraint(equalTo: categoriesButton.trailingAnchor, constant: 8),
            chevronImageView.widthAnchor.constraint(equalToConstant: 16),
            chevronImageView.heightAnchor.constraint(equalToConstant: 16),
            
            // Affirmation list view constraints
            affirmationListView.topAnchor.constraint(equalTo: categoriesButton.bottomAnchor, constant: 20),
            affirmationListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            affirmationListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            affirmationListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Load any previously selected category
        loadSelectedCategory()
    }
    
    private func loadSelectedCategory() {
        // Update categories button title
        updateCategoriesButton()
        
        // Load affirmations for selected category if available
        if let selectedCategoryTitle = UserDefaults.standard.string(forKey: "selectedCategoryTitle") {
            // Find the category model
            if let selectedCategory = CategoryModel.sampleCategories.first(where: { $0.title == selectedCategoryTitle }) {
                affirmationListView.updateAffirmations(selectedCategory.affirmations)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func categoriesButtonTapped() {
        let categoriesVC = CategoriesViewController()
        categoriesVC.onCategorySelected = { [weak self] category in
            self?.updateSelectedCategory(category)
        }
        navigationController?.pushViewController(categoriesVC, animated: true)
    }
    
    private func updateSelectedCategory(_ category: CategoryModel) {
        // Save selected category
        UserDefaults.standard.set(category.title, forKey: "selectedCategoryTitle")
        
        // Update the categories button to show selected category
        updateCategoriesButton()
        
        // Update affirmations to show selected category's affirmations
        affirmationListView.updateAffirmations(category.affirmations)
    }
    
    private func updateCategoriesButton() {
        let selectedCategoryTitle = UserDefaults.standard.string(forKey: "selectedCategoryTitle") ?? "Categories"
        categoriesButton.setTitle(selectedCategoryTitle, for: .normal)
    }
}
