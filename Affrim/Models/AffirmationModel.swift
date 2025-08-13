//
//  AffirmationModel.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import Foundation

struct AffirmationModel {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
}

// MARK: - Sample Data
extension AffirmationModel {
    static let sampleAffirmations: [AffirmationModel] = [
        AffirmationModel("Every challenge you face is a stepping stone to your greater self. Your resilience grows stronger with each obstacle you overcome. Trust in your ability to transform difficulties into wisdom and strength."),
        
        AffirmationModel("You are capable of amazing things. Your potential is limitless, and every day brings new opportunities for growth and success."),
        
        AffirmationModel("I am worthy of love, happiness, and all the beautiful things life has to offer. I deserve to live my dreams and pursue my passions."),
        
        AffirmationModel("My mind is powerful and focused. I have the strength to overcome any challenge that comes my way. I am resilient and adaptable."),
        
        AffirmationModel("Today I choose to see the good in every situation. I attract positivity and abundance into my life through my thoughts and actions."),
        
        AffirmationModel("I am confident in my abilities and trust my intuition. Every decision I make leads me closer to my goals and dreams."),
        
        AffirmationModel("I radiate kindness and compassion. My positive energy touches everyone I meet and creates ripples of joy in the world."),
        
        AffirmationModel("I am grateful for this moment and all the blessings in my life. Gratitude fills my heart and guides my perspective."),
        
        AffirmationModel("I believe in myself and my journey. Every step I take is progress, and I celebrate both small victories and major achievements."),
        
        AffirmationModel("I am exactly where I need to be right now. I trust the process of life and know that everything unfolds in perfect timing.")
    ]
}
