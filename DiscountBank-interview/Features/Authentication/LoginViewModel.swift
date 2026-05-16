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

  private let onSignIn: () -> Void

  var canSignIn: Bool {
    !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isDemoOn
  }

  init(onSignIn: @escaping () -> Void) {
    self.onSignIn = onSignIn
  }

  func signIn() {
    guard canSignIn else { return }
    onSignIn()
  }

  func forgotPasswordTapped() {
    showsForgotPasswordAlert = true
  }
}
