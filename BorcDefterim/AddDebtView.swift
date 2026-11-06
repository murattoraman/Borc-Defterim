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
    @FocusState private var isAmountFocused: Bool
    
    let selectedMonth: Date
    let debtToEdit: Debt? // Düzenlenecek borç
    
    // Formatlanmış tutar gösterimi
    private var formattedAmount: String {
        // Eğer kullanıcı yazıyorsa, ham veriyi göster
        if isAmountFocused {
            return amount
        }
        
        // Eğer geçerli bir sayı varsa, formatla
        guard let value = cleanedAmountValue, value > 0 else {
            return amount
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        
        return formatter.string(from: NSNumber(value: value)) ?? amount
    }
    
    // Temizlenmiş sayısal değer
    private var cleanedAmountValue: Double? {
        let cleaned = amount
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: ",", with: ".")
        return Double(cleaned)
    }
    
    // Düzenleme modunda mı?
    private var isEditMode: Bool {
        debtToEdit != nil
    }
    
    // Yeni borç eklemek için initializer
    init(selectedMonth: Date) {
        self.selectedMonth = selectedMonth
        self.debtToEdit = nil
    }
    
    // Borç düzenlemek için initializer
    init(debt: Debt, selectedMonth: Date) {
        self.selectedMonth = selectedMonth
        self.debtToEdit = debt
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Borç Bilgileri") {
                    TextField("Borç Adı", text: $debtName)
                    
                    HStack {
                        TextField("Tutar", text: $amount)
                            .keyboardType(.decimalPad)
                            .focused($isAmountFocused)
                            .onChange(of: isAmountFocused) { oldValue, newValue in
                                if !newValue {
                                    // Focus kaybolduğunda formatla
                                    formatAmount()
                                }
                            }
                        
                        Text("₺")
                            .foregroundStyle(.secondary)
                    }
                    
                    DatePicker("Ödeme Tarihi", selection: $dueDate, displayedComponents: .date)
                }
                
                Section("Notlar (Opsiyonel)") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle(isEditMode ? "Borç Düzenle" : "Yeni Borç Ekle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditMode ? "Güncelle" : "Kaydet") {
                        saveDebt()
                    }
                    .disabled(!isValidInput)
                }
            }
            .onAppear {
                if let debt = debtToEdit {
                    // Düzenleme modunda mevcut verileri yükle ve formatla
                    debtName = debt.name
                    amount = formatNumber(debt.amount)
                    dueDate = debt.dueDate
                    notes = debt.notes
                } else {
                    // Yeni borç eklerken seçili aya göre varsayılan tarihi ayarla
                    dueDate = selectedMonth
                }
            }
        }
    }
    
    private var isValidInput: Bool {
        !debtName.isEmpty && !amount.isEmpty && cleanedAmountValue != nil
    }
    
    // Sayıyı formatla
    private func formatNumber(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = "."
        formatter.decimalSeparator = ","
        
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
    
    // Tutar formatla
    private func formatAmount() {
        if let value = cleanedAmountValue, value > 0 {
            amount = formatNumber(value)
        }
    }
    
    private func saveDebt() {
        guard let amountValue = cleanedAmountValue else { return }
        
        if let debt = debtToEdit {
            // Mevcut borcu güncelle
            debt.name = debtName
            debt.amount = amountValue
            debt.dueDate = dueDate
            debt.notes = notes
        } else {
            // Yeni borç ekle
            let newDebt = Debt(
                name: debtName,
                amount: amountValue,
                dueDate: dueDate,
                notes: notes
            )
            modelContext.insert(newDebt)
        }
        
        dismiss()
    }
}


#Preview("Yeni Borç") {
    AddDebtView(selectedMonth: Date())
        .modelContainer(for: Debt.self)
}

#Preview("Borç Düzenle") {
    let debt = Debt(
        name: "Elektrik Faturası",
        amount: 104000.50,
        dueDate: Date(),
        notes: "Son ödeme tarihi yaklaşıyor"
    )
    return AddDebtView(debt: debt, selectedMonth: Date())
        .modelContainer(for: Debt.self)
}

