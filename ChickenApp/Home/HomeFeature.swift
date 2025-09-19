//
//  HomeFeature.swift
//  ChickenApp
//
//  Created by Yaroslav Golinskiy on 19/09/2025.
//

import ComposableArchitecture

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        var welcomeMessage = "Welcome to Chicken App! 🐔"
        var factsReadCount = 0
        var lastFact = "Chickens can live up to 10-15 years!"
    }
    
    enum Action {
        case onAppear
        case factRead
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .factRead:
                state.factsReadCount += 1
                return .none
            }
        }
    }
}
