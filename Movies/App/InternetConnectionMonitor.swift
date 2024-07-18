//
//  InternetConnectionMonitor.swift
//  Movies
//
//  Created by ios-noite-04 on 16/07/24.
//

import Foundation
import Network

class InternetConnectionMonitor {
    static let shared = InternetConnectionMonitor()
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
    
    private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            if self?.isConnected == true {
                print("Conectado à internet.")
            } else {
                print("Desconectado da internet.")
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

