import SwiftUI
import SwiftData

// MARK: - Rôles & joueurs

enum Role: Hashable {
    case civil, undercover, mrWhite

    var title: String {
        switch self {
        case .civil: "Civil"
        case .undercover: "Undercover"
        case .mrWhite: "Mr White"
        }
    }

    var symbol: String {
        switch self {
        case .civil: "person.fill"
        case .undercover: "theatermasks.fill"
        case .mrWhite: "questionmark.circle.fill"
        }
    }

    var tint: Color {
        switch self {
        case .civil: Color(light: Color(hex: 0x2E9E73), dark: Color(hex: 0x6FD9AE))
        case .undercover: Color(light: Color(hex: 0x7C5CD6), dark: Color(hex: 0xB7A2FF))
        case .mrWhite: Color(light: Color(hex: 0xD98A1F), dark: Color(hex: 0xFFC266))
        }
    }
}

/// Joueur inscrit avant la partie (nom + photo facultative).
struct RosterEntry: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var photoData: Data?
}

/// Joueur en cours de partie.
struct Player: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var photoData: Data?
    var role: Role = .civil
    var word: String?
    var isAlive = true
}

// MARK: - Store

@MainActor
@Observable
final class GameStore {
    enum Phase: Equatable { case setup, reveal, discussion, eliminated, mrWhiteGuess, result }
    enum Winner: Equatable { case civils, undercovers, mrWhite, infiltrators }
    enum StartResult: Equatable { case started, noPairsLeft, invalid }

    static let minPlayers = 3
    static let maxPlayers = 20

    // MARK: Réglages de la partie

    var roster: [RosterEntry] = []
    var includeMrWhite = false
    /// `nil` = répartition automatique.
    var spyOverride: Int?
    var catalog: WordCatalog = .mainstream
    private(set) var excludedThemes: Set<String> = Set(
        UserDefaults.standard.stringArray(forKey: "excludedThemes") ?? []
    )

    // MARK: État de la partie

    private(set) var phase: Phase = .setup
    private(set) var players: [Player] = []
    private(set) var civilWord = ""
    private(set) var undercoverWord = ""
    private(set) var revealIndex = 0
    private(set) var starterIndex = 0
    private(set) var round = 1
    private(set) var lastEliminatedID: UUID?
    private(set) var lastGuess: String?
    private(set) var winner: Winner?
    private(set) var pointsEarned: [UUID: Int] = [:]

    // MARK: Répartition des rôles

    var mrWhiteCount: Int { includeMrWhite ? 1 : 0 }
    private var planningCount: Int { max(roster.count, Self.minPlayers) }

    /// Sans Mr White, il faut au moins 1 undercover ; avec Mr White, 0 est possible.
    var minSpies: Int { includeMrWhite ? 0 : 1 }

    /// Limite : undercovers ≤ civils − 1 − Mr White, avec civils = n − undercovers − Mr White.
    /// Ce qui revient à : undercovers ≤ (n − 1 − 2 × Mr White) / 2.
    var maxSpies: Int {
        max(minSpies, (planningCount - 1 - 2 * mrWhiteCount) / 2)
    }

    /// ≈ 1 infiltré pour 4 joueurs (Mr White inclus dans ce total).
    var defaultSpies: Int {
        let infiltrators = max(1, Int((Double(planningCount) / 4).rounded()))
        return min(max(infiltrators - mrWhiteCount, minSpies), maxSpies)
    }

    var spies: Int { min(max(spyOverride ?? defaultSpies, minSpies), maxSpies) }
    var civilCount: Int { roster.count - spies - mrWhiteCount }
    var canStart: Bool { (Self.minPlayers...Self.maxPlayers).contains(roster.count) }

    var distributionSummary: String {
        var parts = ["\(civilCount) civil\(civilCount > 1 ? "s" : "")"]
        if spies > 0 { parts.append("\(spies) undercover\(spies > 1 ? "s" : "")") }
        if includeMrWhite { parts.append("1 Mr White") }
        return parts.joined(separator: " · ")
    }

    // MARK: Joueurs

    /// Retourne un message d'erreur, ou `nil` si le joueur a été ajouté (ou ignoré car nom vide).
    func addPlayer(name raw: String, photoData: Data? = nil) -> String? {
        let name = String(raw.trimmingCharacters(in: .whitespacesAndNewlines).prefix(20))
        guard !name.isEmpty else { return nil }
        guard roster.count < Self.maxPlayers else { return "Maximum \(Self.maxPlayers) joueurs." }
        guard !roster.contains(where: { $0.name.normalizedKey == name.normalizedKey }) else {
            return "« \(name) » est déjà dans la partie."
        }
        roster.append(RosterEntry(name: name, photoData: photoData))
        return nil
    }

    func setPhoto(_ data: Data?, for id: RosterEntry.ID) {
        guard let index = roster.firstIndex(where: { $0.id == id }) else { return }
        roster[index].photoData = data
    }

    func setTheme(_ id: String, enabled: Bool) {
        if enabled { excludedThemes.remove(id) } else { excludedThemes.insert(id) }
        UserDefaults.standard.set(Array(excludedThemes), forKey: "excludedThemes")
    }

    // MARK: Démarrage

