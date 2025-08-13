//
//  ViewController.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Set background color
        view.backgroundColor = .systemBackground
        
        // Add a simple label as an example
        let label = UILabel()
        label.text = "Hello, Programmatic UI!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .label
        
        // Add label to view
        view.addSubview(label)
        
        // Set up constraints
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

