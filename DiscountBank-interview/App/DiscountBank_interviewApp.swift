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
  private let isUnitTesting: Bool
  private let modelContainer: ModelContainer
  @State private var bankStore: BankStore
  @State private var isLoggedIn = false

  init() {
    isUnitTesting = ProcessInfo.isUnitTesting

    if isUnitTesting {
      modelContainer = try! ModelContainer(
        for: TransactionOverride.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
      )
      _bankStore = State(initialValue: BankStore())
      return
    }

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
      rootView
        .environment(bankStore)
    }
    .modelContainer(modelContainer)
  }

  @ViewBuilder
  private var rootView: some View {
    if isUnitTesting {
      EmptyView()
    } else if isLoggedIn {
      ContentView()
    } else {
      LoginView(isLoggedIn: $isLoggedIn, bankStore: bankStore)
    }
  }
}
