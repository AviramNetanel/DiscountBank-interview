//
//  LoginViewModel.swift
//  DiscountBank-interview
//

import Foundation
import Observation

@Observable
final class LoginViewModel {
  var username = ""
  var password = ""
  var isDemoOn = true
  var showsForgotPasswordAlert = false

  private let bankStore: BankStore
  private let onSignIn: () -> Void

  var canSignIn: Bool {
    !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
    !password.isEmpty
  }

  init(bankStore: BankStore, onSignIn: @escaping () -> Void) {
    self.bankStore = bankStore
    self.onSignIn = onSignIn
  }

  func signIn() {
    guard canSignIn else { return }
    if isDemoOn{
      bankStore.loadDemoData(signInUsername: username)
    }
    onSignIn()
  }

  func forgotPasswordTapped() {
    showsForgotPasswordAlert = true
  }
}
