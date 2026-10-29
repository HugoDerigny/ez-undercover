import Foundation

// MARK: - Catalogues

enum WordCatalog: String, CaseIterable, Identifiable {
    case mainstream
    case genZ

    var id: String { rawValue }

    var title: String {
        switch self {
        case .mainstream: "Grand public"
        case .genZ: "Gen Z"
        }
    }

    var subtitle: String {
        switch self {
        case .mainstream: "Animaux, plats, métiers, pays, objets du quotidien… des mots que tout le monde connaît."
        case .genZ: "Rappeurs, streamers, jeux vidéo, animes, apps, sneakers, mèmes… pour les plus jeunes."
        }
    }
}

struct WordTheme: Identifiable, Hashable {
    let id: String
    let name: String
    let symbol: String
    let pairCount: Int
}

struct WordPair: Hashable {
    let a: String
    let b: String
    let themeID: String
    let keyA: String
    let keyB: String

    init(a: String, b: String, themeID: String) {
        self.a = a
        self.b = b
        self.themeID = themeID
        self.keyA = a.normalizedKey
        self.keyB = b.normalizedKey
    }
}

// MARK: - Données brutes

/// Une paire = `Mot1|Mot2`, séparées par `;`, 5 paires par ligne.
private struct RawTheme {
    let id: String
    let name: String
    let symbol: String
    let raw: String
}

private let grandPublicThemes: [RawTheme] = [
    RawTheme(id: "gp.animaux", name: "Animaux", symbol: "pawprint.fill", raw: gpAnimaux),
    RawTheme(id: "gp.plats", name: "Plats & cuisine", symbol: "fork.knife", raw: gpPlats),
    RawTheme(id: "gp.gourmandises", name: "Fruits, légumes & desserts", symbol: "birthday.cake.fill", raw: gpGourmandises),
    RawTheme(id: "gp.boissons", name: "Boissons", symbol: "cup.and.saucer.fill", raw: gpBoissons),
    RawTheme(id: "gp.maison", name: "Maison & objets", symbol: "sofa.fill", raw: gpMaison),
    RawTheme(id: "gp.mode", name: "Vêtements & accessoires", symbol: "tshirt.fill", raw: gpMode),
    RawTheme(id: "gp.transports", name: "Transports", symbol: "car.fill", raw: gpTransports),
    RawTheme(id: "gp.metiers", name: "Métiers", symbol: "briefcase.fill", raw: gpMetiers),
    RawTheme(id: "gp.sports", name: "Sports & loisirs", symbol: "figure.run", raw: gpSports),
    RawTheme(id: "gp.nature", name: "Nature & saisons", symbol: "mountain.2.fill", raw: gpNature),
    RawTheme(id: "gp.corps", name: "Corps & santé", symbol: "cross.case.fill", raw: gpCorps),
    RawTheme(id: "gp.arts", name: "Musique & arts", symbol: "music.note", raw: gpArts),
    RawTheme(id: "gp.fetes", name: "Fêtes & famille", symbol: "gift.fill", raw: gpFetes),
    RawTheme(id: "gp.geo", name: "Pays & villes", symbol: "globe.europe.africa.fill", raw: gpGeo),
    RawTheme(id: "gp.culture", name: "Cinéma & culture", symbol: "film.fill", raw: gpCulture),
    RawTheme(id: "gp.tech", name: "Technologie", symbol: "laptopcomputer", raw: gpTech),
    RawTheme(id: "gp.ecole", name: "École & études", symbol: "graduationcap.fill", raw: gpEcole)
]

