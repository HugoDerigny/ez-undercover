import Foundation
import SwiftData

// MARK: - SwiftData

/// Joueur enregistré : réimportable dans une nouvelle partie, avec sa photo et son score.
/// Les valeurs par défaut permettent la migration automatique depuis la V1.
@Model
final class SavedPlayer {
    @Attribute(.unique) var key: String = ""
    var name: String = ""
    var lastUsed: Date = Date.now
    var gamesPlayed: Int = 0
    var wins: Int = 0
    var score: Int = 0
    @Attribute(.externalStorage) var photoData: Data?

    init(name: String, photoData: Data? = nil, gamesPlayed: Int = 0) {
        self.key = name.normalizedKey
        self.name = name
        self.photoData = photoData
        self.gamesPlayed = gamesPlayed
    }
}

/// Mot déjà joué : il ne sera plus jamais tiré tant que l'historique n'est pas réinitialisé.
@Model
final class UsedWord {
    @Attribute(.unique) var key: String
    var word: String
    var catalogRaw: String
    var date: Date

    init(word: String, catalog: WordCatalog, date: Date = .now) {
        self.key = word.normalizedKey
        self.word = word
        self.catalogRaw = catalog.rawValue
        self.date = date
    }
}

// MARK: - Barème

/// Chaque joueur de l'équipe gagnante marque les points de son rôle
/// (même s'il a été éliminé en cours de partie).
enum ScoreRules {
    static let civil = 2
    static let undercover = 4
    static let mrWhite = 6

    static func points(for role: Role, winner: GameStore.Winner) -> Int {
        switch (winner, role) {
        case (.civils, .civil): civil
        case (.undercovers, .undercover), (.infiltrators, .undercover): undercover
        case (.mrWhite, .mrWhite), (.infiltrators, .mrWhite): mrWhite
        default: 0
        }
    }

    static var summary: String {
        "Barème : civil \(civil) pts · undercover \(undercover) pts · Mr White \(mrWhite) pts, pour chaque joueur de l'équipe gagnante."
    }
}

// MARK: - Normalisation

extension String {
    /// Minuscules, sans accents, sans espaces superflus.
    var normalizedKey: String {
        folding(
            options: [.diacriticInsensitive, .caseInsensitive, .widthInsensitive],
            locale: Locale(identifier: "fr_FR")
        )
        .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Clé de comparaison tolérante pour la proposition de Mr White
    /// (ignore casse, accents, ponctuation, article initial et pluriel simple).
    var guessKey: String {
        var s = normalizedKey.replacingOccurrences(of: "’", with: "'")
        s = s.replacingOccurrences(of: "[^a-z0-9' ]", with: " ", options: .regularExpression)
        s = s.split(separator: " ").joined(separator: " ")

        let articles = ["de la ", "de l'", "les ", "des ", "une ", "du ", "un ", "le ", "la ", "l'", "d'"]
        for article in articles where s.hasPrefix(article) {
            s.removeFirst(article.count)
            break
        }
        if s.count > 3, s.hasSuffix("s") || s.hasSuffix("x") {
            s.removeLast()
        }
        return s
    }
}
