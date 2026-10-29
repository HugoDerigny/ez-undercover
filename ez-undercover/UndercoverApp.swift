// Undercover — SwiftUI · iOS 26+ (Liquid Glass, SwiftData) · V1.1
import SwiftUI
import SwiftData

@main
struct UndercoverApp: App {
    @State private var store = GameStore()

    init() {
        WordLibrary.validate()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .tint(Theme.accent)
        }
        .modelContainer(for: [SavedPlayer.self, UsedWord.self])
    }
}

// MARK: - Onglets

struct RootView: View {
    var body: some View {
        TabView {
            Tab("Jouer", systemImage: "play.circle.fill") {
                PlayTab()
            }
            Tab("Classement", systemImage: "trophy.fill") {
                NavigationStack { LeaderboardView() }
            }
            Tab("Historique", systemImage: "clock.arrow.circlepath") {
                NavigationStack { HistoryView() }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

/// Onglet « Jouer » : configuration puis déroulé de la partie.
/// La barre d'onglets est masquée pendant la partie pour éviter les fausses manips.
struct PlayTab: View {
    @Environment(GameStore.self) private var store

    var body: some View {
        NavigationStack {
            Group {
                switch store.phase {
                case .setup: SetupView()
                case .reveal: RevealView()
                case .discussion: DiscussionView()
                case .eliminated: EliminationView()
                case .mrWhiteGuess: MrWhiteGuessView()
                case .result: ResultView()
                }
            }
            .pastelBackground()
            .toolbarVisibility(store.phase == .setup ? .automatic : .hidden, for: .tabBar)
        }
        .animation(.smooth, value: store.phase)
    }
}
