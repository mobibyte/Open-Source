//
//  BottomTabBar.swift
//  UDP
//
//  Created by Diego Vester on 10/11/24.
//

//  Created by Diego V on 9/2/24.
//

import SwiftUI

struct BottomTabView: View {

    var body: some View {
        TabView {
            ListenerView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Listener")
                }
            SenderView()
                .tabItem {
                    Image(systemName: "info.circle.fill")
                    Text("Info")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    BottomTabView()
}
