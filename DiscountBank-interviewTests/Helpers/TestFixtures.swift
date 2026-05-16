//
//  TestFixtures.swift
//  DiscountBank-interviewTests
//

import Foundation
@testable import DiscountBank_interview

enum TestFixtures {
  static let fixedCalendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    return calendar
  }()

  static let fixedNow: Date = {
    var components = DateComponents()
    components.calendar = fixedCalendar
    components.timeZone = fixedCalendar.timeZone
    components.year = 2026
    components.month = 5
    components.day = 17
    components.hour = 12
    components.minute = 0
    components.second = 0
    return fixedCalendar.date(from: components)!
  }()

  static let checkingAccountId = UUID(uuidString: "C1000001-0000-4000-8000-000000000001")!
  static let savingsAccountId = UUID(uuidString: "C1000002-0000-4000-8000-000000000002")!

  static let transactionAId = UUID(uuidString: "D1000001-0000-4000-8000-000000000001")!
  static let transactionBId = UUID(uuidString: "D1000002-0000-4000-8000-000000000002")!
  static let transactionCId = UUID(uuidString: "D1000003-0000-4000-8000-000000000003")!

  static let fixedLocale = Locale(identifier: "en_US_POSIX")

  static func makeAccount(
    id: UUID = checkingAccountId,
    name: String = "234 4521",
    balance: Decimal = 1000
  ) -> Account {
    Account(id: id, name: name, maskedNumber: "•••• 4521", balance: balance)
  }

  static func makeTransaction(
    id: UUID = transactionAId,
    accountId: UUID = checkingAccountId,
    title: String = "Test",
    date: Date = fixedNow,
    amount: Decimal = -10
  ) -> Transaction {
    Transaction(
      id: id,
      accountId: accountId,
      title: title,
      category: .dining,
      sender: "Sender",
      receiver: "Receiver",
      amount: amount,
      date: date,
      systemImage: "cart.fill"
    )
  }

  @MainActor
  static func makeBankStore(
    transactions: [Transaction] = [],
    accounts: [Account] = [],
    filter: TransactionPeriodFilter = .max,
    selectedAccountId: UUID? = nil
  ) -> BankStore {
    BankStore(
      accounts: accounts,
      transactions: transactions,
      selectedAccountId: selectedAccountId,
      activityPeriodFilter: filter
    )
  }

  static func date(
    byAdding component: Calendar.Component,
    value: Int,
    to date: Date = fixedNow
  ) -> Date {
    fixedCalendar.date(byAdding: component, value: value, to: date)!
  }
}
