//
//  ChickenAppApp.swift
//  ChickenApp
//
//  Created by Yaroslav Golinskiy on 19/09/2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct ChickenAppApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(initialState: MainFeature.State()) {
                    MainFeature()
                }
            )
        }
    }
}
