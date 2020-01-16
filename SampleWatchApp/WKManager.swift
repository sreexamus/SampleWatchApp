//
//  WKManager.swift
//  SampleWatchApp
//
//  Created by sreekanth reddy iragam reddy on 1/15/20.
//  Copyright © 2020 SampleWatch. All rights reserved.
//

import WatchConnectivity

public class UAWKWatchManager: NSObject, WCSessionDelegate {
    public var session: WCSession!
    public static let shared = UAWKWatchManager()

    // MARK: - Initializers
    private override init() {}

    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated && (session.isReachable || session.isPaired) {
            sendDataToWatchOS()
        }
    }

    public func sessionDidBecomeInactive(_ session: WCSession) {
    }

    public func sessionDidDeactivate(_ session: WCSession) {
    }

    func setupWatch() {
        if WCSession.isSupported() {
            session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func sendDataToWatchOS() {
        let payload = fetchDataForWatch()
        let payloadDictionary = ["WatchData": payload as Any]
        if session != nil {
            // Sening Message works like a queue
//            session.sendMessage(payloadDictionary,
//                                replyHandler: { (_) in
//                                    print("Success for Watch")
//            }) { (error) in
//                print("Error for watch", error)
//            }

            do {
                try self.session.updateApplicationContext(payloadDictionary)
            } catch {
                print("error")
            }
        }
    }

    func fetchDataForWatch() -> String {
        return "First Watch App Cool Swift"
    }
}

