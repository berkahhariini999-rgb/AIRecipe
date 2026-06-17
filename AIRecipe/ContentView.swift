//
//  ContentView.swift
//  AIRecipe
//
//  Created by Iqbal Alhadad on 14/06/26.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    
    @State private var vm: CookeryViewModel
    
    init() {
        let generator: RecipeGenerating
        
        if SystemLanguageModel.default.availability == .available {
            generator = FoundationModelsRecipeGenerator()
        } else {
            generator = MockRecipeGenerator()
        }
        
            _vm = State(initialValue: CookeryViewModel(generator: generator))
    }
    
    
    var body: some View {
       @Bindable var vm = vm
        return NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 20) {
                    headerInput(vm: vm)
                    
                    if let error = vm.errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.footnote)
                    }
                    
                    if let recipe = vm.finalRecipe {
                        recipeCard(recipe)
                    } else if vm.isStreaming {
                        ProgressView("Creating your recipe...")
                            .frame(maxWidth: .infinity)
                            .padding(.top,40)
                    } else {
                        ContentUnavailableView("What do you want to cook?", systemImage: "fork.knife",
                        description: Text("Type a dish name, then tap generate")
                        )
                        .padding(.top,40)
                    }
                }
                .padding(20)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("AI Recipe")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear") {
                        vm.clear()
                    }
                    
                    
                   
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if vm.isStreaming {
                        Button("Stop") {
                            vm.cancel()
                        }
                    }
                }
            }
            .task {
                vm.prewarm()
            }
        }
    }
    
    private func recipeCard(_ recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(recipe.title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            Text(recipe.sumary)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.secondary)
            
            HStack {
                infoCard(icon: "timer", iconColor: .green, main: "\(recipe.servings)", label: "COOK")
            }
            
            Text("STEPS")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            VStack(spacing: 12){
                ForEach(recipe.steps.sorted(by: {
                    $0.stepnumber < $1.stepnumber
                }), id: \.stepnumber) {
                    step in
                    
                    stepRow(step)
                }
            }
            
        }
    }
    
//    if !recipe.tips.isEmpty {
//        VStack(alignment: .leading, spacing: 10){
//            ForEach(recipe.tips, id: \.self) {
//                tip in
//                Label(tip, systemImage: "lightbulb.fill")
//                    .foregroundStyle(.orange)
//            }
//        }
//    }


    
    
    
    private func stepColor(for step: Int) -> Color {
        switch step {
        case 1: return .green
        case 2: return .purple
        case 3: return .green
        default: return .indigo
        }
    }
    
    private func headerInput(vm: CookeryViewModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("e.g Spaghetti Carbonara", text: $vm.dishQuery, axis: .vertical)
                .padding(14)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.08), radius: 10, x: 0 , y: 5)
                .lineLimit(1...3)
                .disabled(vm.isStreaming)
            
            Button {
                vm.generateRecipe()
            } label: {
                Label(vm.isStreaming ? "Generating..." : "Generate Recipe", systemImage: "sparkles")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            
            .buttonStyle(.borderedProminent)
            .disabled(vm.dishQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isStreaming)
            
        }
    }
    
    private func stepRow(_ step: RecipeStep) -> some View {
        let color = stepColor(for: step.stepnumber)
        
        return HStack(spacing: 14){
            
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 46, height: 46)
                
                
                Image(systemName: safeSymbol(step.symbolName))
                    .font(.title3.bold())
                    .foregroundStyle(.white)
            }
            
            Text("\(step.stepnumber)")
                .font(.system(size: 26, weight: .bold, design: .rounded))
                .foregroundStyle(color)
                .frame(width:26)
            
            Text(step.instruction)
                .font(.system(size: 16, weight: .regular, design: .rounded))
                .foregroundStyle(.primary)
                .lineLimit(nil)
            
            Spacer()
            
        }
        
        
    }
    
    
    
    private func infoCard(icon: String, iconColor: Color, main: String, label:String) -> some View {
        
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
            
            VStack(alignment: .leading, spacing: 0){
                
                Text(main)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                
                Text(label)
                    .font(.system(size: 8, weight: .bold, design: .rounded))
                    .foregroundStyle(.secondary)
                
            }
        }
        
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 5)
        
    }
    
    
    
    private func safeSymbol(_ name: String) -> String {
        let allowed: Set<String> = [
            "flame",
            "flame.fill",
            "knife",
            "drop",
            "leaf",
            "fork.knife",
            "oven",
            "microwave",
            "snowflake",
            "thermometer",
            "bolt",
            "sparkles",
            "lightbulb.fill"
        ]
        
        return allowed.contains(name) ? name : "fork.knife"
    }
}


