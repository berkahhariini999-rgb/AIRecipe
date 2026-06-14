//
//  Recipe.swift
//  AIRecipe
//
//  Created by Iqbal Alhadad on 14/06/26.
//

import FoundationModels

@Generable

struct Recipe {
    var title: String
    var sumary: String
    var servings: Int
    var prepMinutes: Int
    var cookMinutes: Int
    var ingredients: [Ingredient]
    var steps: [RecipeStep]
    var tips: [String]
    var safetyNotes: [String]
}
