//
//  HistoryView.swift
//  MyApp
//
//  Created by Hugo Derigny on 29/10/2026.
//


import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \UsedWord.date, order: .reverse) private var words: [UsedWord]
    @State private var catalogToReset: WordCatalog?

    var body: some View {
        List {
            ForEach(WordCatalog.allCases) { catalog in
                let items = words.filter { $0.catalogRaw == catalog.rawValue }
                Section {
                    if items.isEmpty {
                        Text("Aucun mot utilisé").foregroundStyle(.secondary)
                    }
                    ForEach(items) { item in
                        LabeledContent(item.word) {
                            Text(item.date, format: .dateTime.day().month())
                        }
                    }
                    .onDelete { offsets in
                        for index in offsets { context.delete(items[index]) }
                    }
                    if !items.isEmpty {
                        Button("Réinitialiser cette liste", role: .destructive) {
                            catalogToReset = catalog
                        }
                    }
                } header: {
                    Text("\(catalog.title) · \(items.count) mot\(items.count > 1 ? "s" : "")")
                } footer: {
                    if catalog == WordCatalog.allCases.last {
                        Text("Ces mots ne seront plus tirés tant que tu ne réinitialises pas la liste.")
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .pastelBackground()
        .navigationTitle("Historique")
        .confirmationDialog(
            "Réinitialiser la liste ?",
            isPresented: Binding(
                get: { catalogToReset != nil },
                set: { if !$0 { catalogToReset = nil } }
            ),
            titleVisibility: .visible,
            presenting: catalogToReset
        ) { catalog in
            Button("Réinitialiser « \(catalog.title) »", role: .destructive) {
                reset(catalog)
            }
            Button("Annuler", role: .cancel) {}
        } message: { _ in
            Text("Ces mots pourront de nouveau être tirés.")
        }
    }

    private func reset(_ catalog: WordCatalog) {
        let raw = catalog.rawValue
        try? context.delete(model: UsedWord.self, where: #Predicate { $0.catalogRaw == raw })
        try? context.save()
    }
}