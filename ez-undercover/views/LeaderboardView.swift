//
//  LeaderboardView.swift
//  MyApp
//
//  Created by Hugo Derigny on 29/10/2026.
//


import SwiftUI
import SwiftData

// MARK: - Classement

struct LeaderboardView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: [
        SortDescriptor(\SavedPlayer.score, order: .reverse),
        SortDescriptor(\SavedPlayer.name)
    ]) private var players: [SavedPlayer]

    @State private var editing: SavedPlayer?
    @State private var confirmReset = false

    var body: some View {
        List {
            if players.isEmpty {
                ContentUnavailableView(
                    "Pas encore de classement",
                    systemImage: "trophy",
                    description: Text("Lance une partie : les joueurs et leurs points apparaîtront ici.")
                )
                .listRowBackground(Color.clear)
            } else {
                Section {
                    ForEach(Array(players.enumerated()), id: \.element.id) { index, player in
                        Button {
                            editing = player
                        } label: {
                            LeaderboardRow(rank: index + 1, player: player)
                        }
                        .buttonStyle(.plain)
                    }
                } footer: {
                    Text(ScoreRules.summary)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .pastelBackground()
        .navigationTitle("Classement")
        .toolbar {
            if !players.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Remettre les scores à zéro", systemImage: "arrow.counterclockwise", role: .destructive) {
                            confirmReset = true
                        }
                    } label: {
                        Label("Options", systemImage: "ellipsis")
                    }
                }
            }
        }
        .sheet(item: $editing) { SavedPlayerEditor(player: $0) }
        .confirmationDialog(
            "Remettre tous les scores à zéro ?",
            isPresented: $confirmReset,
            titleVisibility: .visible
        ) {
            Button("Remettre à zéro", role: .destructive) { resetScores() }
            Button("Annuler", role: .cancel) {}
        } message: {
            Text("Les points et les victoires de tous les joueurs seront effacés. Les joueurs restent enregistrés.")
        }
    }

    private func resetScores() {
        for player in players {
            player.score = 0
            player.wins = 0
        }
        try? context.save()
    }
}

private struct LeaderboardRow: View {
    let rank: Int
    let player: SavedPlayer

    private var rankColor: Color {
        switch rank {
        case 1: Color(hex: 0xE0B040)
        case 2: Color(hex: 0xA8B0BC)
        case 3: Color(hex: 0xC88A5A)
        default: .secondary
        }
    }

    var body: some View {
        HStack(spacing: 12) {
            Text("\(rank)")
                .font(.subheadline.bold().monospacedDigit())
                .frame(width: 28, height: 28)
                .background(rankColor.opacity(0.3), in: .circle)

            AvatarView(name: player.name, photoData: player.photoData, size: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text(player.name).font(.headline)
                Text("\(player.wins) victoire\(player.wins > 1 ? "s" : "") · \(player.gamesPlayed) partie\(player.gamesPlayed > 1 ? "s" : "")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 0) {
                Text("\(player.score)")
                    .font(.title2.bold().monospacedDigit())
                Text("pts")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
    }
}

// MARK: - Édition d'un joueur enregistré

struct SavedPlayerEditor: View {
    let player: SavedPlayer

    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var allPlayers: [SavedPlayer]

    @State private var name: String
    @State private var photo: Data?
    @State private var errorMessage: String?
    @State private var confirmDelete = false

    init(player: SavedPlayer) {
        self.player = player
        _name = State(initialValue: player.name)
        _photo = State(initialValue: player.photoData)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        AvatarPicker(name: name, photoData: $photo, size: 96)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                Section {
                    TextField("Nom", text: $name)
                        .textInputAutocapitalization(.words)
                } header: {
                    Text("Nom")
                } footer: {
                    if let errorMessage {
                        Text(errorMessage).foregroundStyle(Theme.accent)
                    }
                }

                Section("Statistiques") {
                    LabeledContent("Score", value: "\(player.score) pts")
                    LabeledContent("Victoires", value: "\(player.wins)")
                    LabeledContent("Parties", value: "\(player.gamesPlayed)")
                }

                Section {
                    Button("Remettre le score à zéro", systemImage: "arrow.counterclockwise") {
                        player.score = 0
                        player.wins = 0
                        try? context.save()
                    }
                    Button("Supprimer ce joueur", systemImage: "trash", role: .destructive) {
                        confirmDelete = true
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .pastelBackground()
            .navigationTitle("Joueur")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annuler") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enregistrer", action: save)
                }
            }
            .confirmationDialog(
                "Supprimer \(player.name) ?",
                isPresented: $confirmDelete,
                titleVisibility: .visible
            ) {
                Button("Supprimer", role: .destructive) {
                    context.delete(player)
                    try? context.save()
                    dismiss()
                }
                Button("Annuler", role: .cancel) {}
            } message: {
                Text("Son score et sa photo seront perdus.")
            }
        }
        .presentationDetents([.large])
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Le nom ne peut pas être vide."
            return
        }
        let key = trimmed.normalizedKey
        if allPlayers.contains(where: { $0.key == key && $0 !== player }) {
            errorMessage = "« \(trimmed) » existe déjà."
            return
        }
        player.name = trimmed
        player.key = key
        player.photoData = photo
        try? context.save()
        dismiss()
    }
}