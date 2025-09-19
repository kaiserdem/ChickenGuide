//
//  GalleryView.swift
//  ChickenApp
//
//  Created by Yaroslav Golinskiy on 19/09/2025.
//

import SwiftUI
import ComposableArchitecture

struct GalleryView: View {
    let store: StoreOf<GalleryFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationView {
                ZStack {
                    Theme.Gradients.gallery
                        .ignoresSafeArea()
                    
                    ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 15) {
                        ForEach(viewStore.images) { item in
                            GalleryCard(item: item) {
                                viewStore.send(.selectImage(item.id))
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
                    }
                }
                .navigationTitle("Chicken Gallery")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    viewStore.send(.onAppear)
                }
            }
            .sheet(item: viewStore.binding(
                get: { $0.selectedImage },
                send: { .selectImage($0) }
            )) { imageId in
                if let item = viewStore.images.first(where: { $0.id == imageId }) {
                    GalleryDetailView(item: item)
                }
            }
        }
    }
}

struct GalleryCard: View {
    let item: GalleryItem
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            // Placeholder for image (using SF Symbol for now)
            Image(systemName: "photo")
                .font(.system(size: 50))
                .foregroundColor(Theme.Palette.goldAccent)
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Theme.Palette.goldAccent.opacity(Theme.Opacity.overlay))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(item.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.Palette.white)
                
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(Theme.Palette.white.opacity(Theme.Opacity.textTertiary))
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Theme.Palette.white.opacity(Theme.Opacity.cardBackground))
        .cornerRadius(15)
        .shadow(color: Theme.Shadows.medium, radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Theme.Palette.goldAccent.opacity(0.3), lineWidth: 1)
        )
        .onTapGesture {
            onTap()
        }
    }
}

struct GalleryDetailView: View {
    let item: GalleryItem
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Image
                    Image(systemName: "photo")
                        .font(.system(size: 100))
                        .foregroundColor(.orange)
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(15)
                    
                    // Information
                    VStack(alignment: .leading, spacing: 15) {
                        Text(item.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(item.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        // Additional Information
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Додаткова інформація")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            InfoRow(title: "Breed", value: "Domestic Chicken")
                            InfoRow(title: "Size", value: "Medium")
                            InfoRow(title: "Temperament", value: "Friendly")
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    GalleryView(
        store: Store(initialState: GalleryFeature.State()) {
            GalleryFeature()
        }
    )
}
