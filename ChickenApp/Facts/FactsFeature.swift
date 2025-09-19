//
//  FactsFeature.swift
//  ChickenApp
//
//  Created by Yaroslav Golinskiy on 19/09/2025.
//

import ComposableArchitecture

@Reducer
struct FactsFeature {
    @ObservableState
    struct State: Equatable {
        var facts: [ChickenFact] = [
            ChickenFact(
                id: "1",
                title: "Lifespan",
                content: "Chickens can live up to 10-15 years, although most domestic chickens live 5-8 years.",
                category: .behavior
            ),
            ChickenFact(
                id: "2",
                title: "Egg Colors",
                content: "Chickens can lay eggs of different colors: white, brown, cream, greenish, and even blue!",
                category: .anatomy
            ),
            ChickenFact(
                id: "3",
                title: "Social Animals",
                content: "Chickens have a complex social hierarchy known as the 'pecking order'.",
                category: .behavior
            ),
            ChickenFact(
                id: "4",
                title: "Memory",
                content: "Chickens can remember up to 100 different faces and distinguish them.",
                category: .intelligence
            ),
            ChickenFact(
                id: "5",
                title: "Sleep",
                content: "Chickens sleep on perches, holding onto them with their claws to avoid falling.",
                category: .behavior
            ),
            ChickenFact(
                id: "6",
                title: "Body Temperature",
                content: "Normal chicken body temperature is 40-42°C, which is higher than human temperature.",
                category: .anatomy
            )
        ]
        var selectedCategory: FactCategory? = nil
        var searchText = ""
    }
    
    enum Action {
        case selectCategory(FactCategory?)
        case searchTextChanged(String)
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectCategory(category):
                state.selectedCategory = category
                return .none
            case let .searchTextChanged(text):
                state.searchText = text
                return .none
            case .onAppear:
                return .none
            }
        }
    }
}

struct ChickenFact: Equatable, Identifiable {
    let id: String
    let title: String
    let content: String
    let category: FactCategory
}

enum FactCategory: String, CaseIterable {
    case behavior = "Behavior"
    case anatomy = "Anatomy"
    case intelligence = "Intelligence"
    case history = "History"
    
    var icon: String {
        switch self {
        case .behavior: return "figure.walk"
        case .anatomy: return "heart.fill"
        case .intelligence: return "brain.head.profile"
        case .history: return "book.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .behavior: return .blue
        case .anatomy: return .red
        case .intelligence: return .purple
        case .history: return .green
        }
    }
}
