//
//  ContentView.swift
//  UDP
//
//  Created by Diego on 3/6/24.
//

import SwiftUI
import Network

// Reference: https://itnext.io/udp-listener-in-swift-1e4a0c0aa461
// Run the command
// echo -n "Hello UDP-World" | nc -4u -w1 -localhost 1024

struct ContentView: View {
    @ObservedObject var udpListener = UdpListener()
    let udpPort = NWEndpoint.Port.init(integerLiteral: 12345)

    var body: some View {
        VStack{
            Text("UDP Listener App")
        }
        
        VStack{
            Text("\(udpListener.incoming)")
                .onAppear {
                    udpListener.start(port: self.udpPort)
                }
        }
    }
}

#Preview {
    ContentView()
}
