//
//  FoundationModelsRecipeGenerator.swift
//  AIRecipe
//
//  Created by Iqbal Alhadad on 15/06/26.
//

import Foundation
import FoundationModels

final class FoundationModelsRecipeGenerator: RecipeGenerating {
    private let session: LanguageModelSession
    
    init() {
        self.session = LanguageModelSession {
            "You are a friendly cookery assistant, here to help you with your culinary needs."
        }
    }
    
    func prewarm() {
        session.prewarm()
    }
    
    func generateRecipe(for dishQuery: String) async throws -> Recipe {
        let dish = dishQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let prompt = "Create a recipe for: \(dish) Assume : - Home Kitchen"
                            
        let response = try await session.respond(to: prompt, generating: Recipe.self)
        
        return response.content
    }
}
