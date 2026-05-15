//
//  BankStore.swift
//  DiscountBank-interview
//

import Foundation
import Observation

@Observable
final class BankStore {
  private(set) var user: BankUser
  private(set) var accounts: [Account]
  private(set) var transactions: [Transaction]
  /// `nil` means all accounts are selected.
  var selectedAccountId: UUID?
  var activityPeriodFilter: TransactionPeriodFilter = .oneMonth

  init(
    user: BankUser = MockBankRepository.sampleUser,
    accounts: [Account] = MockBankRepository.sampleAccounts,
    transactions: [Transaction] = MockBankRepository.sampleTransactions,
    selectedAccountId: UUID? = nil,
    activityPeriodFilter: TransactionPeriodFilter = .oneMonth
  ) {
    self.user = user
    self.accounts = accounts
    self.transactions = transactions
    self.selectedAccountId = selectedAccountId
    self.activityPeriodFilter = activityPeriodFilter
  }

  var selectedAccount: Account? {
    guard let selectedAccountId else { return nil }
    return account(id: selectedAccountId)
  }

  var selectedAccountLabel: String {
    selectedAccount?.name ?? "All accounts"
  }

  func selectAccount(_ account: Account?) {
    selectedAccountId = account?.id
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

  func transactions(forAccountId accountId: UUID) -> [Transaction] {
    transactions
      .filter { $0.accountId == accountId }
      .sorted { $0.date > $1.date }
  }

  func accountName(for transaction: Transaction) -> String {
    account(id: transaction.accountId)?.name ?? "Account"
  }
}
