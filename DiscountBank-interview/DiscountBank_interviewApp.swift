//
//  DiscountBank_interviewApp.swift
//  DiscountBank-interview
//
//  Created by Aviram Netanel on 13/05/2026.
//

import SwiftUI

@main
struct DiscountBank_interviewApp: App {
  @State private var bankStore = BankStore()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(bankStore)
    }
  }
}
