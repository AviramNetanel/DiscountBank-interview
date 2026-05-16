//
//  TransactionPeriodFilterTests.swift
//  DiscountBank-interviewTests
//

import XCTest
@testable import DiscountBank_interview

final class TransactionPeriodFilterTests: XCTestCase {
  private let calendar = TestFixtures.fixedCalendar
  private let now = TestFixtures.fixedNow

  func testMaxIncludesAllDates() {
    let ancient = TestFixtures.date(byAdding: .year, value: -50)
    XCTAssertTrue(TransactionPeriodFilter.max.includes(date: ancient, relativeTo: now, calendar: calendar))
    XCTAssertTrue(TransactionPeriodFilter.max.includes(date: now, relativeTo: now, calendar: calendar))
  }

  func testOneMonthIncludesCutoffAndExcludesEarlier() {
    let cutoff = calendar.date(byAdding: .month, value: -1, to: now)!
    XCTAssertTrue(
      TransactionPeriodFilter.oneMonth.includes(date: cutoff, relativeTo: now, calendar: calendar)
    )
  }

  func testOneMonthExcludesDateBeforeCutoff() {
    let cutoff = calendar.date(byAdding: .month, value: -1, to: now)!
    let beforeCutoff = cutoff.addingTimeInterval(-1)
    XCTAssertFalse(
      TransactionPeriodFilter.oneMonth.includes(date: beforeCutoff, relativeTo: now, calendar: calendar)
    )
  }

  func testThreeMonthsBoundary() {
    let cutoff = calendar.date(byAdding: .month, value: -3, to: now)!
    XCTAssertTrue(
      TransactionPeriodFilter.threeMonths.includes(date: cutoff, relativeTo: now, calendar: calendar)
    )
    XCTAssertFalse(
      TransactionPeriodFilter.threeMonths.includes(
        date: cutoff.addingTimeInterval(-1),
        relativeTo: now,
        calendar: calendar
      )
    )
  }

  func testSixMonthsBoundary() {
    let cutoff = calendar.date(byAdding: .month, value: -6, to: now)!
    XCTAssertTrue(
      TransactionPeriodFilter.sixMonths.includes(date: cutoff, relativeTo: now, calendar: calendar)
    )
    XCTAssertFalse(
      TransactionPeriodFilter.sixMonths.includes(
        date: cutoff.addingTimeInterval(-1),
        relativeTo: now,
        calendar: calendar
      )
    )
  }

  func testOneYearBoundary() {
    let cutoff = calendar.date(byAdding: .year, value: -1, to: now)!
    XCTAssertTrue(
      TransactionPeriodFilter.oneYear.includes(date: cutoff, relativeTo: now, calendar: calendar)
    )
    XCTAssertFalse(
      TransactionPeriodFilter.oneYear.includes(
        date: cutoff.addingTimeInterval(-1),
        relativeTo: now,
        calendar: calendar
      )
    )
  }
}
