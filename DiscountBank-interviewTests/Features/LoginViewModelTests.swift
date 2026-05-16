//
//  LoginViewModelTests.swift
//  DiscountBank-interviewTests
//

import XCTest
@testable import DiscountBank_interview

@MainActor
final class LoginViewModelTests: XCTestCase {
  private var bankStore: BankStore!
  private var didSignIn = false
  private var viewModel: LoginViewModel!

  override func setUp() {
    super.setUp()
    bankStore = BankStore()
    didSignIn = false
    viewModel = LoginViewModel(bankStore: bankStore) { [weak self] in
      self?.didSignIn = true
    }
  }

  func testCanSignInRequiresNonEmptyCredentials() {
    viewModel.username = ""
    viewModel.password = "secret"
    XCTAssertFalse(viewModel.canSignIn)

    viewModel.username = "   "
    XCTAssertFalse(viewModel.canSignIn)

    viewModel.username = "user"
    viewModel.password = ""
    XCTAssertFalse(viewModel.canSignIn)

    viewModel.password = "secret"
    XCTAssertTrue(viewModel.canSignIn)
  }

  func testSignInDoesNothingWhenCannotSignIn() {
    viewModel.username = ""
    viewModel.password = ""
    viewModel.signIn()
    XCTAssertFalse(didSignIn)
    XCTAssertTrue(bankStore.accounts.isEmpty)
  }

  func testSignInWithDemoLoadsDataAndCallsCallback() {
    viewModel.isDemoOn = true
    viewModel.username = "Aviram"
    viewModel.password = "demo"
    viewModel.signIn()
    XCTAssertTrue(didSignIn)
    XCTAssertFalse(bankStore.accounts.isEmpty)
    XCTAssertEqual(bankStore.user.firstName, "Aviram")
  }

  func testSignInWithoutDemoCallsCallbackButLeavesStoreEmpty() {
    viewModel.isDemoOn = false
    viewModel.username = "Aviram"
    viewModel.password = "demo"
    viewModel.signIn()
    XCTAssertTrue(didSignIn)
    XCTAssertTrue(bankStore.accounts.isEmpty)
    XCTAssertTrue(bankStore.transactions.isEmpty)
  }

  func testForgotPasswordTappedShowsAlert() {
    XCTAssertFalse(viewModel.showsForgotPasswordAlert)
    viewModel.forgotPasswordTapped()
    XCTAssertTrue(viewModel.showsForgotPasswordAlert)
  }
}
