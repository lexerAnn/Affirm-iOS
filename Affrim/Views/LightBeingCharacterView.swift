//
//  LightBeingCharacterView.swift
//  Affrim
//
//  Created by Assistant on 14/08/2025.
//

import UIKit

class LightBeingCharacterView: UIView {
    
    // MARK: - Properties
    private var currentStage: CharacterStage = .dimmed
    private var animationTimer: Timer?
    
    // MARK: - Character Stages
    enum CharacterStage {
        case dimmed    // 0-33% progress
        case awakening // 34-66% progress
        case radiant   // 67-100% progress
    }
    
    // MARK: - UI Components
    private lazy var characterBodyLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.systemGray5.cgColor
        layer.strokeColor = UIColor.clear.cgColor
        return layer
    }()
    
    private lazy var innerGlowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.withAlphaComponent(0.3).cgColor
        layer.lineWidth = 2
        return layer
    }()
    
    private lazy var outerGlowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.withAlphaComponent(0.1).cgColor
        layer.lineWidth = 4
        return layer
    }()
    
    private lazy var particleEmitterLayer: CAEmitterLayer = {
        let layer = CAEmitterLayer()
        layer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        layer.emitterSize = CGSize(width: 100, height: 100)
        layer.emitterShape = .circle
        return layer
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
        backgroundColor = .clear
        
        // Add layers in order (background to foreground)
        layer.addSublayer(outerGlowLayer)
        layer.addSublayer(innerGlowLayer)
        layer.addSublayer(characterBodyLayer)
        layer.addSublayer(particleEmitterLayer)
        
        // Start with dimmed state
        updateCharacterAppearance(for: .dimmed, animated: false)
        startBreathingAnimation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCharacterPaths()
        particleEmitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    // MARK: - Public Methods
    func setProgress(_ progress: Float, animated: Bool = true) {
        let newStage = stageForProgress(progress)
        
        if newStage != currentStage {
            currentStage = newStage
            updateCharacterAppearance(for: newStage, animated: animated)
            
            if animated {
                addProgressTransitionEffects()
            }
        }
    }
    
    // MARK: - Private Methods
    private func stageForProgress(_ progress: Float) -> CharacterStage {
        switch progress {
        case 0.0..<0.34:
            return .dimmed
        case 0.34..<0.67:
            return .awakening
        default:
            return .radiant
        }
    }
    
    private func updateCharacterPaths() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let bodyRadius: CGFloat = 40
        let innerGlowRadius: CGFloat = 50
        let outerGlowRadius: CGFloat = 60
        
        // Character body (simple circle for now, can be made more humanoid later)
        characterBodyLayer.path = UIBezierPath(arcCenter: center, radius: bodyRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
        
        // Inner glow
        innerGlowLayer.path = UIBezierPath(arcCenter: center, radius: innerGlowRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
        
        // Outer glow
        outerGlowLayer.path = UIBezierPath(arcCenter: center, radius: outerGlowRadius, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
    }
    
    private func updateCharacterAppearance(for stage: CharacterStage, animated: Bool) {
        let duration: CFTimeInterval = animated ? 0.8 : 0
        
        switch stage {
        case .dimmed:
            updateColors(
                bodyColor: UIColor.systemGray5.withAlphaComponent(0.3),
                innerGlowColor: UIColor.white.withAlphaComponent(0.1),
                outerGlowColor: UIColor.clear,
                duration: duration
            )
            updateParticles(rate: 0, velocity: 0, size: 0)
            
        case .awakening:
            updateColors(
                bodyColor: UIColor.systemYellow.withAlphaComponent(0.6),
                innerGlowColor: UIColor.systemYellow.withAlphaComponent(0.3),
                outerGlowColor: UIColor.systemYellow.withAlphaComponent(0.1),
                duration: duration
            )
            updateParticles(rate: 5, velocity: 20, size: 4)
            
        case .radiant:
            updateColors(
                bodyColor: UIColor.systemYellow.withAlphaComponent(0.9),
                innerGlowColor: UIColor.systemOrange.withAlphaComponent(0.6),
                outerGlowColor: UIColor.systemYellow.withAlphaComponent(0.3),
                duration: duration
            )
            updateParticles(rate: 15, velocity: 40, size: 6)
        }
    }
    
    private func updateColors(bodyColor: UIColor, innerGlowColor: UIColor, outerGlowColor: UIColor, duration: CFTimeInterval) {
        if duration > 0 {
            // Animate color changes
            let bodyAnimation = CABasicAnimation(keyPath: "fillColor")
            bodyAnimation.toValue = bodyColor.cgColor
            bodyAnimation.duration = duration
            bodyAnimation.fillMode = .forwards
            bodyAnimation.isRemovedOnCompletion = false
            characterBodyLayer.add(bodyAnimation, forKey: "bodyColor")
            
            let innerGlowAnimation = CABasicAnimation(keyPath: "strokeColor")
            innerGlowAnimation.toValue = innerGlowColor.cgColor
            innerGlowAnimation.duration = duration
            innerGlowAnimation.fillMode = .forwards
            innerGlowAnimation.isRemovedOnCompletion = false
            innerGlowLayer.add(innerGlowAnimation, forKey: "innerGlow")
            
            let outerGlowAnimation = CABasicAnimation(keyPath: "strokeColor")
            outerGlowAnimation.toValue = outerGlowColor.cgColor
            outerGlowAnimation.duration = duration
            outerGlowAnimation.fillMode = .forwards
            outerGlowAnimation.isRemovedOnCompletion = false
            outerGlowLayer.add(outerGlowAnimation, forKey: "outerGlow")
        } else {
            // Set colors immediately
            characterBodyLayer.fillColor = bodyColor.cgColor
            innerGlowLayer.strokeColor = innerGlowColor.cgColor
            outerGlowLayer.strokeColor = outerGlowColor.cgColor
        }
    }
    
    private func updateParticles(rate: Float, velocity: CGFloat, size: CGFloat) {
        // Remove existing emitter cells
        particleEmitterLayer.emitterCells = []
        
        guard rate > 0 else { return }
        
        // Create sparkle particle
        let sparkleCell = CAEmitterCell()
        sparkleCell.birthRate = rate
        sparkleCell.lifetime = 2.0
        sparkleCell.velocity = velocity
        sparkleCell.velocityRange = velocity * 0.5
        sparkleCell.emissionRange = .pi * 2
        sparkleCell.scale = size / 10.0
        sparkleCell.scaleRange = sparkleCell.scale * 0.3
        sparkleCell.alphaSpeed = -0.5
        
        // Create sparkle image
        sparkleCell.contents = createSparkleImage(size: CGSize(width: size, height: size)).cgImage
        
        particleEmitterLayer.emitterCells = [sparkleCell]
    }
    
    private func createSparkleImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        
        // Draw a simple star/sparkle
        context.setFillColor(UIColor.white.cgColor)
        context.fillEllipse(in: CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    private func startBreathingAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.fromValue = 0.95
        pulseAnimation.toValue = 1.05
        pulseAnimation.duration = 2.0
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        characterBodyLayer.add(pulseAnimation, forKey: "breathing")
    }
    
    private func addProgressTransitionEffects() {
        // Add a brief scale-up effect when transitioning
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.2
        scaleAnimation.duration = 0.3
        scaleAnimation.autoreverses = true
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        characterBodyLayer.add(scaleAnimation, forKey: "progressTransition")
        
        // Add sparkle burst effect
        if currentStage != .dimmed {
            addSparkleburstEffect()
        }
    }
    
    private func addSparkleburstEffect() {
        let burstEmitter = CAEmitterLayer()
        burstEmitter.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        burstEmitter.emitterSize = CGSize(width: 5, height: 5)
        burstEmitter.emitterShape = .point
        
        let burstCell = CAEmitterCell()
        burstCell.birthRate = 30
        burstCell.lifetime = 1.0
        burstCell.velocity = 80
        burstCell.velocityRange = 40
        burstCell.emissionRange = .pi * 2
        burstCell.scale = 0.3
        burstCell.scaleRange = 0.2
        burstCell.alphaSpeed = -1.0
        burstCell.contents = createSparkleImage(size: CGSize(width: 8, height: 8)).cgImage
        
        burstEmitter.emitterCells = [burstCell]
        layer.addSublayer(burstEmitter)
        
        // Remove the burst effect after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            burstEmitter.removeFromSuperlayer()
        }
        
        // Stop the burst after a short time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            burstCell.birthRate = 0
        }
    }
    
    // MARK: - Cleanup
    deinit {
        animationTimer?.invalidate()
    }
}
