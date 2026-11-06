//
//  BorcDefterimApp.swift
//  BorcDefterim
//
//  Created by Murat Toraman on 13.10.2026.
//

import SwiftUI
import SwiftData

@main
struct BorcDefterimApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .modelContainer(for: Debt.self)
    }
}
