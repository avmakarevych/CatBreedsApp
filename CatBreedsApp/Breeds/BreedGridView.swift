//
//  BreedGridView.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//

import SwiftUI
import Lottie

struct BreedGridView: View {
    // MARK: - Observed Objects
    @ObservedObject var viewModel = BreedViewModel()
    @ObservedObject var networkManager = NetworkManager()
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let columns = [
                    GridItem(.adaptive(minimum: cellWidth(for: geometry.size.width)), spacing: 8)
                ]
                
                VStack {
                    HeaderView(title: "Breed List")
                    
                    SearchBar(text: $viewModel.searchText)
                        .padding(.horizontal)
                    
                    contentView(columns: columns)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Content View
    @ViewBuilder
    private func contentView(columns: [GridItem]) -> some View {
        if let errorMessage = viewModel.errorMessage {
            EmptyStateView(animationName: "NoContent", message: errorMessage, isError: true)
        } else if !networkManager.isConnected {
            EmptyStateView(animationName: "NoContent", message: "No internet connection.", isError: true)
        } else if viewModel.isLoading {
            EmptyStateView(animationName: "LoadingAnimation", message: "Loading Breeds...", isLoading: true)
        } else if viewModel.breeds.isEmpty {
            EmptyStateView(
                animationName: "NoContent",
                message: "No breeds available.",
                buttonTitle: "Try again",
                buttonAction: viewModel.fetchBreeds
            )
        } else if viewModel.filteredBreeds.isEmpty {
            EmptyStateView(animationName: "NoBreedsAvailable", message: "No breeds match your search.")
        } else {
            BreedGrid(columns: columns, breeds: viewModel.filteredBreeds)
        }
    }
    
    // MARK: - Cell Width Calculation
    private func cellWidth(for totalWidth: CGFloat) -> CGFloat {
        let minWidth: CGFloat = 150
        let maxColumns = floor(totalWidth / 160)
        let spacing: CGFloat = 16 * (maxColumns + 1)
        let adjustedWidth = (totalWidth - spacing) / maxColumns
        return max(adjustedWidth, minWidth)
    }
}

#Preview {
    BreedGridView()
}

// MARK: - Subviews

struct HeaderView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 28, weight: .bold))
            .frame(height: 44)
            .padding(.top, 16)
    }
}


struct EmptyStateView: View {
    let animationName: String
    let message: String
    var isError: Bool = false
    var isLoading: Bool = false
    var buttonTitle: String? = nil
    var buttonAction: (() -> Void)? = nil
    
    var body: some View {
        VStack {
            Spacer()
            
            LottieView(animation: .named(animationName))
                .looping()
                .resizable()
                .frame(width: 200, height: 200)
            
            Text(message)
                .font(isLoading ? .system(size: 16, weight: .medium) : .headline)
                .foregroundColor(isError ? .red : .secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let buttonTitle = buttonTitle, let action = buttonAction {
                Button(action: action) {
                    Text(buttonTitle)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
            }
            
            Spacer()
        }
    }
}

struct BreedGrid: View {
    let columns: [GridItem]
    let breeds: [Breed]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(breeds) { breed in
                    NavigationLink(destination: BreedDetailView(breed: breed)
                        .navigationBarBackButtonHidden(true)) {
                        BreedCell(breed: breed)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    BreedGridView(viewModel: BreedViewModel())
}

