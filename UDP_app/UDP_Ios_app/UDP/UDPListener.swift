//
//  UDPListener.swift
//  UDP
//
//  Created by Diego on 3/14/24.
//

import Foundation
import Network

class UdpListener: NSObject, ObservableObject {
    
    private var connection: NWConnection?
    /// An object you use to listen for incoming network connections
    private var listener: NWListener?
    
    @Published var incoming: String = ""
    
    func start(port: NWEndpoint.Port) {
        /// Create the listener
        do {
            self.listener = try NWListener(using: .udp, on: port)
        } catch {
            print("exception upon creating listener")
        }
        
        guard let _ = listener else { return }
        
        prepareUpdateHandler()
        prepareNewConnectionHandler()
        
        self.listener?.start(queue: .main)
    }
    
    /// Accept new connections
    func prepareUpdateHandler() {
        /// Handler that receives listener state updates
        self.listener?.stateUpdateHandler = {(newState) in
            switch newState {
            case .ready:
                print("ready")
            default:
                break
            }
        }
    }
    
    func prepareNewConnectionHandler() {
        self.listener?.newConnectionHandler = {(newConnection) in
            newConnection.stateUpdateHandler = {newState in
                switch newState {
                case .ready:
                    print("ready")
                    self.receive(on: newConnection)
                default:
                    break
                }
            }
            newConnection.start(queue: DispatchQueue(label: "newconn"))
        }
    }
    
    func receive(on connection: NWConnection) {
        connection.receiveMessage { (data, context, isComplete, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data, !data.isEmpty else {
                print("unable to receive data")
                return
            }
            
            DispatchQueue.main.async {
                self.incoming = String(decoding: data, as: UTF8.self)
                print(self.incoming)
                connection.cancel()
            }
        }
    }
}
