//
//  DataMigrationHelper.swift
//  BorcDefterim
//
//  Created by Murat Toraman on 13.10.2026.
//

import Foundation
import SwiftData

/// Veri migration yardımcı fonksiyonları
class DataMigrationHelper {
    static func checkAndMigrate(modelContext: ModelContext) {
        do {
            let existingDebts = try modelContext.fetch(FetchDescriptor<Debt>())
            print("🔄 Migration kontrolü: \(existingDebts.count) kayıt bulundu")
            
            if existingDebts.isEmpty {
                print("⚠️ Yeni modelde veri yok - eski model kontrolü gerekiyor")
            }
        } catch {
            print("❌ Migration hatası: \(error)")
        }
    }
}
