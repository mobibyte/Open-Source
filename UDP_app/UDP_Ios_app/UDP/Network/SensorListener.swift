//
//  SensorListener.swift
//  handshake_ios
//
//  Created by Diego V on 9/13/24.
//

import Foundation
import Network

// SensorListner:
// Description: Listner and Connector for the PI using
//   TCP and the specific Port.
class SensorListener: NSObject, ObservableObject {
    // MARK: - properties

    private var piAddress: IPv4Address?
    private var sensorPort: NWEndpoint.Port?

    private var connection: NWConnection?
    private lazy var queue = DispatchQueue(label: "tcp.client.queue")

    var state: NWConnection.State = .preparing {
        didSet {
            DispatchQueue.main.async {
                self.updateConnectionState()
            }
        }
    }

    enum ConnectionError: Error {
        case invalidIPAddress
        case invalidPort
    }

    var receivedTime: Date?
    var lastTime: Date?
    var timeDifference: TimeInterval = 0
    var longestDifference: TimeInterval = 0
    var longerThanThreshold = 0

    // MARK: - methods


    // connect()
    /// Input: piAddress: IPv4Address, sensorPort: NWEndpoint.Port
    /// Output: Void
    /// Description: Attemping to start connection to PI w/ TCP and port,
    ///   also call stateUpdateHandler on the connection state,
    ///   then starts the connection
    func connect(to piAddress: IPv4Address, with sensorPort: NWEndpoint.Port) {
        if !NetworkViewModel.shared.getConnectionStatus() {
            DispatchQueue.global().asyncAfter(deadline: .now()) {
                let host = NWEndpoint.Host.ipv4(piAddress)
                self.connection = NWConnection(host: host, port: sensorPort, using: .tcp)
                // If there's ever a risk of self being deallocated before the connection is closed, it might lead to a crash.
                // To avoid this, consider using [weak self].
                self.connection?.stateUpdateHandler = { [unowned self] state in
                    self.state = state
                }
                self.connection?.start(queue: self.queue)
            }
        }
    }

    // updateConnectionState
    // Description: Changes states based
    //   on connection state to the PI
    private func updateConnectionState() {
        switch state {
        case .ready:
            if connection != nil {
                receive(on: connection!)
                // Modify the NetworkViewModel on the main thread
                DispatchQueue.main.async {
                    NetworkViewModel.shared.updateConnectionStatus(isConnected: true)
                }
            }
        default:
            retryConnection()
        }
    }

    // retryConnection
    // Description: Attempts to reconnect to the PI
    private func retryConnection() {
        if let piAddress = piAddress, let sensorPort = sensorPort {
            connect(to: piAddress, with: sensorPort)
        }
    }

    // cleanupConnection
    // Description: removes the current state and
    //   cancels any connections that are currently happening,
    //   and turns the connection to nil
    func cleanupConnection() {
        if NetworkViewModel.shared.getConnectionStatus() {
            if let connection = connection {
                // Modify the NetworkViewModel on the main thread
                DispatchQueue.main.async {
                    NetworkViewModel.shared.updateConnectionStatus(isConnected: false)
                }
                connection.stateUpdateHandler = nil

                connection.cancel()
                self.connection = nil
            }
        }
    }

    // recieve
    // input: connection: NWConnection
    // output: void
    // description: Recieving data from the PI,
    //   if theres an error or if theres empty data we retry connection.
    //   We also account for the time difference for each time we recieve data
    func receive(on connection: NWConnection) {
        print("receive()")
        connection.receive(minimumIncompleteLength: 46, maximumLength: 46) { data, _, _, error in
            if let error = error {
                print(error)
                self.retryConnection()
                return
            }

            guard let data = data, !data.isEmpty else {
                print("unable to receive data, attempting to reconnect")
                self.retryConnection()
                return
            }

            self.lastTime = self.receivedTime
            self.receivedTime = Date()
            self.timeDifference = (self.receivedTime ?? Date()) - (self.lastTime ?? Date())
            if self.timeDifference > self.longestDifference {
                self.longestDifference = self.timeDifference
            }
            if self.timeDifference > 0.08 {
                self.longerThanThreshold += 1
            }
            self.receive(on: connection)
        }
    }
}

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
