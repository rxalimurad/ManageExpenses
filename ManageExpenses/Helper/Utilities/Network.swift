//
//  Network.swift
//  ManageExpenses
//
//  Created by Ali Murad on 24/11/2022.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
     
    @Published var disconnected = true
     
    init() {
        monitor.pathUpdateHandler =  { [weak self] path in
            DispatchQueue.main.async {
                self?.disconnected = path.status != .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}

