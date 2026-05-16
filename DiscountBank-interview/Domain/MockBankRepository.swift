//
//  MockBankRepository.swift
//  DiscountBank-interview
//

import Foundation

/// In-memory demo data for interviews and SwiftUI previews.
struct MockBankRepository: BankRepository {
  static let shared = MockBankRepository()

  static let sampleUser = BankUser(firstName: "Aviram", lastName: "Netanel")

  private enum SampleID {
    static let checkingAccount = UUID(uuidString: "A1000001-0000-4000-8000-000000000001")!
    static let savingsAccount = UUID(uuidString: "A1000002-0000-4000-8000-000000000002")!

    static let salary = UUID(uuidString: "B1000001-0000-4000-8000-000000000001")!
    static let supermarket = UUID(uuidString: "B1000002-0000-4000-8000-000000000002")!
    static let coffee = UUID(uuidString: "B1000003-0000-4000-8000-000000000003")!
    static let transferIn = UUID(uuidString: "B1000004-0000-4000-8000-000000000004")!
    static let electric = UUID(uuidString: "B1000005-0000-4000-8000-000000000005")!
    static let atm = UUID(uuidString: "B1000006-0000-4000-8000-000000000006")!
    static let gym = UUID(uuidString: "B1000007-0000-4000-8000-000000000007")!
    static let restaurant = UUID(uuidString: "B1000008-0000-4000-8000-000000000008")!
    static let bonus = UUID(uuidString: "B1000009-0000-4000-8000-000000000009")!
    static let insurance = UUID(uuidString: "B100000A-0000-4000-8000-00000000000A")!
    static let savingsInterest = UUID(uuidString: "B100000B-0000-4000-8000-00000000000B")!
    static let phoneBill = UUID(uuidString: "B100000C-0000-4000-8000-00000000000C")!
    static let rent = UUID(uuidString: "B100000D-0000-4000-8000-00000000000D")!
    static let taxRefund = UUID(uuidString: "B100000E-0000-4000-8000-00000000000E")!
    static let holidayGift = UUID(uuidString: "B100000F-0000-4000-8000-00000000000F")!
    static let oldTransfer = UUID(uuidString: "B1000010-0000-4000-8000-000000000010")!
  }

  static let sampleAccounts: [Account] = [
    Account(
      id: SampleID.checkingAccount,
      name: "234 4521",
      maskedNumber: "•••• 4521",
      balance: 18_420.75
    ),
    Account(
      id: SampleID.savingsAccount,
      name: "234 8834",
      maskedNumber: "•••• 8834",
      balance: 42_150.00
    ),
  ]

