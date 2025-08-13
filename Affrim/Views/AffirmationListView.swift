//
//  AffirmationListView.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import UIKit

class AffirmationListView: UIView {
    
    // MARK: - Properties
    private var affirmations: [AffirmationModel] = []
    private var currentIndex = 0
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(AffirmationCell.self, forCellWithReuseIdentifier: AffirmationCell.identifier)
        
        return collectionView
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        loadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        loadData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        
        addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Collection view constraints
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func loadData() {
        affirmations = AffirmationModel.sampleAffirmations
        collectionView.reloadData()
    }
    
    // MARK: - Public Methods
    func updateAffirmations(_ newAffirmations: [AffirmationModel]) {
        affirmations = newAffirmations
        collectionView.reloadData()
        
        // Reset to first affirmation
        if !affirmations.isEmpty {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
            currentIndex = 0
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AffirmationListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return affirmations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AffirmationCell.identifier, for: indexPath) as! AffirmationCell
        cell.configure(with: affirmations[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AffirmationListView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

// MARK: - UIScrollViewDelegate
extension AffirmationListView: UIScrollViewDelegate {
    // Removed page control update since we no longer have page control
}

// MARK: - AffirmationCell
class AffirmationCell: UICollectionViewCell {
    static let identifier = "AffirmationCell"
    
    // MARK: - UI Components
    private lazy var quoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "quote.bubble")
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var affirmationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .label
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var microphoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "mic.fill")
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 40
        stack.distribution = .fill
        return stack
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        
        contentView.addSubview(stackView)
        
        // Add arranged subviews
        stackView.addArrangedSubview(quoteImageView)
        stackView.addArrangedSubview(affirmationLabel)
        stackView.addArrangedSubview(microphoneImageView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Stack view constraints
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            // Quote image constraints
            quoteImageView.widthAnchor.constraint(equalToConstant: 40),
            quoteImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Microphone image constraints
            microphoneImageView.widthAnchor.constraint(equalToConstant: 60),
            microphoneImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Configuration
    func configure(with affirmation: AffirmationModel) {
        affirmationLabel.text = affirmation.text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        affirmationLabel.text = nil
    }
}
