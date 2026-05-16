//
//  TransactionTests.swift
//  DiscountBank-interviewTests
//

import XCTest
@testable import DiscountBank_interview

final class TransactionTests: XCTestCase {
  func testIsCreditAndIsDebit() {
    let credit = TestFixtures.makeTransaction(amount: 100)
    let debit = TestFixtures.makeTransaction(amount: -50)
    let zero = TestFixtures.makeTransaction(amount: 0)

    XCTAssertTrue(credit.isCredit)
    XCTAssertFalse(credit.isDebit)

    XCTAssertFalse(debit.isCredit)
    XCTAssertTrue(debit.isDebit)

    XCTAssertFalse(zero.isCredit)
    XCTAssertFalse(zero.isDebit)
  }

  func testFormattedAmountIncludesSignForDebit() {
    let debit = TestFixtures.makeTransaction(amount: -42.5)
    let formatted = debit.formattedAmount(currencyCode: "ILS", locale: TestFixtures.fixedLocale)
    XCTAssertTrue(formatted.contains("-") || formatted.contains("−"))
    XCTAssertTrue(formatted.contains("42"))
  }

  func testFormattedAmountPositiveForCredit() {
    let credit = TestFixtures.makeTransaction(amount: 100)
    let formatted = credit.formattedAmount(currencyCode: "ILS", locale: TestFixtures.fixedLocale)
    XCTAssertTrue(formatted.contains("100"))
    XCTAssertFalse(formatted.hasPrefix("-"))
    XCTAssertFalse(formatted.hasPrefix("−"))
  }

  func testSubtitleContainsAccountName() {
    let transaction = TestFixtures.makeTransaction(date: TestFixtures.fixedNow)
    let subtitle = transaction.subtitle(accountName: "Checking", locale: TestFixtures.fixedLocale)
    XCTAssertTrue(subtitle.contains("Checking"))
    XCTAssertTrue(subtitle.contains("·"))
  }
}
