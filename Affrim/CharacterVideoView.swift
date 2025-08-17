//
//  CharacterVideoView.swift
//  Affrim
//
//  Created by Assistant on 16/08/2025.
//

import UIKit
import AVFoundation

class CharacterVideoView: UIView {
    
    // MARK: - Properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var currentVideoState: VideoState = .poor
    
    // MARK: - Video States
    enum VideoState {
        case poor    // 0% progress - no affirmations done
        case medium  // 1-2 affirmations done (partial progress)
        case good    // All affirmations completed
        
        var videoFileName: String {
            switch self {
            case .poor:
                return "poor"
            case .medium:
                return "medium"
            case .good:
                return "good"
            }
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVideoPlayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupVideoPlayer()
    }
    
    // MARK: - Setup
    private func setupVideoPlayer() {
        backgroundColor = .clear
        layer.cornerRadius = 12
        clipsToBounds = true
        layer.masksToBounds = true  // Ensure zoomed content is properly clipped
        
        // Start with poor state
        playVideo(for: .poor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
        // Maintain 2x zoom for character visibility
        playerLayer?.transform = CATransform3DMakeScale(2.0, 2.0, 1.0)
    }
    
    // MARK: - Public Methods
    func setProgress(_ progress: Float, animated: Bool = true) {
        let newState = videoStateForProgress(progress)
        
        if newState != currentVideoState {
            currentVideoState = newState
            playVideo(for: newState)
        }
    }
    
    func playCurrentVideo() {
        player?.play()
    }
    
    func pauseCurrentVideo() {
        player?.pause()
    }
    
    // MARK: - Private Methods
    private func videoStateForProgress(_ progress: Float) -> VideoState {
        if progress == 0.0 {
            return .poor
        } else if progress < 1.0 {
            return .medium
        } else {
            return .good
        }
    }
    
    private func playVideo(for state: VideoState) {
        // Remove existing player layer
        playerLayer?.removeFromSuperlayer()
        
        // Get video URL
        guard let videoURL = getVideoURL(for: state) else {
            print("Warning: Video file '\(state.videoFileName).mp4' not found in bundle")
            showPlaceholder(for: state)
            return
        }
        
        // Create new player
        player = AVPlayer(url: videoURL)
        playerLayer = AVPlayerLayer(player: player)
        
        guard let playerLayer = playerLayer else { return }
        
        // Configure player layer
        playerLayer.frame = bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.cornerRadius = 12
        
        // Add 2x zoom transform for better character visibility
        playerLayer.transform = CATransform3DMakeScale(2.0, 2.0, 1.0)
        
        // Add to view
        layer.addSublayer(playerLayer)
        
        // Setup looping
        setupVideoLooping()
        
        // Start playing
        player?.play()
    }
    
    private func getVideoURL(for state: VideoState) -> URL? {
        // First try to get from main bundle
        if let bundleURL = Bundle.main.url(forResource: state.videoFileName, withExtension: "mp4") {
            return bundleURL
        }
        
        // If not found, try different extensions
        let extensions = ["mov", "m4v", "avi"]
        for ext in extensions {
            if let bundleURL = Bundle.main.url(forResource: state.videoFileName, withExtension: ext) {
                return bundleURL
            }
        }
        
        return nil
    }
    
    private func setupVideoLooping() {
        // Add observer for when video ends to loop it
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            self?.player?.seek(to: .zero)
            self?.player?.play()
        }
    }
    
    private func showPlaceholder(for state: VideoState) {
        // Remove any existing sublayers
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        // Create placeholder view
        let placeholderView = UIView()
        placeholderView.backgroundColor = getPlaceholderColor(for: state)
        placeholderView.layer.cornerRadius = 12
        
        // Add emoji/text based on state
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32)
        
        switch state {
        case .poor:
            label.text = "😔"
            placeholderView.backgroundColor = UIColor.systemGray5
        case .medium:
            label.text = "😊"
            placeholderView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.3)
        case .good:
            label.text = "🎉"
            placeholderView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
        }
        
        // Add to view
        addSubview(placeholderView)
        placeholderView.addSubview(label)
        
        // Setup constraints
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderView.topAnchor.constraint(equalTo: topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor)
        ])
    }
    
    private func getPlaceholderColor(for state: VideoState) -> UIColor {
        switch state {
        case .poor:
            return UIColor.systemGray5
        case .medium:
            return UIColor.systemYellow.withAlphaComponent(0.3)
        case .good:
            return UIColor.systemGreen.withAlphaComponent(0.3)
        }
    }
    
    // MARK: - Cleanup
    deinit {
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        playerLayer?.removeFromSuperlayer()
    }
}
