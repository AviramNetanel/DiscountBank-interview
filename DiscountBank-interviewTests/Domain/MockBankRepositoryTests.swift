//
//  MockBankRepositoryTests.swift
//  DiscountBank-interviewTests
//

import XCTest
@testable import DiscountBank_interview

@MainActor
final class MockBankRepositoryTests: XCTestCase {
  func testMakeDemoSessionKeepsDefaultFirstNameForEmptyUsername() {
    let session = MockBankRepository.makeDemoSession(signInUsername: "   ")
    XCTAssertEqual(session.user.firstName, MockBankRepository.sampleUser.firstName)
  }

  func testMakeDemoSessionUsesTrimmedUsername() {
    let session = MockBankRepository.makeDemoSession(signInUsername: "  Dana  ")
    XCTAssertEqual(session.user.firstName, "Dana")
  }

  func testMakeDemoSessionIncludesAccountsAndTransactions() {
    let session = MockBankRepository.makeDemoSession(signInUsername: "Test")
    XCTAssertFalse(session.accounts.isEmpty)
    XCTAssertFalse(session.transactions.isEmpty)
  }
}
