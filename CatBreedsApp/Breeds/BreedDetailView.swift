//
//  BreedDetailView.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//

import SwiftUI
import Lottie

struct BreedDetailView: View {
    // MARK: - Properties
    let breed: Breed
    @StateObject private var viewModel: BreedCellViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Initialization
    init(breed: Breed) {
        self.breed = breed
        _viewModel = StateObject(wrappedValue: BreedCellViewModel(breed: breed))
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            AppColor.background
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                headerView
                
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        breedImageView
                        
                        breedOriginView
                        
                        breedDescriptionView
                        
                        wikipediaLinkView
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    // MARK: - Subviews
    
    private var headerView: some View {
        HStack {
            backButton
            
            Spacer()
            
            Text(breed.name)
                .font(.nohemi(.bold, size: 24))
                .foregroundColor(.white)
            
            Spacer()
            
            InvisibleButton
        }
    }
    
    private var backButton: some View {
        Button(action: {
            provideHapticFeedback()
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .background(Color.pink.opacity(0.7))
                .clipShape(Circle())
        }
        .accessibilityLabel("Back")
    }
    
    private var InvisibleButton: some View {
        Button(action: {}) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.clear)
                .padding()
        }
        .disabled(true)
    }
    
    private var breedImageView: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(20)
            } else {
                LottieView(animation: .named("LoadingAnimation"))
                    .looping()
                    .animationSpeed(0.5)
                    .resizable()
                    .frame(height: 250)
                    .onAppear {
                        viewModel.fetchImage()
                    }
            }
        }
    }
    
    private var breedOriginView: some View {
        Text("Origin: \(breed.origin ?? "Unknown")")
            .font(.nohemi(.regular, size: 20))
            .foregroundColor(.white)
            .padding(.top)
            .accessibilityLabel("Origin")
    }
    

    private var breedDescriptionView: some View {
        Text(breed.description ?? "No description available.")
            .font(.nohemi(.regular, size: 18))
            .lineSpacing(8)
            .foregroundColor(.white)
            .padding(.top)
            .accessibilityLabel("Description")
    }
    
    private var wikipediaLinkView: some View {
        Group {
            if let wikiURL = breed.wikipedia_url,
               let url = URL(string: wikiURL) {
                Link(destination: url) {
                    HStack {
                        Image(systemName: "safari")
                        Text("Read more on Wikipedia")
                    }
                    .font(.nohemi(.regular, size: 18))
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(15)
                }
                .padding(.top)
                .accessibilityLabel("Read more on Wikipedia")
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func provideHapticFeedback() {
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
    }
}

#Preview {
    BreedDetailView(breed: Breed(
        id: "abys",
        name: "Abyssinian",
        temperament: "Active, Energetic",
        origin: "Egypt",
        description: "The Abyssinian is a breed of domestic short-haired cat characterized by its slender, fine-boned body, large ears, and short coat. They are highly active and playful, making them excellent companions.",
        wikipedia_url: "https://en.wikipedia.org/wiki/Abyssinian_(cat)"
    ))
}
