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
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .selectTab(tab):
            state.selectedTab = tab
            return .none
        case let .home(homeAction):
            return HomeFeature().reduce(into: &state.home, action: homeAction)
                .map(Action.home)
        case let .gallery(galleryAction):
            return GalleryFeature().reduce(into: &state.gallery, action: galleryAction)
                .map(Action.gallery)
        case let .facts(factsAction):
            return FactsFeature().reduce(into: &state.facts, action: factsAction)
                .map(Action.facts)
        case let .quiz(quizAction):
            return QuizFeature().reduce(into: &state.quiz, action: quizAction)
                .map(Action.quiz)
        }
    }
}

