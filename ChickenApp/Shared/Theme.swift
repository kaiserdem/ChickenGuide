import SwiftUI

struct Theme {
    struct Palette {
        // Dark backgrounds from the design
        static let primaryDark = Color(hex: "#2D1B3D") // Dark purple-red background
        static let secondaryDark = Color(hex: "#1A0F26") // Even darker background
        
        // Vibrant colors from the design
        static let vibrantOrange = Color(hex: "#FF6B35") // Bright orange from buttons
        static let vibrantGreen = Color(hex: "#4ECDC4") // Bright green from buttons
        static let vibrantPurple = Color(hex: "#9B59B6") // Purple from buttons
        static let vibrantBlue = Color(hex: "#3498DB") // Light blue from buttons
        
        // Gold/yellow accents
        static let goldAccent = Color(hex: "#F39C12") // Gold from eggs and text
        static let brightYellow = Color(hex: "#F1C40F") // Bright yellow
        
        // Red accents
        static let brightRed = Color(hex: "#E74C3C") // Bright red
        static let darkRed = Color(hex: "#C0392B") // Darker red
        
        // Text colors
        static let white = Color.white
        static let black = Color.black
        static let darkGray = Color(hex: "#2C3E50")
        static let lightGray = Color(hex: "#ECF0F1")
        
        // Additional colors
        static let successGreen = Color(hex: "#27AE60")
        static let warningOrange = Color(hex: "#F39C12")
        static let errorRed = Color(hex: "#E74C3C")
    }
    
    struct Gradients {
        // Main background gradient (dark purple-red)
        static let primary = LinearGradient(
            colors: [Palette.primaryDark, Palette.secondaryDark],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Vibrant gradient for buttons
        static let vibrant = LinearGradient(
            colors: [Palette.vibrantOrange, Palette.brightRed],
            startPoint: .leading,
            endPoint: .trailing
        )
        
        // Card gradient
        static let card = LinearGradient(
            colors: [Palette.vibrantPurple.opacity(0.8), Palette.vibrantBlue.opacity(0.6)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Soft gradient for backgrounds
        static let soft = LinearGradient(
            colors: [Palette.primaryDark.opacity(0.9), Palette.secondaryDark.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Button gradient
        static let button = LinearGradient(
            colors: [Palette.vibrantOrange, Palette.goldAccent],
            startPoint: .top,
            endPoint: .bottom
        )
        
        // Tab bar gradient
        static let tabBar = LinearGradient(
            colors: [Palette.primaryDark, Palette.vibrantPurple, Palette.brightRed],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Quiz gradient
        static let quiz = LinearGradient(
            colors: [Palette.vibrantGreen, Palette.vibrantBlue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Facts gradient
        static let facts = LinearGradient(
            colors: [Palette.vibrantPurple, Palette.vibrantBlue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Gallery gradient
        static let gallery = LinearGradient(
            colors: [Palette.vibrantBlue, Palette.vibrantGreen],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    struct Shadows {
        static let light = Color.black.opacity(0.1)
        static let medium = Color.black.opacity(0.2)
        static let heavy = Color.black.opacity(0.3)
        static let glow = Color.white.opacity(0.1)
    }
    
    struct Opacity {
        static let cardBackground = 0.15
        static let textSecondary = 0.8
        static let textTertiary = 0.6
        static let overlay = 0.1
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
