
import ComposableArchitecture

@Reducer
struct HomeFeature {
    @ObservableState
    struct State: Equatable {
        var welcomeMessage: String = "Welcome to Chicken App! 🐔"
        var factsReadCount: Int = 0
        var lastFact: String = "Chickens can live up to 10-15 years!"
    }
    
    enum Action {
        case onAppear
        case factRead
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .none
        case .factRead:
            state.factsReadCount += 1
            return .none
        }
    }
}
