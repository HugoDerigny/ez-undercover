//
//  Avatar.swift
//  MyApp
//
//  Created by Hugo Derigny on 29/10/2026.
//

import SwiftUI
import PhotosUI
import UIKit

// MARK: - Traitement de la photo

enum PhotoProcessor {
    /// Recadre au carré et réduit l'image (≈ 20–40 Ko) pour garder une base légère.
    nonisolated static func avatarData(from data: Data, side: CGFloat = 320) -> Data? {
        guard let image = UIImage(data: data) else { return nil }
        let source = image.size
        guard source.width > 0, source.height > 0 else { return nil }

        let scale = side / min(source.width, source.height)
        let target = CGSize(width: source.width * scale, height: source.height * scale)

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: side, height: side), format: format)
        let rendered = renderer.image { _ in
            image.draw(in: CGRect(
                x: (side - target.width) / 2,
                y: (side - target.height) / 2,
                width: target.width,
                height: target.height
            ))
        }
        return rendered.jpegData(compressionQuality: 0.8)
    }
}

// MARK: - Avatar

struct AvatarView: View {
    let name: String
    var photoData: Data?
    var size: CGFloat = 40

    private static let palette: [Color] = [
        Color(light: Color(hex: 0xF6B9C4), dark: Color(hex: 0x6B3A45)),
        Color(light: Color(hex: 0xFAD2B0), dark: Color(hex: 0x6B4A32)),
        Color(light: Color(hex: 0xCFC3F5), dark: Color(hex: 0x453B73)),
        Color(light: Color(hex: 0xBFE8D2), dark: Color(hex: 0x2F5A47)),
        Color(light: Color(hex: 0xBBD9F5), dark: Color(hex: 0x2F4B6B))
    ]

    private var initials: String {
        name.split(separator: " ")
            .prefix(2)
            .compactMap(\.first)
            .map(String.init)
            .joined()
            .uppercased()
    }

    private var background: Color {
        // Déterministe (hashValue change à chaque lancement).
        let seed = name.normalizedKey.unicodeScalars.reduce(0) { $0 &+ Int($1.value) }
        return Self.palette[seed % Self.palette.count]
    }

    var body: some View {
        Group {
            if let photoData, let image = UIImage(data: photoData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    background
                    if initials.isEmpty {
                        Image(systemName: "person.fill")
                            .font(.system(size: size * 0.42))
                            .foregroundStyle(.secondary)
                    } else {
                        Text(initials)
                            .font(.system(size: size * 0.4, weight: .semibold, design: .rounded))
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(.circle)
        .overlay { Circle().strokeBorder(.primary.opacity(0.08), lineWidth: 1) }
        .accessibilityHidden(true)
    }
}

// MARK: - Sélecteur de photo

struct AvatarPicker: View {
    let name: String
    @Binding var photoData: Data?
    var size: CGFloat = 44

    @State private var showPicker = false
    @State private var item: PhotosPickerItem?

    var body: some View {
        Button {
            showPicker = true
        } label: {
            AvatarView(name: name, photoData: photoData, size: size)
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: photoData == nil ? "camera.fill" : "pencil")
                        .font(.system(size: max(size * 0.2, 8), weight: .bold))
                        .foregroundStyle(.white)
                        .padding(size * 0.1)
                        .background(Theme.accent, in: .circle)
                        .offset(x: size * 0.06, y: size * 0.06)
                }
        }
        .buttonStyle(.borderless)
        .photosPicker(isPresented: $showPicker, selection: $item, matching: .images)
        .contextMenu {
            if photoData != nil {
                Button("Retirer la photo", systemImage: "trash", role: .destructive) {
                    photoData = nil
                }
            }
        }
        .onChange(of: item) { _, newItem in
            guard let newItem else { return }
            Task { await load(newItem) }
        }
        .accessibilityLabel("Choisir une photo")
    }

    private func load(_ newItem: PhotosPickerItem) async {
        defer { item = nil }
        guard let raw = try? await newItem.loadTransferable(type: Data.self) else { return }
        let processed = await Task.detached(priority: .userInitiated) {
            PhotoProcessor.avatarData(from: raw)
        }.value
        if let processed { photoData = processed }
    }
}
