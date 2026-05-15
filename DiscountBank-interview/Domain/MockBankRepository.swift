//
//  MockBankRepository.swift
//  DiscountBank-interview
//

import Foundation

/// Static sample data for demos and previews.
enum MockBankRepository {
  static let sampleUser = BankUser(firstName: "Aviram")

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
    let checkingId = SampleID.checkingAccount
    let savingsId = SampleID.savingsAccount
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
      // Within ~1 month
      Transaction(
        id: SampleID.coffee,
        accountId: checkingId,
        title: "Coffee Shop",
        category: "Dining",
        amount: -18.50,
        date: calendar.date(byAdding: .hour, value: -6, to: now)!,
        systemImage: "cup.and.saucer.fill"
      ),
      Transaction(
        id: SampleID.supermarket,
        accountId: checkingId,
        title: "Supermarket",
        category: "Groceries",
        amount: -286.40,
        date: daysAgo(1),
        systemImage: "cart.fill"
      ),
      Transaction(
        id: SampleID.salary,
        accountId: checkingId,
        title: "Salary — Discount Ltd",
        category: "Income",
        amount: 14_200,
        date: daysAgo(2),
        systemImage: "arrow.down.circle.fill"
      ),
      Transaction(
        id: SampleID.transferIn,
        accountId: savingsId,
        title: "Monthly transfer in",
        category: "Transfer",
        amount: 2_000,
        date: daysAgo(5),
        systemImage: "arrow.left.arrow.right.circle.fill"
      ),
      Transaction(
        id: SampleID.electric,
        accountId: checkingId,
        title: "Electric bill",
        category: "Utilities",
        amount: -412.90,
        date: daysAgo(7),
        systemImage: "bolt.fill"
      ),
      Transaction(
        id: SampleID.atm,
        accountId: checkingId,
        title: "ATM withdrawal",
        category: "Cash",
        amount: -500,
        date: daysAgo(10),
        systemImage: "banknote.fill"
      ),
      Transaction(
        id: SampleID.gym,
        accountId: checkingId,
        title: "Gym membership",
        category: "Health",
        amount: -189,
        date: daysAgo(18),
        systemImage: "figure.run"
      ),
      Transaction(
        id: SampleID.restaurant,
        accountId: checkingId,
        title: "Restaurant",
        category: "Dining",
        amount: -245.80,
        date: daysAgo(25),
        systemImage: "fork.knife"
      ),

      // ~2–3 months
      Transaction(
        id: SampleID.bonus,
        accountId: checkingId,
        title: "Performance bonus",
        category: "Income",
        amount: 3_500,
        date: monthsAgo(2, days: 4),
        systemImage: "star.circle.fill"
      ),
      Transaction(
        id: SampleID.insurance,
        accountId: checkingId,
        title: "Car insurance",
        category: "Insurance",
        amount: -1_240,
        date: monthsAgo(3, days: 2),
        systemImage: "car.fill"
      ),

      // ~4–6 months
      Transaction(
        id: SampleID.savingsInterest,
        accountId: savingsId,
        title: "Interest payment",
        category: "Income",
        amount: 186.25,
        date: monthsAgo(5, days: 10),
        systemImage: "percent"
      ),
      Transaction(
        id: SampleID.phoneBill,
        accountId: checkingId,
        title: "Mobile plan",
        category: "Utilities",
        amount: -119.90,
        date: monthsAgo(6, days: 3),
        systemImage: "iphone"
      ),

      // ~7–12 months
      Transaction(
        id: SampleID.rent,
        accountId: checkingId,
        title: "Rent payment",
        category: "Housing",
        amount: -4_800,
        date: monthsAgo(9, days: 1),
        systemImage: "house.fill"
      ),
      Transaction(
        id: SampleID.taxRefund,
        accountId: checkingId,
        title: "Tax refund",
        category: "Income",
        amount: 2_150,
        date: monthsAgo(11, days: 15),
        systemImage: "doc.text.fill"
      ),

      // Older than 1 year (visible only on Max)
      Transaction(
        id: SampleID.holidayGift,
        accountId: savingsId,
        title: "Holiday gift",
        category: "Transfer",
        amount: 500,
        date: monthsAgo(14, days: 6),
        systemImage: "gift.fill"
      ),
      Transaction(
        id: SampleID.oldTransfer,
        accountId: checkingId,
        title: "Legacy transfer",
        category: "Transfer",
        amount: -750,
        date: monthsAgo(18, days: 20),
        systemImage: "clock.arrow.circlepath"
      ),
    ]
  }
}