private let genZThemes: [RawTheme] = [
    RawTheme(id: "gz.rapfr", name: "Rap français", symbol: "mic.fill", raw: gzRapFR),
    RawTheme(id: "gz.rapus", name: "Rap US & monde", symbol: "headphones", raw: gzRapUS),
    RawTheme(id: "gz.streamers", name: "Streamers & YouTubeurs", symbol: "tv.fill", raw: gzStreamers),
    RawTheme(id: "gz.apps", name: "Apps & réseaux", symbol: "iphone", raw: gzApps),
    RawTheme(id: "gz.jeux", name: "Jeux vidéo", symbol: "gamecontroller.fill", raw: gzJeux),
    RawTheme(id: "gz.series", name: "Séries & films", symbol: "popcorn.fill", raw: gzSeries),
    RawTheme(id: "gz.animes", name: "Animes & mangas", symbol: "sparkles", raw: gzAnimes),
    RawTheme(id: "gz.musique", name: "Pop & festivals", symbol: "music.mic", raw: gzMusique),
    RawTheme(id: "gz.style", name: "Mode & sneakers", symbol: "bag.fill", raw: gzStyle),
    RawTheme(id: "gz.food", name: "Food tendance", symbol: "takeoutbag.and.cup.and.straw.fill", raw: gzFood),
    RawTheme(id: "gz.sport", name: "Foot & sport", symbol: "sportscourt.fill", raw: gzSport),
    RawTheme(id: "gz.vie", name: "Argot & vie étudiante", symbol: "bubble.left.and.bubble.right.fill", raw: gzVie),
    RawTheme(id: "gz.tech", name: "Tech & gadgets", symbol: "airpodspro", raw: gzTech),
    RawTheme(id: "gz.memes", name: "Mèmes & internet", symbol: "face.smiling.fill", raw: gzMemes),
    RawTheme(id: "gz.lifestyle", name: "Lifestyle & sorties", symbol: "airplane", raw: gzLifestyle)
]

// MARK: - Bibliothèque

enum WordLibrary {
    private static let grandPublic = build(grandPublicThemes)
    private static let genZ = build(genZThemes)

    static func themes(for catalog: WordCatalog) -> [WordTheme] {
        switch catalog {
        case .mainstream: grandPublic.themes
        case .genZ: genZ.themes
        }
    }

    static func pairs(for catalog: WordCatalog) -> [WordPair] {
        switch catalog {
        case .mainstream: grandPublic.pairs
        case .genZ: genZ.pairs
        }
    }

    /// Paires jouables : thème actif et aucun des deux mots déjà utilisé.
    static func availablePairs(
        catalog: WordCatalog,
        excludedThemes: Set<String>,
        usedKeys: Set<String>
    ) -> [WordPair] {
        pairs(for: catalog).filter { pair in
            !excludedThemes.contains(pair.themeID)
                && !usedKeys.contains(pair.keyA)
                && !usedKeys.contains(pair.keyB)
        }
    }

    /// Garde-fou en debug : chaque liste doit contenir au moins 500 paires.
    static func validate() {
        #if DEBUG
        for catalog in WordCatalog.allCases {
            assert(pairs(for: catalog).count >= 500, "La liste \(catalog.title) contient moins de 500 paires.")
        }
        #endif
    }

    // MARK: Parsing

    private static func build(_ raws: [RawTheme]) -> (themes: [WordTheme], pairs: [WordPair]) {
        var themes: [WordTheme] = []
        var pairs: [WordPair] = []
        for raw in raws {
            let parsed = parse(raw.raw, themeID: raw.id)
            themes.append(WordTheme(id: raw.id, name: raw.name, symbol: raw.symbol, pairCount: parsed.count))
            pairs += parsed
        }
        return (themes, pairs)
    }

    private static func parse(_ raw: String, themeID: String) -> [WordPair] {
        raw.split(whereSeparator: \.isNewline)
            .flatMap { $0.split(separator: ";") }
            .compactMap { chunk -> WordPair? in
                let parts = chunk
                    .split(separator: "|", omittingEmptySubsequences: false)
                    .map { $0.trimmingCharacters(in: .whitespaces) }
                guard parts.count == 2, !parts[0].isEmpty, !parts[1].isEmpty else { return nil }
                return WordPair(a: parts[0], b: parts[1], themeID: themeID)
            }
    }
}
