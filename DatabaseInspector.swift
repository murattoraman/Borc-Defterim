//
//  DatabaseInspector.swift
//  BorcDefterim
//
//  Created by Murat Toraman on 13.10.2026.
//

import Foundation
import SwiftData

/// Veritabanındaki tüm tabloları ve içerikleri inceler
class DatabaseInspector {
    static func inspectDatabase() {
        let storeURL = URL.applicationSupportDirectory.appending(path: "default.store")
        
        print("🔍 ==========================================")
        print("🔍 VERİTABANI İNCELEMESİ")
        print("🔍 ==========================================")
        print("📁 Konum: \(storeURL.path)")
        print("📦 Dosya var mı: \(FileManager.default.fileExists(atPath: storeURL.path))")
        
        if let fileSize = try? FileManager.default.attributesOfItem(atPath: storeURL.path)[.size] as? Int64 {
            print("💾 Dosya boyutu: \(fileSize) bytes")
            
            if fileSize > 0 {
                print("✅ Veritabanı boş değil - veriler var!")
                print("")
                print("🔍 Olası model isimleri:")
                print("   - Item (standart SwiftUI template)")
                print("   - Debt (şimdiki modelimiz)")
                print("   - Expense, Payment, Bill vb.")
                print("")
                print("💡 İPUCU: Eski uygulamayı Xcode'da açıp @Model sınıfını bulun")
            } else {
                print("⚠️ Veritabanı dosyası boş")
            }
        }
        
        print("🔍 ==========================================")
    }
    
    /// Belirli bir model ismini test et
    static func testModelName(_ modelName: String, context: ModelContext) {
        print("🧪 Test ediliyor: \(modelName)")
        // Bu fonksiyonu farklı model isimleriyle deneyebiliriz
    }
}
