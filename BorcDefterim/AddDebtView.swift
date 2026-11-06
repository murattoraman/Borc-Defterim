//
//  AddDebtView.swift
//  BorcDefterim
//
//  Created by Murat Toraman on 13.10.2026.
//

import SwiftUI
import SwiftData

struct AddDebtView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var debtName = ""
    @State private var amount = ""
    @State private var dueDate = Date()
    @State private var notes = ""
    
    let selectedMonth: Date
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Borç Bilgileri") {
                    TextField("Borç Adı", text: $debtName)
                    
                    TextField("Tutar", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    DatePicker("Ödeme Tarihi", selection: $dueDate, displayedComponents: .date)
                }
                
                Section("Notlar (Opsiyonel)") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Yeni Borç Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Kaydet") {
                        saveDebt()
                    }
                    .disabled(!isValidInput)
                }
            }
            .onAppear {
                // Seçili aya göre varsayılan tarihi ayarla
                dueDate = selectedMonth
            }
        }
    }
    
    private var isValidInput: Bool {
        !debtName.isEmpty && !amount.isEmpty && Double(amount) != nil
    }
    
    private func saveDebt() {
        guard let amountValue = Double(amount) else { return }
        
        let newDebt = Debt(
            name: debtName,
            amount: amountValue,
            dueDate: dueDate,
            notes: notes
        )
        
        modelContext.insert(newDebt)
        dismiss()
    }
}

#Preview {
    AddDebtView(selectedMonth: Date())
        .modelContainer(for: Debt.self)
}
