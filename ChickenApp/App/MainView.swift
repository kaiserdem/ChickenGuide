import SwiftUI
import ComposableArchitecture

struct AppView: View {
    let store: StoreOf<MainFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            TabView(selection: viewStore.binding(
                get: \.selectedTab,
                send: { .selectTab($0) }
            )) {
                HomeView(
                    store: self.store.scope(
                        state: \.home,
                        action: \.home
                    )
                )
                .tabItem {
                    Image(systemName: MainFeature.Tab.home.icon)
                    Text(MainFeature.Tab.home.rawValue)
                }
                .tag(MainFeature.Tab.home)
                
                GalleryView(
                    store: self.store.scope(
                        state: \.gallery,
                        action: \.gallery
                    )
                )
                .tabItem {
                    Image(systemName: MainFeature.Tab.gallery.icon)
                    Text(MainFeature.Tab.gallery.rawValue)
                }
                .tag(MainFeature.Tab.gallery)
                
                FactsView(
                    store: self.store.scope(
                        state: \.facts,
                        action: \.facts
                    )
                )
                .tabItem {
                    Image(systemName: MainFeature.Tab.facts.icon)
                    Text(MainFeature.Tab.facts.rawValue)
                }
                .tag(MainFeature.Tab.facts)
                
                QuizView(
                    store: self.store.scope(
                        state: \.quiz,
                        action: \.quiz
                    )
                )
                .tabItem {
                    Image(systemName: MainFeature.Tab.quiz.icon)
                    Text(MainFeature.Tab.quiz.rawValue)
                }
                .tag(MainFeature.Tab.quiz)
            }
            .accentColor(Theme.Palette.goldAccent)
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                
                let gradientLayer = CAGradientLayer()
                gradientLayer.colors = [
                    Theme.Palette.primaryDark.cgColor,
                    Theme.Palette.vibrantPurple.cgColor,
                    Theme.Palette.brightRed.cgColor
                ]
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 1)
                gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
                UIGraphicsBeginImageContext(gradientLayer.frame.size)
                gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
                let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                appearance.backgroundImage = gradientImage
                appearance.backgroundColor = UIColor.clear
                
                appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.7)
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                    .foregroundColor: UIColor.white.withAlphaComponent(0.7)
                ]
                
                appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                    .foregroundColor: UIColor.white
                ]
                
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
                
                UITabBar.appearance().layer.shadowColor = UIColor.black.cgColor
                UITabBar.appearance().layer.shadowOffset = CGSize(width: 0, height: -2)
                UITabBar.appearance().layer.shadowOpacity = 0.3
                UITabBar.appearance().layer.shadowRadius = 8
                UITabBar.appearance().clipsToBounds = false
            }
        }
    }
}

