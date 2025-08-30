//
//  SplashView.swift
//  Task5
//
//  Created by Cassper on 30/08/2025.
//

import SwiftUI

/// Brand colors – tweak to your taste
private enum Brand {
    static let blue = Color(red: 0.01, green: 0.47, blue: 0.71)
    static let teal = Color(red: 0.01, green: 0.62, blue: 0.76)
    static let dark = Color(red: 0.03, green: 0.11, blue: 0.18)
}

/// Full-screen splash with animated background, logo pop & fade
struct SplashView: View {
    @Binding var isActive: Bool

    @State private var logoScale: CGFloat = 0.92
    @State private var logoOpacity: Double = 1.0
    @State private var glowOpacity: Double = 0.0
    @State private var burst = false

    var body: some View {
        ZStack {
            // Gradient background + soft animated bokeh
            AnimatedBackground()

            // Brand squares hint (subtle)
            CornerTiles()
                .opacity(0.18)
                .blur(radius: 2)

            // Logo + glow + particle burst
            ZStack {
                Circle()
                    .fill(.white.opacity(0.12))
                    .blur(radius: 24)
                    .scaleEffect(logoScale * 1.15)
                    .opacity(glowOpacity)

                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 132, height: 132)
                    .scaleEffect(logoScale)
                    .shadow(color: .black.opacity(0.25), radius: 14, y: 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28, style: .continuous)
                            .stroke(.white.opacity(0.18), lineWidth: 1)
                            .padding(4)
                            .blur(radius: 2)
                            .blendMode(.screen)
                    )
                    .opacity(logoOpacity)

                ParticleBurst(activate: burst)
                    .allowsHitTesting(false)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // 1) Soft glow
            withAnimation(.easeIn(duration: 0.5)) { glowOpacity = 1 }

            // 2) Pop, then fade
            withAnimation(.spring(response: 0.6, dampingFraction: 0.85, blendDuration: 0.2)) {
                logoScale = 1.06
            }
            // small settle
            withAnimation(.easeOut(duration: 0.35).delay(0.55)) { logoScale = 1.0 }

            // 3) Burst & fade out
            withAnimation(.easeOut(duration: 0.8).delay(0.65)) {
                burst = true
                logoOpacity = 0
                glowOpacity = 0
            }

            // 4) Dismiss splash
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    isActive = false
                }
            }
        }
    }
}

private struct AnimatedBackground: View {
    @State private var shift: CGFloat = 0
    var body: some View {
        ZStack {
            LinearGradient(colors: [Brand.dark, Brand.blue, Brand.teal],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .hueRotation(.degrees(shift))
                .overlay(
                    // soft bokeh blobs
                    ZStack {
                        ForEach(0..<6) { i in
                            Circle()
                                .fill(.white.opacity(0.10))
                                .frame(width: CGFloat(120 + i*20), height: CGFloat(120 + i*20))
                                .blur(radius: CGFloat(18 + i*3))
                                .offset(x: CGFloat((i%2==0 ? -1 : 1) * (40 + i*8)),
                                        y: CGFloat((i%3==0 ? -1 : 1) * (60 + i*10)))
                                .opacity(0.5 - Double(i) * 0.06)
                        }
                    }
                )
        }
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: true)) {
                shift = 12  // gentle color breathing
            }
        }
    }
}

// Subtle brand tile motif (echoes your icon’s squares)
private struct CornerTiles: View {
    var body: some View {
        GeometryReader { geo in
            let s = min(geo.size.width, geo.size.height)
            let tile: some View = RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(.white.opacity(0.25))

            ZStack {
                tile.frame(width: s*0.06, height: s*0.06)
                    .offset(x: -s*0.36, y: -s*0.36)
                tile.frame(width: s*0.04, height: s*0.04)
                    .offset(x: s*0.34, y: -s*0.34)
                tile.frame(width: s*0.05, height: s*0.05)
                    .offset(x: -s*0.33, y: s*0.33)
                tile.frame(width: s*0.03, height: s*0.03)
                    .offset(x: s*0.36, y: s*0.36)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

// Lightweight confetti burst – rectangles radiate & fade
private struct ParticleBurst: View {
    var activate: Bool
    private let count = 16
    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { i in
                let angle = Double(i) / Double(count) * 360.0
                let distance: CGFloat = 120
                Rectangle()
                    .fill(Color.white.opacity(0.9))
                    .frame(width: 6, height: 10)
                    .rotationEffect(.degrees(angle))
                    .offset(x: activate ? distance : 0)
                    .opacity(activate ? 0 : 1)
                    .scaleEffect(activate ? 0.6 : 1)
                    .animation(.easeOut(duration: 0.8).delay(Double(i) * 0.01), value: activate)
                    .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
            }
        }
        .blendMode(.screen)
    }
}
