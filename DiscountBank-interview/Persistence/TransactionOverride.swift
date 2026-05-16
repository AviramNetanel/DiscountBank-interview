//
//  TransactionOverride.swift
//  DiscountBank-interview
//

import Foundation
import SwiftData

@Model
final class TransactionOverride {
  @Attribute(.unique) var transactionId: UUID
  var title: String
  var categoryRaw: String
  var sender: String
  var receiver: String
  var date: Date

  init(transaction: Transaction) {
    transactionId = transaction.id
    title = transaction.title
    categoryRaw = transaction.category.rawValue
    sender = transaction.sender
    receiver = transaction.receiver
    date = transaction.date
  }

  func update(from transaction: Transaction) {
    title = transaction.title
    categoryRaw = transaction.category.rawValue
    sender = transaction.sender
    receiver = transaction.receiver
    date = transaction.date
  }
}
