import SwiftUI
import SwiftData

// MARK: - Bouton quitter

struct QuitButton: View {
    @Environment(GameStore.self) private var store
    @State private var confirm = false

    var body: some View {
        Button("Quitter", systemImage: "xmark") { confirm = true }
            .labelStyle(.iconOnly)
            .confirmationDialog("Abandonner la partie ?", isPresented: $confirm, titleVisibility: .visible) {
                Button("Abandonner", role: .destructive) { store.backToSetup() }
                Button("Continuer à jouer", role: .cancel) {}
            }
    }
}

// MARK: - Distribution des mots (iPhone passé de main en main)

struct RevealView: View {
    @Environment(GameStore.self) private var store
    @State private var isShown = false

    private var isLast: Bool { store.revealIndex == store.players.count - 1 }

    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: Double(store.revealIndex), total: Double(max(store.players.count, 1)))
                .padding(.top, 8)

            Spacer()

            if let player = store.currentRevealPlayer {
                if isShown {
                    wordCard(for: player)
                        .transition(.blurReplace)
                } else {
                    handoffCard(for: player)
                        .transition(.blurReplace)
                }
            }

            Spacer()

            Button {
                withAnimation(.smooth) {
                    if isShown {
                        isShown = false
                        store.advanceReveal()
                    } else {
                        isShown = true
                    }
                }
            } label: {
                Text(buttonTitle).frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .controlSize(.large)
        }
        .padding()
        .navigationTitle("Distribution")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarLeading) { QuitButton() } }
        .sensoryFeedback(.impact, trigger: store.revealIndex)
    }

    private var buttonTitle: String {
        if !isShown { return "Voir mon mot" }
        return isLast ? "Masquer et commencer" : "Masquer et passer au suivant"
    }

    private func handoffCard(for player: Player) -> some View {
        VStack(spacing: 12) {
            AvatarView(name: player.name, photoData: player.photoData, size: 104)
                .padding(5)
                .overlay { Circle().strokeBorder(Theme.accent, lineWidth: 3) }
            Text("Passe l'iPhone à")
                .foregroundStyle(.secondary)
            Text(player.name)
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
            Text("Joueur \(store.revealIndex + 1) sur \(store.players.count)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .glassCard()
    }

    private func wordCard(for player: Player) -> some View {
        VStack(spacing: 14) {
            if let word = player.word {
                Text("Ton mot")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(word)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                Text("Mémorise-le sans le dire, puis masque l'écran.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Image(systemName: Role.mrWhite.symbol)
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.accent)
                Text("Tu es Mr White")
                    .font(.title.bold())
                Text("Tu n'as pas de mot. Écoute les indices des autres et fais semblant de savoir. Si tu es démasqué, tu pourras tenter de deviner le mot des civils.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .glassCard(tint: player.word == nil ? Theme.accent.opacity(0.25) : nil)
    }
}

// MARK: - Manche : discussion & vote

struct DiscussionView: View {
    @Environment(GameStore.self) private var store

    var body: some View {
        List {
            if let starter = store.starter {
                Section {
                    StarterHero(player: starter)
                        .id(starter.id) // rejoue l'animation à chaque manche
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowBackground(Color.clear)
                }
            }

            Section {
                ForEach(Array(store.speakingOrder.enumerated()), id: \.element.id) { index, player in
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption.bold().monospacedDigit())
                            .foregroundStyle(.secondary)
                            .frame(width: 16)
                        AvatarView(name: player.name, photoData: player.photoData, size: 36)
                        Text(player.name)
                        Spacer()
                        EliminateButton(player: player)
                    }
                }
            } header: {
                Text("Ordre de parole")
            } footer: {
                Text("Un indice court chacun, sans dire son mot. Mr White ne commence jamais. Votez ensuite à voix haute, puis éliminez le joueur désigné.")
            }

            if !store.eliminatedPlayers.isEmpty {
                Section("Éliminés") {
                    ForEach(store.eliminatedPlayers) { player in
                        HStack(spacing: 12) {
                            AvatarView(name: player.name, photoData: player.photoData, size: 32)
                                .opacity(0.5)
                            Text(player.name).strikethrough()
                            Spacer()
                            Label(player.role.title, systemImage: player.role.symbol)
                                .font(.caption)
                                .foregroundStyle(player.role.tint)
                        }
                        .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Manche \(store.round)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarLeading) { QuitButton() } }
    }
}

/// Mise en avant du joueur qui ouvre le tour de table.
private struct StarterHero: View {
    let player: Player
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 16) {
            Text("PREMIER À PARLER")
                .font(.caption.weight(.semibold))
                .tracking(3)
                .foregroundStyle(.secondary)

            AvatarView(name: player.name, photoData: player.photoData, size: 120)
                .padding(6)
                .overlay { Circle().strokeBorder(Theme.accent, lineWidth: 4) }
                .shadow(color: Theme.accent.opacity(0.35), radius: 18, y: 8)
                .scaleEffect(appeared ? 1 : 0.8)
                .opacity(appeared ? 1 : 0)

            Text(player.name)
                .font(.system(size: 46, weight: .heavy, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundStyle(Theme.accent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
        .padding(.horizontal, 20)
        .glassEffect(.regular.tint(Theme.accent.opacity(0.10)), in: .rect(cornerRadius: 36))
        .onAppear {
            withAnimation(.spring(duration: 0.6, bounce: 0.35)) { appeared = true }
        }
    }
}

/// La confirmation est attachée au bouton lui-même : sur iPad et Mac,
/// la bulle s'ancre ainsi sur « Éliminer » et non en haut de la vue.
private struct EliminateButton: View {
    @Environment(GameStore.self) private var store
    let player: Player
    @State private var confirm = false

    var body: some View {
        Button("Éliminer") { confirm = true }
            .buttonStyle(.glass)
            .controlSize(.small)
            .confirmationDialog(
                "Éliminer \(player.name) ?",
                isPresented: $confirm,
                titleVisibility: .visible
            ) {
                Button("Éliminer \(player.name)", role: .destructive) {
                    store.eliminate(player.id)
                }
                Button("Annuler", role: .cancel) {}
            }
    }
}

// MARK: - Révélation du rôle de l'éliminé

struct EliminationView: View {
    @Environment(GameStore.self) private var store
    @Environment(\.modelContext) private var context

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            if let player = store.lastEliminated {
                VStack(spacing: 12) {
                    AvatarView(name: player.name, photoData: player.photoData, size: 96)
                        .padding(5)
                        .overlay { Circle().strokeBorder(player.role.tint, lineWidth: 3) }
                    Text(player.name)
                        .font(.largeTitle.bold())
                        .multilineTextAlignment(.center)
                    Label(player.role.title, systemImage: player.role.symbol)
                        .font(.title2.bold())
                        .foregroundStyle(player.role.tint)

                    if let guess = store.lastGuess {
                        Text(store.mrWhiteGuessedRight
                             ? "A deviné « \(guess) » : bien joué !"
                             : "A proposé « \(guess) » : raté.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .glassCard(tint: player.role.tint.opacity(0.2))
            }

            if store.winner == nil {
                Text("\(store.alivePlayers.count) joueurs restent en jeu.")
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button {
                store.continueAfterElimination(context: context)
            } label: {
                Text(store.winner == nil ? "Manche suivante" : "Voir le résultat")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .controlSize(.large)
        }
        .padding()
        .navigationTitle("Éliminé")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarLeading) { QuitButton() } }
        .sensoryFeedback(.impact(weight: .heavy), trigger: store.lastEliminatedID)
    }
}

// MARK: - Dernière chance de Mr White

struct MrWhiteGuessView: View {
    @Environment(GameStore.self) private var store
    @State private var guess = ""
    @FocusState private var focused: Bool

    private var trimmed: String { guess.trimmingCharacters(in: .whitespacesAndNewlines) }
    private var name: String { store.lastEliminated?.name ?? "Mr White" }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 14) {
                AvatarView(name: name, photoData: store.lastEliminated?.photoData, size: 88)
                    .padding(5)
                    .overlay { Circle().strokeBorder(Role.mrWhite.tint, lineWidth: 3) }
                Text("\(name) est Mr White !")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                Text("Dernière chance : devine le mot des civils pour l'emporter. Passe l'iPhone à \(name).")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                TextField("Le mot des civils", text: $guess)
                    .focused($focused)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.go)
                    .onSubmit(submit)
                    .padding(14)
                    .background(.thinMaterial, in: .rect(cornerRadius: 16))
            }
            .frame(maxWidth: .infinity)
            .glassCard()

            Spacer()

            Button(action: submit) {
                Label("Valider", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .controlSize(.large)
            .disabled(trimmed.isEmpty)
        }
        .padding()
        .navigationTitle("Dernière chance")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .topBarLeading) { QuitButton() } }
        .task { focused = true }
    }

    private func submit() {
        guard !trimmed.isEmpty else { return }
        focused = false
        store.submitMrWhiteGuess(trimmed)
    }
}

// MARK: - Résultat

struct ResultView: View {
    @Environment(GameStore.self) private var store
    @Environment(\.modelContext) private var context
    @State private var showExhausted = false

    private struct Headline {
        let title: String
        let subtitle: String
        let symbol: String
    }

    private var headline: Headline {
        switch store.winner {
        case .civils:
            Headline(title: "Les civils gagnent !", subtitle: "Tous les infiltrés ont été démasqués.", symbol: "party.popper.fill")
        case .undercovers:
            Headline(title: "Les undercovers gagnent !", subtitle: "Ils ont survécu jusqu'au bout.", symbol: "theatermasks.fill")
        case .infiltrators:
            Headline(title: "Les infiltrés gagnent !", subtitle: "Undercovers et Mr White l'emportent ensemble.", symbol: "theatermasks.fill")
        case .mrWhite:
            Headline(
                title: "Mr White gagne !",
                subtitle: store.mrWhiteGuessedRight ? "Il a deviné le mot des civils." : "Il est resté caché jusqu'à la fin.",
                symbol: "questionmark.circle.fill"
            )
        case nil:
            Headline(title: "Partie terminée", subtitle: "", symbol: "flag.checkered")
        }
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 8) {
                    Image(systemName: headline.symbol)
                        .font(.system(size: 48))
                        .foregroundStyle(Theme.accent)
                    Text(headline.title)
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                    if !headline.subtitle.isEmpty {
                        Text(headline.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .listRowBackground(Color.clear)
            }

            Section("Les mots") {
                LabeledContent("Civils", value: store.civilWord)
                LabeledContent("Undercovers", value: store.undercoverWord)
            }

            Section {
                ForEach(store.players) { player in
                    let points = store.pointsEarned[player.id] ?? 0
                    HStack(spacing: 12) {
                        AvatarView(name: player.name, photoData: player.photoData, size: 40)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(player.name).strikethrough(!player.isAlive)
                            Label(player.role.title, systemImage: player.role.symbol)
                                .font(.caption)
                                .foregroundStyle(player.role.tint)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 2) {
                            Text(points > 0 ? "+\(points)" : "0")
                                .font(.headline.monospacedDigit())
                                .foregroundStyle(points > 0 ? Theme.accent : .secondary)
                            Text(player.word ?? "—")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            } header: {
                Text("Les joueurs")
            } footer: {
                Text(ScoreRules.summary)
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Résultat")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .safeAreaInset(edge: .bottom) {
            HStack(spacing: 12) {
                Button("Terminer") { store.backToSetup() }
                    .buttonStyle(.glass)
                Button {
                    if store.startGame(context: context) == .noPairsLeft {
                        showExhausted = true
                    }
                } label: {
                    Label("Rejouer", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.glassProminent)
            }
            .controlSize(.large)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .alert("Plus de mots disponibles", isPresented: $showExhausted) {
            Button("Réinitialiser l'historique", role: .destructive) {
                store.resetUsedWords(context: context)
            }
            Button("Annuler", role: .cancel) {}
        } message: {
            Text("Toutes les paires de la liste « \(store.catalog.title) » ont déjà été jouées. Réinitialiser l'historique de cette liste ?")
        }
        .sensoryFeedback(.success, trigger: store.winner)
    }
}
