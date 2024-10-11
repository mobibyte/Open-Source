//
//  ListenerView.swift
//  UDP
//
//  Created by Diego Vester on 10/11/24.
//

import SwiftUI
import Network

struct ListenerView: View {
    @ObservedObject var udpListener = UdpListener()
    let udpPort = NWEndpoint.Port.init(integerLiteral: 12345)

    var body: some View {
        VStack{
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
}

#Preview {
    ListenerView()
}
