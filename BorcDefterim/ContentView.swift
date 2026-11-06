//
//  ContentView.swift
//  BorcDefterim
//
//  Created by Murat Toraman on 13.10.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Debt.dueDate) private var allDebts: [Debt]
    
    @State private var selectedMonth = Date()
    @State private var showingAddDebt = false
    @State private var debtToEdit: Debt?
    
    // Seçili aya göre filtrelenmiş borçlar
    private var filteredDebts: [Debt] {
        let calendar = Calendar.current
        let selectedMonthValue = calendar.component(.month, from: selectedMonth)
        let selectedYearValue = calendar.component(.year, from: selectedMonth)
        
        return allDebts.filter { debt in
            debt.month == selectedMonthValue && debt.year == selectedYearValue
        }
    }
    
    // İstatistikler
    private var totalAmount: Double {
        filteredDebts.reduce(0) { $0 + $1.amount }
    }
    
    private var paidAmount: Double {
        filteredDebts.filter { $0.isPaid }.reduce(0) { $0 + $1.amount }
    }
    
    private var unpaidAmount: Double {
        totalAmount - paidAmount
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Ay Seçici
                monthPickerSection
                
                // İstatistikler
                if !filteredDebts.isEmpty {
                    statisticsSection
                        .padding()
                        .background(Color(.secondarySystemBackground))
                }
                
                // Borç Listesi
                if filteredDebts.isEmpty {
                    emptyStateView
                } else {
                    debtListView
                }
            }
            .navigationTitle("Borç Yönetimi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddDebt = true
                    } label: {
                        Label("Borç Ekle", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddDebt) {
                AddDebtView(selectedMonth: selectedMonth)
            }
            .sheet(item: $debtToEdit) { debt in
                AddDebtView(debt: debt, selectedMonth: selectedMonth)
            }
        }
    }
    
    // MARK: - Alt Görünümler
    
    private var monthPickerSection: some View {
        HStack {
            Button {
                changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text(selectedMonth, format: .dateTime.month(.wide))
                    .font(.title2.bold())
                Text(selectedMonth, format: .dateTime.year())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
    
    private var statisticsSection: some View {
        HStack(spacing: 20) {
            StatisticCard(
                title: "Toplam",
                amount: totalAmount,
                color: .blue
            )
            
            StatisticCard(
                title: "Ödendi",
                amount: paidAmount,
                color: .green
            )
            
            StatisticCard(
                title: "Kalan",
                amount: unpaidAmount,
                color: .orange
            )
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundStyle(.secondary)
            
            Text("Henüz Borç Yok")
                .font(.title2.bold())
            
            Text("Bu ay için borç eklemek için '+' butonuna tıklayın")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var debtListView: some View {
        List {
            ForEach(filteredDebts, id: \.id) { debt in
                DebtRowView(debt: debt) {
                    toggleDebtPaid(debt)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    debtToEdit = debt
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        deleteDebt(debt)
                    } label: {
                        Label("Sil", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        debtToEdit = debt
                    } label: {
                        Label("Düzenle", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
        }
        .listStyle(.plain)
    }
    
    // MARK: - Fonksiyonlar
    
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: selectedMonth) {
            selectedMonth = newDate
        }
    }
    
    private func toggleDebtPaid(_ debt: Debt) {
        withAnimation {
            debt.isPaid.toggle()
        }
    }
    
    private func deleteDebt(_ debt: Debt) {
        withAnimation {
            modelContext.delete(debt)
        }
    }
}

// MARK: - İstatistik Kartı

struct StatisticCard: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(amount, format: .currency(code: "TRY"))
                .font(.headline)
                .foregroundStyle(color)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Debt.self)
}
