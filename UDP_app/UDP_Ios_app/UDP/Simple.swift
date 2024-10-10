//
//  Simple.swift
//  UDP
//
//  Created by Diego on 3/11/24.
//

import Foundation
import Network

class Simple: ObservableObject {
    var name: String
    var age: Int
    var listener: NWListener?

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    func Dylo()
    {
        print("Name: \(name)")
        print("Age: \(age)")
    }
    
    /// Creating the listener
    func listenTime(port: NWEndpoint.Port)
    {
        do {
            self.listener = try NWListener(using: .udp, on: port)
            print("creating listener")
        } catch {
            print("exception upon creating listener")
        }
    }
    
    /// stateUpdateHandler needs to be defined
    func prepareUpdateHandler() {
        print("prepareUpdateHandler")
        self.listener?.stateUpdateHandler = {(newState) in
            switch newState {
            case .ready:
                print("ready")
            default:
                break
            }
        }
    }
    
    /// Accepting New Connections
    func prepareNewConnectionHandler() {
        self.listener?.newConnectionHandler = {(newConnection) in newConnection.stateUpdateHandler = {newState in
            switch newState {
            case .ready:
                print("ready")
                self.receive(on: newConnection)
            default:
                break
            }
            }
        }
    }
    
    /// Receiving Messages
    func receive(on connection: NWConnection) {
        connection.receiveMessage {(data, context, isComplete, error) in
            if let error = error {
                print(error)
            }
            print(data ?? "bob")
        }
    }
    
    /// Starting the Listener
    func startListener(){
        self.listener?.start(queue: .main)
    }
}
