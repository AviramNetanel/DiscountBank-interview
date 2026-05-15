//
//  Account.swift
//  DiscountBank-interview
//

import Foundation


struct Account: Identifiable, Hashable, Sendable {
  let id: UUID
  var name: String
  var maskedNumber: String
  var balance: Decimal

  var displayTitle: String {
    "\(name) · \(maskedNumber)"
  }
}
