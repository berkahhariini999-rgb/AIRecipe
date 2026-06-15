//
//  CookeryViewModel.swift
//  AIRecipe
//
//  Created by Iqbal Alhadad on 15/06/26.
//

import Foundation
import SwiftUI
import Observation
import FoundationModels

@Observable
@MainActor
final class CookeryViewModel {
    
    var dishQuery: String = ""
    var isStreaming = false
    var errorMessage: String?
    var finalRecipe: Recipe?
    private let generator: RecipeGenerating
    private var task:Task<Void, Never>?
    
    init(generator: RecipeGenerating){
        self.generator = generator
    }
    
    func prewarm(){
        generator.prewarm()
    }
    
    func generateRecipe() {
        let dish = dishQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !dish.isEmpty, !isStreaming else {
            return
        }
        errorMessage = nil
        finalRecipe = nil
        isStreaming = true
        task?.cancel()
        
        task = Task {
            [weak self] in
            guard let self else {
                return
            }
            defer {
                Task {
                    @MainActor in self.isStreaming = false
                }
                
            }
            
            do {
                let recipe = try await self.generator.generateRecipe(for: dish)
                self.finalRecipe = recipe
            } catch let e as LanguageModelSession.GenerationError {
                self.errorMessage = e.localizedDescription
            } catch {
                self.errorMessage = error.localizedDescription
            }
            
        }
    }
    
    func cancel(){
        task?.cancel()
        task = nil
        isStreaming = false
    }
    
    func clear(){
        cancel()
        dishQuery = ""
        finalRecipe = nil
        errorMessage = nil
    }
}
