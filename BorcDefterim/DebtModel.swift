//
//  DebtModel.swift
//  BorcDefterim
//
//  Created by Murat Toraman on 13.10.2026.
//

import Foundation
import SwiftData

@Model
final class Debt {
    var id: UUID
    var name: String
    var amount: Double
    var dueDate: Date
    var isPaid: Bool
    var notes: String
    
    init(name: String, amount: Double, dueDate: Date, notes: String = "", isPaid: Bool = false) {
        self.id = UUID()
        self.name = name
        self.amount = amount
        self.dueDate = dueDate
        self.notes = notes
        self.isPaid = isPaid
    }
    
    // Ay ve yıl için yardımcı özellikler
    var month: Int {
        Calendar.current.component(.month, from: dueDate)
    }
    
    var year: Int {
        Calendar.current.component(.year, from: dueDate)
    }
}