  static var sampleTransactions: [Transaction] {
    let checking = sampleAccounts[0]
    let savings = sampleAccounts[1]
    let checkingId = checking.id
    let savingsId = savings.id
    let userName = sampleUser.fullName

    let calendar = Calendar.current
    let now = Date()

    func daysAgo(_ days: Int) -> Date {
      calendar.date(byAdding: .day, value: -days, to: now)!
    }

    func monthsAgo(_ months: Int, days: Int = 0) -> Date {
      let base = calendar.date(byAdding: .month, value: -months, to: now)!
      return calendar.date(byAdding: .day, value: -days, to: base)!
    }

    return [
      Transaction(
        id: SampleID.coffee,
        accountId: checkingId,
        title: "Coffee Shop",
        category: .dining,
        sender: userName,
        receiver: "Cafe Aroma TLV",
        amount: -18.50,
        date: calendar.date(byAdding: .hour, value: -6, to: now)!,
        systemImage: "cup.and.saucer.fill"
      ),
      Transaction(
        id: SampleID.supermarket,
        accountId: checkingId,
        title: "Supermarket",
        category: .groceries,
        sender: userName,
        receiver: "Shufersal",
        amount: -286.40,
        date: daysAgo(1),
        systemImage: "cart.fill"
      ),
      Transaction(
        id: SampleID.salary,
        accountId: checkingId,
        title: "Salary — Discount Ltd",
        category: .income,
        sender: "Discount Bank Ltd",
        receiver: userName,
        amount: 14_200,
        date: daysAgo(3),
        systemImage: "arrow.down.circle.fill"
      ),
      Transaction(
        id: SampleID.transferIn,
        accountId: savingsId,
        title: "Monthly transfer in",
        category: .transfer,
        sender: userName,
        receiver: userName,
        amount: 2_000,
        date: daysAgo(35),
        systemImage: "arrow.left.arrow.right.circle.fill"
      ),
      Transaction(
        id: SampleID.electric,
        accountId: checkingId,
        title: "Electric bill",
        category: .utilities,
        sender: userName,
        receiver: "Israel Electric Corp",
        amount: -412.90,
        date: daysAgo(37),
        systemImage: "bolt.fill"
      ),
      Transaction(
        id: SampleID.atm,
        accountId: checkingId,
        title: "ATM withdrawal",
        category: .cash,
        sender: userName,
        receiver: userName,
        amount: -500,
        date: daysAgo(60),
        systemImage: "banknote.fill"
      ),
      Transaction(
        id: SampleID.gym,
        accountId: checkingId,
        title: "Gym membership",
        category: .health,
        sender: userName,
        receiver: "Holmes Place",
        amount: -189,
        date: daysAgo(68),
        systemImage: "figure.run"
      ),
      Transaction(
        id: SampleID.restaurant,
        accountId: checkingId,
        title: "Restaurant",
        category: .dining,
        sender: userName,
        receiver: "Mashya",
        amount: -245.80,
        date: daysAgo(75),
        systemImage: "fork.knife"
      ),
      Transaction(
        id: SampleID.bonus,
        accountId: checkingId,
        title: "Performance bonus",
        category: .income,
        sender: "Discount Bank Ltd",
        receiver: userName,
        amount: 3_500,
        date: monthsAgo(2, days: 16),
        systemImage: "star.circle.fill"
      ),
      Transaction(
        id: SampleID.insurance,
        accountId: checkingId,
        title: "Car insurance",
        category: .insurance,
        sender: userName,
        receiver: "Harel Insurance",
        amount: -1_240,
        date: monthsAgo(3, days: 2),
        systemImage: "car.fill"
      ),
      Transaction(
        id: SampleID.savingsInterest,
        accountId: savingsId,
        title: "Interest payment",
        category: .income,
        sender: "Discount Bank Ltd",
        receiver: userName,
        amount: 186.25,
        date: monthsAgo(6, days: 10),
        systemImage: "percent"
      ),
      Transaction(
        id: SampleID.phoneBill,
        accountId: checkingId,
        title: "Mobile plan",
        category: .utilities,
        sender: userName,
        receiver: "Partner",
        amount: -119.90,
        date: monthsAgo(6, days: 15),
        systemImage: "iphone"
      ),
      Transaction(
        id: SampleID.rent,
        accountId: checkingId,
        title: "Rent payment",
        category: .housing,
        sender: userName,
        receiver: "Landlord — Cohen",
        amount: -4_800,
        date: monthsAgo(9, days: 1),
        systemImage: "house.fill"
      ),
      Transaction(
        id: SampleID.taxRefund,
        accountId: checkingId,
        title: "Tax refund",
        category: .income,
        sender: "Israel Tax Authority",
        receiver: userName,
        amount: 2_150,
        date: monthsAgo(11, days: 15),
        systemImage: "doc.text.fill"
      ),
      Transaction(
        id: SampleID.holidayGift,
        accountId: savingsId,
        title: "Holiday gift",
        category: .transfer,
        sender: "Family — Netanel",
        receiver: userName,
        amount: 500,
        date: monthsAgo(14, days: 6),
        systemImage: "gift.fill"
      ),
      Transaction(
        id: SampleID.oldTransfer,
        accountId: checkingId,
        title: "Legacy transfer",
        category: .transfer,
        sender: userName,
        receiver: "External account •••• 9912",
        amount: -750,
        date: monthsAgo(18, days: 20),
        systemImage: "clock.arrow.circlepath"
      ),
    ]
  }

  func fetchDemoSession(signInUsername: String) -> BankSession {
    let trimmed = signInUsername.trimmingCharacters(in: .whitespacesAndNewlines)
    var user = Self.sampleUser
    if !trimmed.isEmpty {
      user.firstName = trimmed
    }
    return BankSession(
      user: user,
      accounts: Self.sampleAccounts,
      transactions: Self.sampleTransactions
    )
  }

  /// Convenience for tests and callers that used the previous static API.
  static func makeDemoSession(signInUsername: String) -> BankSession {
    shared.fetchDemoSession(signInUsername: signInUsername)
  }
}
