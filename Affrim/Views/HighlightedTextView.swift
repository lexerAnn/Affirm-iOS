//
//  HighlightedTextView.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import UIKit

class HighlightedTextView: UIView {
    
    // MARK: - Properties
    private var wordLabels: [UILabel] = []
    private var stackView: UIStackView!
    
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
        // Create main vertical stack view
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func displayHighlightedWords(_ highlightedWords: [HighlightedWord]) {
        clearLabels()
        createWordLabels(from: highlightedWords)
    }
    
    func updateHighlighting(_ highlightedWords: [HighlightedWord]) {
        guard wordLabels.count == highlightedWords.count else {
            displayHighlightedWords(highlightedWords)
            return
        }
        
        for (index, highlightedWord) in highlightedWords.enumerated() {
            let label = wordLabels[index]
            updateLabelAppearance(label, isHighlighted: highlightedWord.isHighlighted, isMatched: highlightedWord.isMatched)
        }
    }
    
    private func clearLabels() {
        wordLabels.forEach { $0.removeFromSuperview() }
        wordLabels.removeAll()
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
    }
    
    private func createWordLabels(from highlightedWords: [HighlightedWord]) {
        let wordsPerLine = 4 // Adjust based on screen size
        var currentLineStack: UIStackView?
        
        for (index, highlightedWord) in highlightedWords.enumerated() {
            // Create new line stack if needed
            if index % wordsPerLine == 0 {
                currentLineStack = UIStackView()
                currentLineStack?.axis = .horizontal
                currentLineStack?.spacing = 12
                currentLineStack?.alignment = .center
                currentLineStack?.distribution = .fill
                
                if let lineStack = currentLineStack {
                    stackView.addArrangedSubview(lineStack)
                }
            }
            
            // Create word label
            let label = createWordLabel(for: highlightedWord)
            wordLabels.append(label)
            currentLineStack?.addArrangedSubview(label)
        }
    }
    
    private func createWordLabel(for highlightedWord: HighlightedWord) -> UILabel {
        let label = UILabel()
        label.text = highlightedWord.word
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1
        
        // Set initial appearance based on matching status
        updateLabelAppearance(label, isHighlighted: highlightedWord.isHighlighted, isMatched: highlightedWord.isMatched)
        
        // Add padding
        label.contentMode = .center
        
        return label
    }
    
    private func updateLabelAppearance(_ label: UILabel, isHighlighted: Bool, isMatched: Bool = true) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            if isHighlighted && isMatched {
                // Highlighted state - cosmic theme (only for matched words)
                label.textColor = .white
                label.backgroundColor = UIColor.systemBlue
                label.layer.cornerRadius = 8
                label.layer.shadowColor = UIColor.systemBlue.cgColor
                label.layer.shadowOffset = CGSize(width: 0, height: 2)
                label.layer.shadowRadius = 4
                label.layer.shadowOpacity = 0.3
                label.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } else if !isMatched {
                // Unmatched words - subtle gray appearance
                label.textColor = .systemGray2
                label.backgroundColor = .clear
                label.layer.cornerRadius = 0
                label.layer.shadowOpacity = 0
                label.transform = CGAffineTransform.identity
            } else {
                // Normal state
                label.textColor = .label
                label.backgroundColor = .clear
                label.layer.cornerRadius = 0
                label.layer.shadowOpacity = 0
                label.transform = CGAffineTransform.identity
            }
        })
        
        // Add some padding to highlighted words
        if isHighlighted && isMatched {
            label.layer.masksToBounds = false
            label.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        } else {
            label.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    // MARK: - Animation Methods
    func animateWordHighlighting(_ highlightedWords: [HighlightedWord], completion: (() -> Void)? = nil) {
        displayHighlightedWords(highlightedWords)
        
        // Animate each word with delay
        for (index, highlightedWord) in highlightedWords.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + highlightedWord.delay) { [weak self] in
                guard let self = self, index < self.wordLabels.count else { return }
                
                let label = self.wordLabels[index]
                self.updateLabelAppearance(label, isHighlighted: true, isMatched: highlightedWord.isMatched)
                
                // Call completion after last word
                if index == highlightedWords.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        completion?()
                    }
                }
            }
        }
    }
    
    func clearHighlighting() {
        UIView.animate(withDuration: 0.3) {
            self.wordLabels.forEach { label in
                self.updateLabelAppearance(label, isHighlighted: false, isMatched: true)
            }
        }
    }
    
    func resetView() {
        clearLabels()
    }
}
