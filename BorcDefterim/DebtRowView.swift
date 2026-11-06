//
//  DebtRowView.swift
//  BorcDefterim
//
//  Created by Murat Toraman on 13.10.2026.
//

import SwiftUI

struct DebtRowView: View {
    let debt: Debt
    let onTogglePaid: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Ödeme durumu butonu
            Button(action: onTogglePaid) {
                Image(systemName: debt.isPaid ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(debt.isPaid ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(debt.name)
                    .font(.headline)
                    .strikethrough(debt.isPaid)
                
                HStack {
                    Image(systemName: "calendar")
                        .font(.caption)
                    Text(debt.dueDate, format: .dateTime.day().month().year())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                if !debt.notes.isEmpty {
                    Text(debt.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(debt.amount, format: .currency(code: "TRY"))
                    .font(.headline)
                    .foregroundStyle(debt.isPaid ? .secondary : .primary)
                
                if debt.isPaid {
                    Text("Ödendi")
                        .font(.caption)
                        .foregroundStyle(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.green.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        DebtRowView(debt: Debt(
            name: "Elektrik Faturası",
            amount: 450.50,
            dueDate: Date(),
            notes: "Son ödeme tarihi yaklaşıyor"
        )) {
            print("Toggled")
        }
        
        DebtRowView(debt: Debt(
            name: "İnternet Faturası",
            amount: 300.0,
            dueDate: Date(),
            notes: "",
            isPaid: true
        )) {
            print("Toggled")
        }
    }
}
