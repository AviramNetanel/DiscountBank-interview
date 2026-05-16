//
//  ContentView.swift
//  DiscountBank-interview
//
//  Created by Aviram Netanel on 13/05/2026.
//

import DesignSystem
import SwiftUI

struct ContentView: View {
  @Environment(BankStore.self) private var bankStore

  var body: some View {
    
    VStack(alignment: .leading, spacing: DSSpacing.lg) {
      HStack {
        headerRow
        Spacer()
        Image("discountBankLogo")
          .resizable()
          .scaledToFit()
          .frame(width: 100)
      }
      .padding(.horizontal, DSSpacing.lg)
      
      DSCard {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
          HStack(alignment: .firstTextBaseline, spacing: DSSpacing.sm) {
            Text(bankStore.balanceCardTitle)
              .font(DSTypography.captionMedium)
              .foregroundStyle(Color.dsTextSecondary)
            
            Spacer()
            
            accountMenu
          }
          DSAmountText(value: bankStore.displayedBalance, coloring: .monochrome, prominent: true)
        }
      }
      
      ScrollView(.vertical) {
        TransactionListView()
      }
      .padding(DSSpacing.lg)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    .background(Color.dsBackgroundPrimary)
  }

  private var headerRow: some View {
    Text(bankStore.user.greeting)
      .font(DSTypography.largeTitle)
      .foregroundStyle(Color.dsTextPrimary)
      .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var accountMenu: some View {
    Menu {
      Button {
        bankStore.selectAccount(nil)
      } label: {
        if bankStore.selectedAccountId == nil {
          Label("All accounts", systemImage: "checkmark")
        } else {
          Text("All accounts")
        }
      }

      ForEach(bankStore.accounts) { account in
        Button {
          bankStore.selectAccount(account)
        } label: {
          if bankStore.selectedAccountId == account.id {
            Label(account.name, systemImage: "checkmark")
          } else {
            Text(account.name)
          }
        }
      }
    } label: {
      HStack(spacing: DSSpacing.xs) {
        Text(bankStore.selectedAccountLabel)
          .font(DSTypography.captionMedium)
          .foregroundStyle(Color.dsAccent)
          .lineLimit(1)
        Image(systemName: "chevron.down")
          .font(DSTypography.caption)
          .foregroundStyle(Color.dsAccent)
      }
    }
    .accessibilityLabel("Selected account: \(bankStore.selectedAccountLabel)")
  }
}

// MARK: - Preview

#Preview("Light") {
  ContentView()
    .environment(BankStore.preview)
    .preferredColorScheme(.light)
}

#Preview("Dark") {
  ContentView()
    .environment(BankStore.preview)
    .preferredColorScheme(.dark)
}
