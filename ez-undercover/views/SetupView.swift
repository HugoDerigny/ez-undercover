import SwiftUI
import SwiftData

// MARK: - Configuration

struct SetupView: View {
    @Environment(GameStore.self) private var store
    @Environment(\.modelContext) private var context
    @Query private var usedWords: [UsedWord]
    @Query private var savedPlayers: [SavedPlayer]

    @State private var draft = ""
    @State private var draftPhoto: Data?
    @State private var errorMessage: String?
    @State private var showImport = false
    @State private var showExhausted = false
    @State private var editMode: EditMode = .inactive
    @FocusState private var fieldFocused: Bool

    private var trimmedDraft: String { draft.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        Form {
            playersSection
            rolesSection
            wordsSection
        }
        .scrollContentBackground(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .environment(\.editMode, $editMode)
        .navigationTitle("Undercover")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(editMode.isEditing ? "Terminé" : "Modifier") {
                    withAnimation { editMode = editMode.isEditing ? .inactive : .active }
                }
                .disabled(store.roster.isEmpty)
            }
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Terminé") { fieldFocused = false }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: start) {
                Label("Lancer la partie", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .controlSize(.large)
            .disabled(!store.canStart)
            .padding(.horizontal)
            .padding(.bottom, 8)
        }
        .sheet(isPresented: $showImport) { ImportPlayersSheet() }
        .alert("Plus de mots disponibles", isPresented: $showExhausted) {
            Button("Réinitialiser l'historique", role: .destructive) {
                store.resetUsedWords(context: context)
            }
            Button("Annuler", role: .cancel) {}
        } message: {
            Text("Toutes les paires de la liste « \(store.catalog.title) » ont déjà été jouées (ou sont masquées par tes thèmes). Réinitialiser l'historique de cette liste ?")
        }
        .sensoryFeedback(.warning, trigger: errorMessage)
    }

    // MARK: Sections

    private var playersSection: some View {
        Section {
            HStack(spacing: 12) {
                AvatarPicker(name: draft, photoData: $draftPhoto, size: 44)

                TextField("Nom du joueur", text: $draft)
                    .focused($fieldFocused)
                    .submitLabel(.done)
                    .textInputAutocapitalization(.words)
                    .onSubmit(submitDraft)

                Button("Ajouter", systemImage: "plus.circle.fill", action: addDraft)
                    .labelStyle(.iconOnly)
                    .font(.title2)
                    .buttonStyle(.borderless)
                    .disabled(trimmedDraft.isEmpty)
            }

            ForEach(store.roster) { entry in
                RosterRow(entry: entry)
            }
            .onDelete { store.roster.remove(atOffsets: $0) }
            .onMove { store.roster.move(fromOffsets: $0, toOffset: $1) }

            Button("Importer des joueurs enregistrés", systemImage: "person.crop.circle.badge.plus") {
                fieldFocused = false
                showImport = true
            }
        } header: {
            Text("Joueurs")
        } footer: {
            if let errorMessage {
                Text(errorMessage).foregroundStyle(Theme.accent)
            } else {
                Text("\(store.roster.count)/\(GameStore.maxPlayers) joueurs · minimum \(GameStore.minPlayers). Touche l'avatar pour ajouter une photo. L'ordre correspond à l'ordre de passage de l'iPhone.")
            }
        }
    }

    private var rolesSection: some View {
        Section {
            Toggle("Mr White", isOn: Bindable(store).includeMrWhite)

            Stepper(
                "Undercovers : \(store.spies)",
                value: Binding(get: { store.spies }, set: { store.spyOverride = $0 }),
                in: store.minSpies...store.maxSpies
            )
            .disabled(store.minSpies == store.maxSpies)

            if store.spyOverride != nil {
                Button("Répartition automatique", systemImage: "wand.and.stars") {
                    store.spyOverride = nil
                }
            }
        } header: {
            Text("Rôles")
        } footer: {
            if store.roster.count >= GameStore.minPlayers {
                Text("\(store.distributionSummary). Maximum \(store.maxSpies) undercover\(store.maxSpies > 1 ? "s" : "") : civils − 1 − Mr White.")
            } else {
                Text("Ajoute au moins \(GameStore.minPlayers) joueurs pour voir la répartition.")
            }
        }
    }

    private var wordsSection: some View {
        Section {
            Picker("Liste de mots", selection: Bindable(store).catalog) {
                ForEach(WordCatalog.allCases) { catalog in
                    Text(catalog.title).tag(catalog)
                }
            }
            .pickerStyle(.segmented)

            NavigationLink {
                ThemePickerView()
            } label: {
                LabeledContent("Thèmes", value: "\(enabledThemeCount)/\(WordLibrary.themes(for: store.catalog).count)")
            }

            LabeledContent("Paires restantes", value: "\(remainingPairs) / \(totalPairs)")
        } header: {
            Text("Mots")
        } footer: {
            Text(store.catalog.subtitle)
        }
    }

    // MARK: Calculs

    private var enabledThemeCount: Int {
        WordLibrary.themes(for: store.catalog).filter { !store.excludedThemes.contains($0.id) }.count
    }

