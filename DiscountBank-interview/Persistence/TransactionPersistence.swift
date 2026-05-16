//
//  TransactionPersistence.swift
//  DiscountBank-interview
//

import Foundation
import SwiftData

@MainActor
final class TransactionPersistence {
  private let modelContext: ModelContext

  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }

  func applyOverrides(to transactions: [Transaction]) -> [Transaction] {
    let overrides = fetchAllOverrides()
    guard !overrides.isEmpty else { return transactions }

    let overridesById = Dictionary(uniqueKeysWithValues: overrides.map { ($0.transactionId, $0) })

    return transactions.map { transaction in
      guard let override = overridesById[transaction.id] else { return transaction }
      return merge(override, into: transaction)
    }
  }

  func saveOverride(for transaction: Transaction) {
    let transactionId = transaction.id
    var descriptor = FetchDescriptor<TransactionOverride>(
      predicate: #Predicate { $0.transactionId == transactionId }
    )
    descriptor.fetchLimit = 1

    if let existing = try? modelContext.fetch(descriptor).first {
      existing.update(from: transaction)
    } else {
      modelContext.insert(TransactionOverride(transaction: transaction))
    }

    try? modelContext.save()
  }

  private func fetchAllOverrides() -> [TransactionOverride] {
    (try? modelContext.fetch(FetchDescriptor<TransactionOverride>())) ?? []
  }

  private func merge(_ override: TransactionOverride, into transaction: Transaction) -> Transaction {
    var merged = transaction
    merged.title = override.title
    merged.category = TransactionCategory(rawValue: override.categoryRaw) ?? transaction.category
    merged.sender = override.sender
    merged.receiver = override.receiver
    merged.date = override.date
    return merged
  }
}
