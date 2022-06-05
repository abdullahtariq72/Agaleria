//
//  NetworkUtility.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 04/06/2022.
//

import Foundation

import Reachability

class NetworkUtility: NSObject {
    
    var reachability: Reachability!

    // Create a singleton instance
    static let sharedInstance: NetworkUtility = { return NetworkUtility() }()


    override init() {
        super.init()

        // Initialise reachability
        reachability = try? Reachability()

        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )

        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    @objc func networkStatusChanged(_ notification: Notification) {
        // Do something globally here!
    }

    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkUtility.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }

    // Network is reachable
    static func isReachable(completed: @escaping (NetworkUtility) -> Void) {
        if (NetworkUtility.sharedInstance.reachability).connection != .unavailable {
            completed(NetworkUtility.sharedInstance)
        }
    }

    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkUtility) -> Void) {
        if (NetworkUtility.sharedInstance.reachability).connection == .unavailable {
            completed(NetworkUtility.sharedInstance)
        }
    }

    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkUtility) -> Void) {
        if (NetworkUtility.sharedInstance.reachability).connection == .cellular {
            completed(NetworkUtility.sharedInstance)
        }
    }

    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkUtility) -> Void) {
        if (NetworkUtility.sharedInstance.reachability).connection == .wifi {
            completed(NetworkUtility.sharedInstance)
        }
    }
}
