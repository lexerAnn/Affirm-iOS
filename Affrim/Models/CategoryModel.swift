//
//  CategoryModel.swift
//  Affrim
//
//  Created by Leslie Annan on 12/08/2025.
//

import Foundation

struct CategoryModel {
    let title: String
    let affirmations: [AffirmationModel]
    
    init(title: String, affirmations: [AffirmationModel]) {
        self.title = title
        self.affirmations = affirmations
    }
}

// MARK: - Sample Data
extension CategoryModel {
    static let sampleCategories: [CategoryModel] = [
        CategoryModel(
            title: "Wealth",
            affirmations: [
                AffirmationModel("I am a magnet for abundance and prosperity. Money flows to me easily and effortlessly from multiple sources."),
                AffirmationModel("I deserve financial success and wealth. I make smart financial decisions that benefit my future."),
                AffirmationModel("My wealth grows exponentially as I create value for others. I am grateful for my financial abundance.")
            ]
        ),
        
        CategoryModel(
            title: "Confidence",
            affirmations: [
                AffirmationModel("I am confident, capable, and worthy of success. I trust in my abilities and embrace new challenges."),
                AffirmationModel("I speak with authority and conviction. My confidence inspires others and opens doors to new opportunities."),
                AffirmationModel("I believe in myself completely. Every day my confidence grows stronger and more unshakeable.")
            ]
        ),
        
        CategoryModel(
            title: "Health",
            affirmations: [
                AffirmationModel("My body is strong, healthy, and vibrant. I nourish myself with nutritious food and regular exercise."),
                AffirmationModel("I am in perfect health. Every cell in my body radiates vitality and wellness."),
                AffirmationModel("I listen to my body and give it what it needs. I am grateful for my healthy, energetic body.")
            ]
        ),
        
        CategoryModel(
            title: "Success",
            affirmations: [
                AffirmationModel("Success comes naturally to me. I achieve my goals with determination and persistence."),
                AffirmationModel("I am destined for greatness. Every action I take moves me closer to extraordinary success."),
                AffirmationModel("I create my own success through hard work, dedication, and positive thinking.")
            ]
        ),
        
        CategoryModel(
            title: "Relationships",
            affirmations: [
                AffirmationModel("I attract loving, supportive relationships into my life. I give and receive love freely."),
                AffirmationModel("I communicate with love, respect, and understanding. My relationships are harmonious and fulfilling."),
                AffirmationModel("I am surrounded by people who appreciate and value me. I create meaningful connections wherever I go.")
            ]
        ),
        
        CategoryModel(
            title: "Peace",
            affirmations: [
                AffirmationModel("I am at peace with myself and the world around me. Calmness flows through every part of my being."),
                AffirmationModel("I release all worry and stress. I trust that everything happens for my highest good."),
                AffirmationModel("I find peace in the present moment. I am centered, grounded, and completely at ease.")
            ]
        ),
        
        CategoryModel(
            title: "Motivation",
            affirmations: [
                AffirmationModel("I am motivated and inspired to achieve my dreams. Energy and enthusiasm fuel my daily actions."),
                AffirmationModel("I wake up each day with purpose and drive. I am unstoppable in pursuing my goals."),
                AffirmationModel("My motivation comes from within. I am passionate about creating the life I desire.")
            ]
        ),
        
        CategoryModel(
            title: "Creativity",
            affirmations: [
                AffirmationModel("I am a creative force. Ideas flow through me effortlessly and I express them with confidence."),
                AffirmationModel("My creativity knows no bounds. I find innovative solutions and create beautiful expressions of my inner self."),
                AffirmationModel("I trust my creative instincts. I am an artist of life, painting my reality with imagination and vision.")
            ]
        )
    ]
}
