//
//  NetworkViewModel.swift
//  handshake_ios
//
//  Created by Diego V on 9/13/24.
//

import Foundation

// Singleton class to manage the network state
class NetworkViewModel: ObservableObject {
    static let shared = NetworkViewModel()

    @Published var networkModel: NetworkModel

    // Private initializer to ensure singleton usage
    private init() {
        networkModel = NetworkModel(isConnected: false)
    }

    // Method to update the connection state
    func updateConnectionStatus(isConnected: Bool) {
        networkModel.isConnected = isConnected
        print("isConnected = \(networkModel.isConnected) #DEBUG")
    }

    // Thread-safe getter for the connection status
    func getConnectionStatus() -> Bool {
        networkModel.isConnected
    }
}
