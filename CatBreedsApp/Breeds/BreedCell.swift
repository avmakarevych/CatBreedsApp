//
//  BreedCell.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//

import SwiftUI
import Lottie

struct BreedCell: View {
    let breed: Breed
    @StateObject private var viewModel: BreedCellViewModel
    
    init(breed: Breed) {
        self.breed = breed
        _viewModel = StateObject(wrappedValue: BreedCellViewModel(breed: breed))
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Rectangle()
                    .foregroundColor(.gray.opacity(0.2))
                    .frame(height: 150)
                    .cornerRadius(8)
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 150)
                        .cornerRadius(8)
                        .clipped()
                } else {
                    LottieView(animation: .named("LoadingAnimation"))
                        .looping()
                        .animationSpeed(0.5)
                        .resizable()
                        .frame(height: 150)
                        .cornerRadius(8)
                }
            }
            Text(breed.name)
                .font(.nohemi(.medium, size: 14))
                .foregroundColor(.primary)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(height: 20)
        }
        .frame(width: 150)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

