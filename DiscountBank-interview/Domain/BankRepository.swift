//
//  BankRepository.swift
//  DiscountBank-interview
//

import Foundation

/// Signed-in user data loaded from a data source (mock, API, etc.).
struct BankSession: Sendable {
  let user: BankUser
  let accounts: [Account]
  let transactions: [Transaction]
}

/// Abstraction over bank data access. Swap implementations for demo vs production.
protocol BankRepository: Sendable {
  func fetchDemoSession(signInUsername: String) -> BankSession
}
