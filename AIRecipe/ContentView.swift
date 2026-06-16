//
//  ContentView.swift
//  AIRecipe
//
//  Created by Iqbal Alhadad on 14/06/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
       
    }
    
    private func stepColor(for step: Int) -> Color {
        switch step {
        case 1: return .green
        case 2: return .purple
        case 3: return .green
        default: return .indigo
        }
    }
    
    private func stepRow(_ step: RecipeStep) -> some View {
        let color = stepColor(for: step.stepnumber)
        
        return HStack(spacing: 14){
            
            ZStack {
                Circle()
                    .fill(color)
                    .frame(width: 46, height: 46)
            }
            
            Image(systemName: safeSymbol(step.symbolName))
                .font(.title3.bold())
                .foregroundStyle(.white)
            
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

#Preview {
    ContentView()
}
