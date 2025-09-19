//
//  FactsView.swift
//  ChickenApp
//
//  Created by Yaroslav Golinskiy on 19/09/2025.
//

import SwiftUI
import ComposableArchitecture

struct FactsView: View {
    let store: StoreOf<FactsFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                ZStack {
                    Theme.Gradients.facts
                        .ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                    // Search
                    SearchBar(text: viewStore.binding(
                        get: \.searchText,
                        send: { .searchTextChanged($0) }
                    ))
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            CategoryButton(
                                title: "All",
                                isSelected: viewStore.selectedCategory == nil,
                                color: .orange
                            ) {
                                viewStore.send(.selectCategory(nil))
                            }
                            
                            ForEach(FactCategory.allCases, id: \.self) { category in
                                CategoryButton(
                                    title: category.rawValue,
                                    isSelected: viewStore.selectedCategory == category,
                                    color: category.color
                                ) {
                                    viewStore.send(.selectCategory(category))
                                }
                            }
                        }
                        .padding(.horizontal, 15)
                    }
                    .padding(.vertical, 10)
                    
                    // Facts List
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(filteredFacts(viewStore)) { fact in
                                FactCard(fact: fact)
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.bottom, 20)
                    }
                }
                }
                .navigationTitle("Interesting Facts")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
        }
    }
    
    private func filteredFacts(_ viewStore: ViewStore<FactsFeature.State, FactsFeature.Action>) -> [ChickenFact] {
        var facts = viewStore.facts
        
        // Фільтр по категорії
        if let category = viewStore.selectedCategory {
            facts = facts.filter { $0.category == category }
        }
        
        // Фільтр по пошуку
        if !viewStore.searchText.isEmpty {
            facts = facts.filter { fact in
                fact.title.localizedCaseInsensitiveContains(viewStore.searchText) ||
                fact.content.localizedCaseInsensitiveContains(viewStore.searchText)
            }
        }
        
        return facts
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search facts...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(Theme.Palette.white.opacity(Theme.Opacity.cardBackground))
        .cornerRadius(10)
        .shadow(color: Theme.Shadows.light, radius: 5, x: 0, y: 2)
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? Theme.Palette.white : color)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(isSelected ? color : color.opacity(0.1))
                .cornerRadius(20)
        }
    }
}

struct FactCard: View {
    let fact: ChickenFact
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: fact.category.icon)
                    .foregroundColor(fact.category.color)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(fact.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Palette.white)
                    
                    Text(fact.category.rawValue)
                        .font(.caption)
                        .foregroundColor(fact.category.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(fact.category.color.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            
            Text(fact.content)
                .font(.body)
                .foregroundColor(Theme.Palette.white.opacity(Theme.Opacity.textSecondary))
                .lineLimit(nil)
        }
        .padding()
        .background(Theme.Palette.white.opacity(Theme.Opacity.cardBackground))
        .cornerRadius(15)
        .shadow(color: Theme.Shadows.medium, radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(fact.category.color.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    FactsView(
        store: Store(initialState: FactsFeature.State()) {
            FactsFeature()
        }
    )
}
