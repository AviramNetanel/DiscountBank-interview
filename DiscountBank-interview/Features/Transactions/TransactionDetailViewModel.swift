//
//  TransactionDetailViewModel.swift
//  DiscountBank-interview
//

import Foundation
import Observation

@Observable
final class TransactionDetailViewModel {
  let accountName: String

  var isEditing = false
  var draft = TransactionDraft.empty

  private let transactionID: UUID
  private let initialTransaction: Transaction
  private let bankStore: BankStore

  var displayTransaction: Transaction {
    bankStore.transactions.first { $0.id == transactionID } ?? initialTransaction
  }

  var transactionIDText: String {
    transactionID.uuidString
  }

  var activeCategory: TransactionCategory {
    isEditing ? draft.category : displayTransaction.category
  }

  init(transaction: Transaction, accountName: String, bankStore: BankStore) {
    self.initialTransaction = transaction
    self.transactionID = transaction.id
    self.accountName = accountName
    self.bankStore = bankStore
  }

  func beginEditing() {
    draft = TransactionDraft(transaction: displayTransaction)
    isEditing = true
  }

  func saveEdits() {
    var updated = displayTransaction
    updated.title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
    updated.category = draft.category
    updated.sender = draft.sender.trimmingCharacters(in: .whitespacesAndNewlines)
    updated.receiver = draft.receiver.trimmingCharacters(in: .whitespacesAndNewlines)
    updated.date = draft.date

    bankStore.updateTransaction(updated)
    isEditing = false
  }

  func selectCategory(_ category: TransactionCategory) {
    draft.category = category
  }

  func toolbarPrimaryTapped() {
    if isEditing {
      saveEdits()
    } else {
      beginEditing()
    }
  }
}

// MARK: - Edit draft

struct TransactionDraft {
  var title: String
  var category: TransactionCategory
  var sender: String
  var receiver: String
  var date: Date

  static let empty = TransactionDraft()

  init(
    title: String = "",
    category: TransactionCategory = .dining,
    sender: String = "",
    receiver: String = "",
    date: Date = .now
  ) {
    self.title = title
    self.category = category
    self.sender = sender
    self.receiver = receiver
    self.date = date
  }

  init(transaction: Transaction) {
    self.init(
      title: transaction.title,
      category: transaction.category,
      sender: transaction.sender,
      receiver: transaction.receiver,
      date: transaction.date
    )
  }
}
