//
//  RecipeGenerating.swift
//  AIRecipe
//
//  Created by Iqbal Alhadad on 14/06/26.
//

import Foundation


protocol RecipeGenerating {
    func prewarm()
    
    func generateRecipe(for dishQuery: String) async throws -> Recipe
}
