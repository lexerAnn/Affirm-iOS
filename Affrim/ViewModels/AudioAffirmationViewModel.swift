//
//  AudioAffirmationViewModel.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import Foundation
import Combine

// MARK: - Word Highlighting Model
struct HighlightedWord {
    let word: String
    let isHighlighted: Bool
    let delay: TimeInterval
    let isMatched: Bool // New property to track if word was found in transcription
}

// MARK: - ViewModel
class AudioAffirmationViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var highlightedWords: [HighlightedWord] = []
    @Published var isShowingHighlighting = false
    @Published var currentHighlightIndex = -1
    @Published var isAnimating = false
    @Published var matchedWordsCount = 0
    
    // Repository
    private let repository = AudioTranscriptionRepository()
    private var cancellables = Set<AnyCancellable>()
    
    // Current affirmation text for cross-referencing
    private var currentAffirmationText = ""
    
    // MARK: - Published properties from repository
    @Published var isRecording = false
    @Published var transcriptionText = ""
    @Published var isTranscribing = false
    @Published var isGeneratingAffirmation = false
    @Published var errorMessage: String?
    
    // MARK: - Initialization
    init() {
        bindRepositoryData()
    }
    
    // MARK: - Data Binding
    private func bindRepositoryData() {
        // Bind repository data to ViewModel
        repository.$isRecording
            .receive(on: DispatchQueue.main)
            .assign(to: \.isRecording, on: self)
            .store(in: &cancellables)
        
        repository.$transcriptionText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] transcription in
                self?.transcriptionText = transcription
                if !transcription.isEmpty {
                    self?.processTranscriptionWithAffirmation(transcription)
                }
            }
            .store(in: &cancellables)
        
        repository.$isTranscribing
            .receive(on: DispatchQueue.main)
            .assign(to: \.isTranscribing, on: self)
            .store(in: &cancellables)
        
        repository.$isGeneratingAffirmation
            .receive(on: DispatchQueue.main)
            .assign(to: \.isGeneratingAffirmation, on: self)
            .store(in: &cancellables)
        
        repository.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: \.errorMessage, on: self)
            .store(in: &cancellables)
    }
    
    // MARK: - Audio Recording Methods
    func startRecording() {
        Task {
            do {
                try await repository.startRecording()
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to start recording: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func stopRecording() {
        repository.stopRecording()
    }
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    // MARK: - Set Current Affirmation
    func setCurrentAffirmation(_ text: String) {
        currentAffirmationText = text
        resetHighlighting()
    }
    
    // MARK: - Word Matching and Highlighting Logic
    private func processTranscriptionWithAffirmation(_ transcription: String) {
        guard !currentAffirmationText.isEmpty else { return }
        
        print("\n🔄 PROCESSING WORD MATCHING:")
        print("📜 Original Affirmation: \"\(currentAffirmationText)\"")
        print("🎤 Transcribed Audio: \"\(transcription)\"")
        
        // Normalize and split both texts into words
        let affirmationWords = normalizeText(currentAffirmationText).components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        let transcribedWords = normalizeText(transcription).components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        
        print("\n📋 NORMALIZED WORDS:")
        print("📜 Affirmation words: \(affirmationWords)")
        print("🎤 Transcribed words: \(transcribedWords)")
        
        // Create a set of transcribed words for faster lookup
        let transcribedWordSet = Set(transcribedWords)
        
        // Create highlighted words array with matching information
        var matchedCount = 0
        var matchedWords: [String] = []
        var unmatchedWords: [String] = []
        
        let wordsWithMatching = affirmationWords.enumerated().map { index, word in
            let originalWord = getOriginalWord(from: currentAffirmationText, at: index, cleanWord: word)
            let isMatched = transcribedWordSet.contains(word)
            
            if isMatched {
                matchedCount += 1
                matchedWords.append(word)
            } else {
                unmatchedWords.append(word)
            }
            
            return HighlightedWord(
                word: originalWord,
                isHighlighted: false,
                delay: TimeInterval(index) * 0.3,
                isMatched: isMatched
            )
        }
        
        print("\n✅ MATCHING RESULTS:")
        print("🎯 Matched words (\(matchedCount)): \(matchedWords)")
        print("❌ Unmatched words (\(unmatchedWords.count)): \(unmatchedWords)")
        print("📊 Match percentage: \(Int((Double(matchedCount) / Double(affirmationWords.count)) * 100))%")
        
        highlightedWords = wordsWithMatching
        matchedWordsCount = matchedCount
        isShowingHighlighting = true
        
        // Start highlighting animation
        animateWordHighlighting()
    }
    
    private func normalizeText(_ text: String) -> String {
        // Remove punctuation and convert to lowercase for comparison
        return text.lowercased()
            .replacingOccurrences(of: "[^a-zA-Z0-9\\s]", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func getOriginalWord(from originalText: String, at index: Int, cleanWord: String) -> String {
        // Get the original word with punctuation from the original text
        let originalWords = originalText.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        return index < originalWords.count ? originalWords[index] : cleanWord
    }
    
    private func animateWordHighlighting() {
        guard !highlightedWords.isEmpty else { return }
        
        isAnimating = true
        currentHighlightIndex = -1
        
        // Only animate words that are matched
        let matchedIndices = highlightedWords.enumerated().compactMap { index, word in
            word.isMatched ? index : nil
        }
        
        // Animate each matched word one by one
        for (animationIndex, wordIndex) in matchedIndices.enumerated() {
            let delay = TimeInterval(animationIndex) * 0.4 // Slightly longer delay for matched words
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.highlightWord(at: wordIndex)
            }
        }
        
        // Stop animation after all matched words are highlighted
        let totalDuration = TimeInterval(matchedIndices.count) * 0.4
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + 0.5) { [weak self] in
            self?.isAnimating = false
        }
    }
    
    private func highlightWord(at index: Int) {
        guard index < highlightedWords.count else { return }
        
        // Update the current highlight index
        currentHighlightIndex = index
        
        // Update the highlighted state of the word (only if it's matched)
        if highlightedWords[index].isMatched {
            highlightedWords[index] = HighlightedWord(
                word: highlightedWords[index].word,
                isHighlighted: true,
                delay: highlightedWords[index].delay,
                isMatched: highlightedWords[index].isMatched
            )
        }
    }
    
    // MARK: - Reset Methods
    func resetHighlighting() {
        highlightedWords = []
        isShowingHighlighting = false
        currentHighlightIndex = -1
        isAnimating = false
        matchedWordsCount = 0
        transcriptionText = ""
    }
    
    func cleanup() {
        repository.cleanup()
        resetHighlighting()
        errorMessage = nil
        currentAffirmationText = ""
    }
    
    // MARK: - Helper Methods
    func getDisplayText() -> String {
        return currentAffirmationText
    }
    
    func shouldShowLoader() -> Bool {
        return isTranscribing || isGeneratingAffirmation
    }
    
    func getLoaderText() -> String {
        if isTranscribing {
            return "Transcribing audio..."
        } else if isGeneratingAffirmation {
            return "Analyzing speech..."
        } else {
            return ""
        }
    }
    
    func getMatchingSummary() -> String {
        guard matchedWordsCount > 0 else { return "" }
        let totalWords = highlightedWords.count
        let percentage = Int((Double(matchedWordsCount) / Double(totalWords)) * 100)
        return "Matched \(matchedWordsCount)/\(totalWords) words (\(percentage)%)"
    }
}