    private var totalPairs: Int {
        WordLibrary.pairs(for: store.catalog).filter { !store.excludedThemes.contains($0.themeID) }.count
    }

    private var remainingPairs: Int {
        WordLibrary.availablePairs(
            catalog: store.catalog,
            excludedThemes: store.excludedThemes,
            usedKeys: Set(usedWords.map(\.key))
        ).count
    }

    // MARK: Actions

    private func addDraft() {
        // Réutilise la photo du joueur enregistré s'il porte déjà ce nom.
        let saved = savedPlayers.first { $0.key == draft.normalizedKey }
        let photo = draftPhoto ?? saved?.photoData

        if let error = store.addPlayer(name: draft, photoData: photo) {
            errorMessage = error
        } else {
            errorMessage = nil
            draft = ""
            draftPhoto = nil
        }
        fieldFocused = true // enchaîne les saisies ; « Terminé » ferme le clavier
    }

    private func submitDraft() {
        if trimmedDraft.isEmpty {
            fieldFocused = false
        } else {
            addDraft()
        }
    }

    private func start() {
        fieldFocused = false
        if store.startGame(context: context) == .noPairsLeft {
            showExhausted = true
        }
    }
}

// MARK: - Ligne de joueur

private struct RosterRow: View {
    @Environment(GameStore.self) private var store
    let entry: RosterEntry

    var body: some View {
        HStack(spacing: 12) {
            AvatarPicker(
                name: entry.name,
                photoData: Binding(
                    get: { entry.photoData },
                    set: { store.setPhoto($0, for: entry.id) }
                ),
                size: 40
            )
            Text(entry.name)
        }
    }
}

// MARK: - Import de joueurs enregistrés

struct ImportPlayersSheet: View {
    @Environment(GameStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \SavedPlayer.lastUsed, order: .reverse) private var saved: [SavedPlayer]

    @State private var selection: Set<String> = []
    @State private var search = ""

    private var inGameKeys: Set<String> { Set(store.roster.map { $0.name.normalizedKey }) }
    private var slotsLeft: Int { GameStore.maxPlayers - store.roster.count }

    private var filtered: [SavedPlayer] {
        guard !search.isEmpty else { return saved }
        return saved.filter { $0.key.contains(search.normalizedKey) }
    }

    var body: some View {
        NavigationStack {
            List {
                if saved.isEmpty {
                    ContentUnavailableView(
                        "Aucun joueur enregistré",
                        systemImage: "person.2.slash",
                        description: Text("Les joueurs des parties lancées apparaîtront ici.")
                    )
                    .listRowBackground(Color.clear)
                }

                ForEach(filtered) { player in
                    let inGame = inGameKeys.contains(player.key)
                    Button {
                        toggle(player)
                    } label: {
                        HStack(spacing: 12) {
                            AvatarView(name: player.name, photoData: player.photoData, size: 40)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(player.name)
                                Text("\(player.gamesPlayed) partie\(player.gamesPlayed > 1 ? "s" : "") · \(player.score) pts")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            if inGame {
                                Text("Dans la partie").font(.caption).foregroundStyle(.secondary)
                            } else if selection.contains(player.key) {
                                Image(systemName: "checkmark.circle.fill").foregroundStyle(Theme.accent)
                            } else {
                                Image(systemName: "circle").foregroundStyle(.secondary)
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .disabled(inGame)
                }
            }
            .scrollContentBackground(.hidden)
            .pastelBackground()
            .searchable(text: $search, prompt: "Rechercher")
            .navigationTitle("Joueurs enregistrés")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer", systemImage: "xmark") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Ajouter (\(selection.count))") { addSelected() }
                        .disabled(selection.isEmpty)
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func toggle(_ player: SavedPlayer) {
        if selection.contains(player.key) {
            selection.remove(player.key)
        } else if selection.count < slotsLeft {
            selection.insert(player.key)
        }
    }

    private func addSelected() {
        for player in saved where selection.contains(player.key) {
            _ = store.addPlayer(name: player.name, photoData: player.photoData)
        }
        dismiss()
    }
}

// MARK: - Thèmes

struct ThemePickerView: View {
    @Environment(GameStore.self) private var store

    var body: some View {
        let themes = WordLibrary.themes(for: store.catalog)
        let enabledCount = themes.filter { !store.excludedThemes.contains($0.id) }.count

        List {
            Section {
                ForEach(themes) { theme in
                    Toggle(isOn: Binding(
                        get: { !store.excludedThemes.contains(theme.id) },
                        set: { isOn in
                            if !isOn && enabledCount <= 1 { return }
                            store.setTheme(theme.id, enabled: isOn)
                        }
                    )) {
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(theme.name)
                                Text("\(theme.pairCount) paires")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        } icon: {
                            Image(systemName: theme.symbol)
                        }
                    }
                }
            } footer: {
                Text("Au moins un thème doit rester actif.")
            }
        }
        .scrollContentBackground(.hidden)
        .pastelBackground()
        .navigationTitle(store.catalog.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
