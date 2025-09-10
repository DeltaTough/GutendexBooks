//
//  NetworkMonitor.swift
//  BookStore
//
//  Created by Dimitrios Tsoumanis on 07/09/2025.
//

import Network
import SwiftUI

protocol NetworkMonitoring {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

final class NetworkMonitor: ObservableObject, NetworkMonitoring {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published var isConnected = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
