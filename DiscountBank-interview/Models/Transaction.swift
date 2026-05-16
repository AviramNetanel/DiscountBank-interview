//
//  Transaction.swift
//  DiscountBank-interview
//

import Foundation

struct Transaction: Identifiable, Hashable, Sendable {
  let id: UUID
  let accountId: UUID
  var title: String
  var category: TransactionCategory
  var sender: String
  var receiver: String
  var amount: Decimal
  var date: Date
  var systemImage: String

  var isCredit: Bool { amount > 0 }
  var isDebit: Bool { amount < 0 }

  func subtitle(accountName: String, locale: Locale = .current) -> String {
    let dateText = Transaction.dateFormatter(locale: locale).string(from: date)
    return "\(dateText) · \(accountName)"
  }

  func formattedDetailDate(locale: Locale = .current) -> String {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateStyle = .long
    formatter.timeStyle = .short
    return formatter.string(from: date)
  }

  func formattedAmount(currencyCode: String = "ILS", locale: Locale = .current) -> String {
    amount.formatted(
      .currency(code: currencyCode)
      .locale(locale)
      .precision(.fractionLength(2))
      .sign(strategy: .always(showZero: false))
    )
  }

  private static func dateFormatter(locale: Locale) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.locale = locale
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
  }
}
