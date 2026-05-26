//
//  MyBaliAppApp.swift
//  MyBaliApp
//
//  Created by Ivan on 03/03/26.
//

import SwiftUI

@main
struct MyBaliAppApp: App {
    var body: some Scene {
        WindowGroup {
            TabView{
                Screen1View()
                    .tabItem{
                        Label("Home", systemImage: "house")
                    }
                SavedView()
                    .tabItem{
                        Label("Saved", systemImage: "bookmark")
                    }
            }
        }
    }
}


