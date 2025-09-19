//
//  GalleryFeature.swift
//  ChickenApp
//
//  Created by Yaroslav Golinskiy on 19/09/2025.
//

import ComposableArchitecture

@Reducer
struct GalleryFeature {
    @ObservableState
    struct State: Equatable {
        var selectedImage: String?
        var images: [GalleryItem] = [
            GalleryItem(id: "1", name: "Rhode Island Red", imageName: "chicken1", description: "Popular breed for egg production"),
            GalleryItem(id: "2", name: "Leghorn", imageName: "chicken2", description: "Known for high egg production"),
            GalleryItem(id: "3", name: "Brahma", imageName: "chicken3", description: "Large breed with beautiful plumage"),
            GalleryItem(id: "4", name: "Sussex", imageName: "chicken4", description: "Dual-purpose breed for eggs and meat")
        ]
    }
    
    enum Action {
        case selectImage(String?)
        case onAppear
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case let .selectImage(imageId):
            state.selectedImage = imageId
            return .none
        case .onAppear:
            return .none
        }
    }
}

struct GalleryItem: Equatable, Identifiable {
    let id: String
    let name: String
    let imageName: String
    let description: String
}
