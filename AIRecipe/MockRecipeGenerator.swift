//
//  MockRecipeGenerator.swift
//  AIRecipe
//
//  Created by Iqbal Alhadad on 15/06/26.
//

import Foundation
import FoundationModels

final class MockRecipeGenerator: RecipeGenerating {
    func prewarm() {
        
    }
    
    func generateRecipe(for dishQuery: String) async throws -> Recipe {
        
        let title = dishQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let safeTitle = title.isEmpty ? "Sample Recipe" : title
        
        return Recipe (
            title: safeTitle, sumary: "Mock recipe", servings: 2, prepMinutes: 10, cookMinutes: 15, ingredients: [
                Ingredient(item:"Olive Oil", quantity: "1 tbsp")
            ], steps: [RecipeStep(stepnumber: 1, instruction: "mock instruction", symbolName: "timer")], tips: ["mockup tips"], safetyNotes: ["mockup safetynotes"]
        )
    }
}
