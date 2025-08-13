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

// MARK: - Dummy Data
extension AffirmationModel {
    static let dummyData: [AffirmationModel] = [
        AffirmationModel("Every challenge you face is a stepping stone to your greater self. Your resilience grows stronger with each obstacle you overcome. Trust in your ability to transform difficulties into wisdom and strength."),
        AffirmationModel("You are worthy of all the love, success, and happiness that life has to offer. Your unique gifts and talents make a positive difference in the world."),
        AffirmationModel("Today is a new beginning filled with endless possibilities. You have the power to create the life you desire through your thoughts, actions, and choices."),
        AffirmationModel("Your mind is powerful beyond measure. You can achieve anything you set your heart and mind to. Believe in yourself and your limitless potential."),
        AffirmationModel("You are exactly where you need to be in this moment. Trust the process of your journey and know that everything is unfolding perfectly for your highest good."),
        AffirmationModel("Your inner strength is greater than any external circumstance. You have overcome challenges before, and you will overcome them again with grace and wisdom."),
        AffirmationModel("You radiate positive energy that attracts abundance, love, and joy into your life. Your authentic self is a gift to the world."),
        AffirmationModel("Every breath you take fills you with peace, confidence, and determination. You are calm, centered, and ready to embrace all that today brings."),
        AffirmationModel("Your dreams are valid and achievable. Take one step forward today toward the life you envision for yourself. Progress, not perfection, is the goal."),
        AffirmationModel("You are loved, you are enough, and you matter. Your presence in this world makes it a brighter, more beautiful place.")
    ]
}
