//
//  SplashScreenView.swift
//  BorcDefterim
//
//  Created by Murat Toraman on 13.10.2026.
//

import SwiftUI
import SwiftData

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0.5
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                // Gradient arkaplan
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.2, green: 0.4, blue: 0.8),
                        Color(red: 0.1, green: 0.2, blue: 0.5)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // App İkonu - Assets'ten
                    Image("SplashIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 26.6))
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .scaleEffect(scale)
                        .opacity(opacity)
                    
                    // App İsmi
                    Text("Borç Defterim")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .opacity(opacity)
                    
                    Text("Borçlarını kolayca takip et")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                        .opacity(opacity)
                }
            }
            .onAppear {
                // Animasyonlar
                withAnimation(.easeIn(duration: 1.0)) {
                    scale = 1.0
                    opacity = 1.0
                }
                
                // 2 saniye sonra ana ekrana geç
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
        .modelContainer(for: Debt.self)
}
