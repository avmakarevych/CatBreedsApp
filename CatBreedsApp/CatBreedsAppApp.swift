//
//  CatBreedsAppApp.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//

import SwiftUI

@main
struct CatBreedsAppApp: App {    
    var body: some Scene {
        WindowGroup {
            BreedGridView()
                .environmentObject(NetworkManager())
                .preferredColorScheme(.light)
        }
    }
}

