//
//  BankStore.swift
//  DiscountBank-interview
//

import Foundation
import Observation

@Observable
final class BankStore {
  private let repository: any BankRepository
  private let persistence: TransactionPersistence?

  private(set) var user: BankUser
  private(set) var accounts: [Account]
  private(set) var transactions: [Transaction]
  /// `nil` means all accounts are selected.
  var selectedAccountId: UUID?
  var activityPeriodFilter: TransactionPeriodFilter = .oneMonth

  //MARK: -
  init(
    repository: any BankRepository = MockBankRepository.shared,
    persistence: TransactionPersistence? = nil,
    user: BankUser = BankUser(firstName: "", lastName: ""),
    accounts: [Account] = [],
    transactions: [Transaction] = [],
    selectedAccountId: UUID? = nil,
    activityPeriodFilter: TransactionPeriodFilter = .oneMonth
  ) {
    self.repository = repository
    self.persistence = persistence
    self.user = user
    self.accounts = accounts
    self.transactions = transactions
    self.selectedAccountId = selectedAccountId
    self.activityPeriodFilter = activityPeriodFilter
  }
  
  //MARK: - Computed properties
  var selectedAccount: Account? {
    guard let selectedAccountId else { return nil }
    return account(id: selectedAccountId)
  }

  var selectedAccountLabel: String {
    selectedAccount?.name ?? "All accounts"
  }
  
  var totalBalance: Decimal {
    accounts.reduce(0) { $0 + $1.balance }
  }

  var displayedBalance: Decimal {
    selectedAccount?.balance ?? totalBalance
  }

  var balanceCardTitle: String {
    selectedAccount == nil ? "Total balance" : "Balance"
  }

  //MARK: -
  func selectAccount(_ account: Account?) {
    selectedAccountId = account?.id
  }

  func account(id: UUID) -> Account? {
    accounts.first { $0.id == id }
  }

  func recentTransactions(limit: Int? = nil, now: Date = Date()) -> [Transaction] {
    var list = transactions
    if let selectedAccountId {
      list = list.filter { $0.accountId == selectedAccountId }
    }
    list = list.filter { activityPeriodFilter.includes(date: $0.date, relativeTo: now) }
    let sorted = list.sorted { $0.date > $1.date }
    guard let limit else { return sorted }
    return Array(sorted.prefix(limit))
  }

  func accountName(for transaction: Transaction) -> String {
    account(id: transaction.accountId)?.name ?? "Account"
  }

  func updateTransaction(_ transaction: Transaction) {
    guard let index = transactions.firstIndex(where: { $0.id == transaction.id }) else {
      return
    }
    transactions[index] = transaction
    persistence?.saveOverride(for: transaction)
  }

  /// Loads demo accounts and transactions via the configured `BankRepository`.
  func loadDemoData(signInUsername: String) {
    let session = repository.fetchDemoSession(signInUsername: signInUsername)
    user = session.user
    accounts = session.accounts
    transactions = persistence?.applyOverrides(to: session.transactions) ?? session.transactions
    selectedAccountId = nil
    activityPeriodFilter = .oneMonth
  }

  /// Clears in-memory session state. Local transaction overrides are kept on disk.
  func clearSession() {
    user = BankUser(firstName: "", lastName: "")
    accounts = []
    transactions = []
    selectedAccountId = nil
    activityPeriodFilter = .oneMonth
  }
}

extension BankStore {
  /// Populated with mock data for SwiftUI previews.
  static var preview: BankStore {
    let store = BankStore()
    store.loadDemoData(signInUsername: "Aviram")
    return store
  }
}
