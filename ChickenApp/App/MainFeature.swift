import ComposableArchitecture
import SwiftUI

@Reducer
struct MainFeature {
    @ObservableState
    struct State: Equatable {
        var selectedTab: Tab = .home
        var home = HomeFeature.State()
        var gallery = GalleryFeature.State()
        var facts = FactsFeature.State()
        var quiz = QuizFeature.State()
    }
    
    enum Action {
        case selectTab(Tab)
        case home(HomeFeature.Action)
        case gallery(GalleryFeature.Action)
        case facts(FactsFeature.Action)
        case quiz(QuizFeature.Action)
    }
    
    enum Tab: String, CaseIterable {
        case home = "Home"
        case gallery = "Gallery"
        case facts = "Facts"
        case quiz = "Quiz"
        
        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .gallery: return "photo.fill"
            case .facts: return "book.fill"
            case .quiz: return "brain.head.profile"
            }
        }
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        Scope(state: \.gallery, action: \.gallery) {
            GalleryFeature()
        }
        Scope(state: \.facts, action: \.facts) {
            FactsFeature()
        }
        Scope(state: \.quiz, action: \.quiz) {
            QuizFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .selectTab(tab):
                state.selectedTab = tab
                return .none
            case .home, .gallery, .facts, .quiz:
                return .none
            }
        }
    }
}

