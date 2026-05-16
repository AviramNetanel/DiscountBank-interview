//
//  DiscountBank_interviewApp.swift
//  DiscountBank-interview
//
//  Created by Aviram Netanel on 13/05/2026.
//

import SwiftData
import SwiftUI

@main
struct DiscountBank_interviewApp: App {
  private let modelContainer: ModelContainer
  @State private var bankStore: BankStore
  @State private var isLoggedIn = false

  init() {
    let container: ModelContainer
    do {
      container = try ModelContainer(for: TransactionOverride.self)
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
    modelContainer = container
    _bankStore = State(
      initialValue: BankStore(
        persistence: TransactionPersistence(modelContext: container.mainContext)
      )
    )
  }

  var body: some Scene {
    WindowGroup {
      Group {
        if isLoggedIn {
          ContentView()
        } else {
          LoginView(isLoggedIn: $isLoggedIn, bankStore: bankStore)
        }
      }
      .environment(bankStore)
    }
    .modelContainer(modelContainer)
  }
}
