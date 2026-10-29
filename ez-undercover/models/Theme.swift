import SwiftUI
import UIKit

// MARK: - Couleurs

extension Color {
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }

    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }

    static let pastelPink = Color(light: Color(hex: 0xFFE1E6), dark: Color(hex: 0x3A2329))
    static let pastelPeach = Color(light: Color(hex: 0xFFE8D6), dark: Color(hex: 0x3B2B22))
    static let pastelLavender = Color(light: Color(hex: 0xE8E1FF), dark: Color(hex: 0x2A2540))
    static let pastelMint = Color(light: Color(hex: 0xD9F5E6), dark: Color(hex: 0x1F3A2E))
    static let pastelSky = Color(light: Color(hex: 0xDDEEFF), dark: Color(hex: 0x1F2F42))
    static let pastelCream = Color(light: Color(hex: 0xFFF8EA), dark: Color(hex: 0x2B2822))
}

enum Theme {
    /// Accent rouge de l'app
    static let accent = Color(light: Color(hex: 0xE5484D), dark: Color(hex: 0xFF6B6F))
}

// MARK: - Fond pastel

struct PastelBackground: View {
    var body: some View {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                [0, 0], [0.5, 0], [1, 0],
                [0, 0.5], [0.6, 0.42], [1, 0.5],
                [0, 1], [0.5, 1], [1, 1]
            ],
            colors: [
                .pastelPink, .pastelCream, .pastelPeach,
                .pastelLavender, .pastelCream, .pastelPink,
                .pastelSky, .pastelMint, .pastelLavender
            ]
        )
        .ignoresSafeArea()
    }
}

// MARK: - Helpers de vue

extension View {
    func pastelBackground() -> some View {
        background { PastelBackground() }
    }

    /// Carte en Liquid Glass.
    func glassCard(cornerRadius: CGFloat = 28, tint: Color? = nil) -> some View {
        padding(24)
            .glassEffect(
                tint.map { Glass.regular.tint($0) } ?? Glass.regular,
                in: .rect(cornerRadius: cornerRadius)
            )
    }
}
