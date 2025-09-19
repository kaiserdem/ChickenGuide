//
//  HomeView.swift
//  ChickenApp
//
//  Created by Yaroslav Golinskiy on 19/09/2025.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    let store: StoreOf<HomeFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                Theme.Gradients.primary
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 10) {
                        Text("🐔")
                            .font(.system(size: 60))
                        
                        Text(viewStore.welcomeMessage)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Theme.Palette.white)
                    }
                    .padding(.top, 20)
                    
                    // Statistics
                    VStack(spacing: 15) {
                        Text("Your Statistics")
                            .font(.headline)
                            .foregroundColor(Theme.Palette.white.opacity(Theme.Opacity.textSecondary))
                        
                        HStack(spacing: 30) {
                            VStack {
                                Text("\(viewStore.factsReadCount)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.Palette.goldAccent)
                                Text("Facts Read")
                                    .font(.caption)
                                    .foregroundColor(Theme.Palette.white.opacity(Theme.Opacity.textTertiary))
                            }
                            
                            VStack {
                                Text("4")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Theme.Palette.vibrantGreen)
                                Text("Sections")
                                    .font(.caption)
                                    .foregroundColor(Theme.Palette.white.opacity(Theme.Opacity.textTertiary))
                            }
                        }
                    }
                    .padding()
                    .background(Theme.Palette.white.opacity(Theme.Opacity.cardBackground))
                    .cornerRadius(15)
                    .shadow(color: Theme.Shadows.medium, radius: 10, x: 0, y: 5)
                    
                    // Last Fact
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Latest Interesting Fact")
                            .font(.headline)
                            .foregroundColor(Theme.Palette.white.opacity(Theme.Opacity.textSecondary))
                        
                        Text(viewStore.lastFact)
                            .font(.body)
                            .foregroundColor(Theme.Palette.white)
                            .padding()
                            .background(Theme.Palette.goldAccent.opacity(Theme.Opacity.overlay))
                            .cornerRadius(10)
                            .shadow(color: Theme.Shadows.light, radius: 5, x: 0, y: 2)
                            .onTapGesture {
                                viewStore.send(.factRead)
                            }
                    }
                    
                    // Quick Access
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Quick Access")
                            .font(.headline)
                            .foregroundColor(Theme.Palette.white.opacity(Theme.Opacity.textSecondary))
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                            QuickAccessCard(
                                title: "Gallery",
                                icon: "photo.fill",
                                color: Theme.Palette.vibrantBlue
                            )
                            
                            QuickAccessCard(
                                title: "Facts",
                                icon: "book.fill",
                                color: Theme.Palette.vibrantGreen
                            )
                            
                            QuickAccessCard(
                                title: "Quiz",
                                icon: "brain.head.profile",
                                color: Theme.Palette.vibrantPurple
                            )
                            
                            QuickAccessCard(
                                title: "About App",
                                icon: "info.circle.fill",
                                color: Theme.Palette.vibrantOrange
                            )
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.horizontal, 20)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct QuickAccessCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Theme.Palette.white)
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(color.opacity(Theme.Opacity.cardBackground))
        .cornerRadius(15)
        .shadow(color: Theme.Shadows.medium, radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

#Preview {
    HomeView(
        store: Store(initialState: HomeFeature.State()) {
            HomeFeature()
        }
    )
}
