//
//  SenderView.swift
//  UDP
//
//  Created by Diego Vester on 10/11/24.
//

import SwiftUI
import Network

struct SenderView: View {
    @ObservedObject var tcpSender = TCPSender()
    // make sure the port matches to the port used on the external device!
    let sensorPort = NWEndpoint.Port(integerLiteral: 23456)
    
    // Change the IP address to match the raspberry pi that you are using!
    let piAddress: IPv4Address = .init("192.168.100.64")! // For Raspberry Pi

    var messageToSend : String = "Hello Preston"
    
    var body: some View {
        Text("SenderView")
            .font(.title)
        
        padding()
        Button("Connect") {
            tcpSender.connect(to: piAddress, with: sensorPort)
        }
        padding()
        Button("Send Message") {
            tcpSender.send(messageToSend: messageToSend)
        }
        
        
    }
}

#Preview {
    SenderView()
}
