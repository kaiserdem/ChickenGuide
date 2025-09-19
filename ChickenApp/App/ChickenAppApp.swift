
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