    func startGame(context: ModelContext) -> StartResult {
        guard canStart else { return .invalid }

        let usedKeys = Set(((try? context.fetch(FetchDescriptor<UsedWord>())) ?? []).map(\.key))
        let available = WordLibrary.availablePairs(
            catalog: catalog,
            excludedThemes: excludedThemes,
            usedKeys: usedKeys
        )
        guard let pair = available.randomElement() else { return .noPairsLeft }

        // Le mot « civil » est tiré au hasard dans la paire.
        let swapped = Bool.random()
        civilWord = swapped ? pair.b : pair.a
        undercoverWord = swapped ? pair.a : pair.b

        // Rôles aléatoires.
        var roles = Array(repeating: Role.civil, count: roster.count)
        var pool = Array(roster.indices).shuffled()
        if includeMrWhite { roles[pool.removeFirst()] = .mrWhite }
        for _ in 0..<spies { roles[pool.removeFirst()] = .undercover }

        players = zip(roster, roles).map { entry, role in
            Player(name: entry.name, photoData: entry.photoData, role: role, word: word(for: role))
        }

        // Mr White ne commence jamais.
        starterIndex = players.indices.filter { players[$0].role != .mrWhite }.randomElement() ?? 0
        revealIndex = 0
        round = 1
        winner = nil
        lastGuess = nil
        lastEliminatedID = nil
        pointsEarned = [:]

        persistStart(pair: pair, context: context)
        phase = .reveal
        return .started
    }

    private func word(for role: Role) -> String? {
        switch role {
        case .civil: civilWord
        case .undercover: undercoverWord
        case .mrWhite: nil
        }
    }

    private func persistStart(pair: WordPair, context: ModelContext) {
        // Mots utilisés
        context.insert(UsedWord(word: pair.a, catalog: catalog))
        context.insert(UsedWord(word: pair.b, catalog: catalog))

        // Joueurs enregistrés (nom, photo, nombre de parties)
        let saved = (try? context.fetch(FetchDescriptor<SavedPlayer>())) ?? []
        for entry in roster {
            if let existing = saved.first(where: { $0.key == entry.name.normalizedKey }) {
                existing.name = entry.name
                if let photo = entry.photoData { existing.photoData = photo }
                existing.lastUsed = .now
                existing.gamesPlayed += 1
            } else {
                context.insert(SavedPlayer(name: entry.name, photoData: entry.photoData, gamesPlayed: 1))
            }
        }
        try? context.save()
    }

    func resetUsedWords(context: ModelContext) {
        let raw = catalog.rawValue
        try? context.delete(model: UsedWord.self, where: #Predicate { $0.catalogRaw == raw })
        try? context.save()
    }

    // MARK: Distribution des mots

    var currentRevealPlayer: Player? {
        players.indices.contains(revealIndex) ? players[revealIndex] : nil
    }

    func advanceReveal() {
        if revealIndex + 1 < players.count {
            revealIndex += 1
        } else {
            phase = .discussion
        }
    }

    // MARK: Manches

    var starter: Player? {
        players.indices.contains(starterIndex) ? players[starterIndex] : nil
    }

    var alivePlayers: [Player] { players.filter(\.isAlive) }
    var eliminatedPlayers: [Player] { players.filter { !$0.isAlive } }
    var lastEliminated: Player? { players.first { $0.id == lastEliminatedID } }
    var mrWhiteGuessedRight: Bool { winner == .mrWhite && lastGuess != nil }

    /// Joueurs en vie, dans l'ordre de parole à partir du premier.
    var speakingOrder: [Player] {
        guard !players.isEmpty else { return [] }
        return (0..<players.count)
            .map { players[(starterIndex + $0) % players.count] }
            .filter(\.isAlive)
    }

    func eliminate(_ id: Player.ID) {
        guard let index = players.firstIndex(where: { $0.id == id }), players[index].isAlive else { return }
        lastGuess = nil
        lastEliminatedID = id
        if players[index].role == .mrWhite {
            phase = .mrWhiteGuess
        } else {
            players[index].isAlive = false
            winner = evaluateWinner()
            phase = .eliminated
        }
    }

    func submitMrWhiteGuess(_ text: String) {
        guard let id = lastEliminatedID,
              let index = players.firstIndex(where: { $0.id == id }) else { return }
        lastGuess = text
        players[index].isAlive = false
        winner = text.guessKey == civilWord.guessKey ? .mrWhite : evaluateWinner()
        phase = .eliminated
    }

    func continueAfterElimination(context: ModelContext) {
        if winner != nil {
            awardScores(context: context)
            phase = .result
        } else {
            round += 1
            starterIndex = nextStarter(after: starterIndex)
            phase = .discussion
        }
    }

    func backToSetup() {
        phase = .setup
    }

    // MARK: Scores

    private func awardScores(context: ModelContext) {
        guard let winner else { return }
        let saved = (try? context.fetch(FetchDescriptor<SavedPlayer>())) ?? []
        var earned: [UUID: Int] = [:]

        for player in players {
            let points = ScoreRules.points(for: player.role, winner: winner)
            earned[player.id] = points
            guard let record = saved.first(where: { $0.key == player.name.normalizedKey }) else { continue }
            record.score += points
            if points > 0 { record.wins += 1 }
        }

        pointsEarned = earned
        try? context.save()
    }

    // MARK: Règles

    private func nextStarter(after index: Int) -> Int {
        let count = players.count
        for offset in 1...count {
            let candidate = (index + offset) % count
            if players[candidate].isAlive && players[candidate].role != .mrWhite { return candidate }
        }
        return index
    }

    private func evaluateWinner() -> Winner? {
        let alive = players.filter(\.isAlive)
        let civils = alive.filter { $0.role == .civil }.count
        let undercovers = alive.filter { $0.role == .undercover }.count
        let whites = alive.filter { $0.role == .mrWhite }.count
        let infiltrators = undercovers + whites

        if infiltrators == 0 { return .civils }
        guard civils <= infiltrators else { return nil }

        switch (undercovers > 0, whites > 0) {
        case (true, true): return .infiltrators
        case (true, false): return .undercovers
        default: return .mrWhite
        }
    }
}
