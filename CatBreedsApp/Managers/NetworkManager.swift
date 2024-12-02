//
//  NetworkManager.swift
//  CatBreedsApp
//
//  Created by Андрій Макаревич on 02.12.2024.
//
import SwiftUI
import Reachability

class NetworkManager: ObservableObject {
    let reachability = try! Reachability()
    @Published var isConnected: Bool = true

    init() {
        reachability.whenReachable = { [weak self] _ in
            DispatchQueue.main.async {
                self?.isConnected = true
            }
        }
        reachability.whenUnreachable = { [weak self] _ in
            DispatchQueue.main.async {
                self?.isConnected = false
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
