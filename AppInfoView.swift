//
//  AppInfoView.swift
//  BorcDefterim
//
//  Created by Murat Toraman on 13.10.2026.
//

import SwiftUI

struct AppInfoView: View {
    var body: some View {
        List {
            Section("Uygulama Bilgileri") {
                if let bundleID = Bundle.main.bundleIdentifier {
                    LabeledContent("Bundle ID", value: bundleID)
                }
                
                if let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String {
                    LabeledContent("App Name", value: appName)
                }
                
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    LabeledContent("Version", value: version)
                }
            }
            
            Section("Veri Konumu") {
                let storeURL = URL.applicationSupportDirectory.appending(path: "default.store")
                
                Text(storeURL.path)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Button("Yolu Kopyala") {
                    UIPasteboard.general.string = storeURL.path
                }
            }
        }
        .navigationTitle("Uygulama Bilgileri")
    }
}

#Preview {
    NavigationStack {
        AppInfoView()
    }
}
