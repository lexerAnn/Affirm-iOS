//
//  AffirmationListView.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import UIKit
import Combine

class AffirmationListView: UIView {
    
    // MARK: - Properties
    private var affirmations: [AffirmationModel] = []
    private var currentIndex = 0
    private var viewModel = AudioAffirmationViewModel()
    private var cancellables = Set<AnyCancellable>()
    
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
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        loadData()
        bindViewModel()
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
    
    private func bindViewModel() {
        // Bind recording state to update microphone icon
        viewModel.$isRecording
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isRecording in
                self?.updateCurrentCellMicrophoneState(isRecording: isRecording)
            }
            .store(in: &cancellables)
        
        // Bind highlighted words to highlight in current cell
        viewModel.$highlightedWords
            .receive(on: DispatchQueue.main)
            .sink { [weak self] words in
                if !words.isEmpty {
                    self?.updateCurrentCellWithHighlighting(words)
                }
            }
            .store(in: &cancellables)
        
        // Bind loading states
        viewModel.$isTranscribing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isTranscribing in
                self?.updateCurrentCellLoadingState(isLoading: isTranscribing)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func updateAffirmations(_ newAffirmations: [AffirmationModel]) {
        affirmations = newAffirmations
        collectionView.reloadData()
        
        // Reset to first affirmation
        if !affirmations.isEmpty {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
            currentIndex = 0
            viewModel.setCurrentAffirmation(affirmations[0].text)
        }
    }
    
    // MARK: - Private Methods
    private func updateCurrentCellMicrophoneState(isRecording: Bool) {
        guard let cell = getCurrentCell() else { return }
        cell.updateMicrophoneState(isRecording: isRecording)
    }
    
    private func updateCurrentCellLoadingState(isLoading: Bool) {
        guard let cell = getCurrentCell() else { return }
        cell.updateLoadingState(isLoading: isLoading)
    }
    
    private func updateCurrentCellWithHighlighting(_ words: [HighlightedWord]) {
        guard let cell = getCurrentCell() else { return }
        cell.highlightMatchedWords(words)
    }
    
    private func getCurrentCell() -> AffirmationCell? {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        return collectionView.cellForItem(at: indexPath) as? AffirmationCell
    }
    
    private func microphoneButtonTapped() {
        viewModel.toggleRecording()
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
        
        // Set up microphone tap handler
        cell.onMicrophoneTapped = { [weak self] in
            self?.microphoneButtonTapped()
        }
        
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
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        currentIndex = pageIndex
        
        // Set current affirmation in ViewModel and reset highlighting
        if pageIndex < affirmations.count {
            viewModel.setCurrentAffirmation(affirmations[pageIndex].text)
        }
    }
}

// MARK: - AffirmationCell
class AffirmationCell: UICollectionViewCell {
    static let identifier = "AffirmationCell"
    
    // MARK: - Properties
    var onMicrophoneTapped: (() -> Void)?
    private var originalText: String = ""
    private var wordLabels: [UILabel] = []
    
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
    
    private lazy var microphoneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        button.tintColor = .label
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(microphoneButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.color = .systemBlue
        return indicator
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
        contentView.addSubview(loadingIndicator)
        
        // Add arranged subviews
        stackView.addArrangedSubview(quoteImageView)
        stackView.addArrangedSubview(affirmationLabel)
        stackView.addArrangedSubview(microphoneButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Stack view constraints
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            // Quote image constraints
            quoteImageView.widthAnchor.constraint(equalToConstant: 40),
            quoteImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Microphone button constraints
            microphoneButton.widthAnchor.constraint(equalToConstant: 60),
            microphoneButton.heightAnchor.constraint(equalToConstant: 60),
            
            // Loading indicator constraints (overlay on text)
            loadingIndicator.centerXAnchor.constraint(equalTo: affirmationLabel.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: affirmationLabel.centerYAnchor)
        ])
    }
    
    // MARK: - Configuration
    func configure(with affirmation: AffirmationModel) {
        originalText = affirmation.text
        affirmationLabel.text = affirmation.text
        
        // Reset states
        updateMicrophoneState(isRecording: false)
        updateLoadingState(isLoading: false)
        resetHighlighting()
    }
    
    // MARK: - Public Methods
    func updateMicrophoneState(isRecording: Bool) {
        UIView.animate(withDuration: 0.3) {
            if isRecording {
                self.microphoneButton.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
                self.microphoneButton.tintColor = .systemRed
                self.microphoneButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } else {
                self.microphoneButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
                self.microphoneButton.tintColor = .label
                self.microphoneButton.transform = CGAffineTransform.identity
            }
        }
    }
    
    func updateLoadingState(isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
            // Keep text completely normal - no dimming or fading
        } else {
            loadingIndicator.stopAnimating()
        }
        // Text always stays at full opacity and normal appearance
        affirmationLabel.alpha = 1.0
    }
    
    func highlightMatchedWords(_ words: [HighlightedWord]) {
        // Create attributed string with highlighting for matched words only
        let attributedString = NSMutableAttributedString(string: originalText)
        
        // Default attributes - keep original text appearance
        let defaultAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 24, weight: .medium),
            .foregroundColor: UIColor.label
        ]
        attributedString.addAttributes(defaultAttributes, range: NSRange(location: 0, length: originalText.count))
        
        // Find and highlight ONLY matched words - leave unmatched words unchanged
        let originalWords = originalText.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        var currentIndex = 0
        
        for (wordIndex, highlightedWord) in words.enumerated() {
            if wordIndex < originalWords.count {
                let wordToFind = originalWords[wordIndex]
                let wordRange = (originalText as NSString).range(of: wordToFind, options: [], range: NSRange(location: currentIndex, length: originalText.count - currentIndex))
                
                if wordRange.location != NSNotFound {
                    // ONLY highlight matched words that are also highlighted
                    if highlightedWord.isMatched && highlightedWord.isHighlighted {
                        // Highlight matched words with blue background
                        let highlightAttributes: [NSAttributedString.Key: Any] = [
                            .backgroundColor: UIColor.systemBlue,
                            .foregroundColor: UIColor.white,
                            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
                        ]
                        attributedString.addAttributes(highlightAttributes, range: wordRange)
                    }
                    // Do NOT change unmatched words - they keep original appearance
                    currentIndex = wordRange.location + wordRange.length
                }
            }
        }
        
        affirmationLabel.attributedText = attributedString
    }
    
    func resetHighlighting() {
        affirmationLabel.attributedText = nil
        affirmationLabel.text = originalText
    }
    
    // MARK: - Actions
    @objc private func microphoneButtonTapped() {
        onMicrophoneTapped?()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        originalText = ""
        resetHighlighting()
        updateMicrophoneState(isRecording: false)
        updateLoadingState(isLoading: false)
        onMicrophoneTapped = nil
    }
}
