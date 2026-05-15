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
    ScrollView(.vertical) {
      VStack(alignment: .leading, spacing: DSSpacing.lg) {
        headerRow

        DSCard {
          VStack(alignment: .leading, spacing: DSSpacing.sm) {
            Text(bankStore.balanceCardTitle)
              .font(DSTypography.captionMedium)
              .foregroundStyle(Color.dsTextSecondary)
            DSAmountText(value: bankStore.displayedBalance, coloring: .monochrome, prominent: true)
            if let account = bankStore.selectedAccount {
              Text(account.displayTitle)
                .font(DSTypography.caption)
                .foregroundStyle(Color.dsTextSecondary)
            }
          }
        }

        recentActivityHeader

        if bankStore.recentTransactions().isEmpty {
          Text("No transactions in this period.")
            .font(DSTypography.body)
            .foregroundStyle(Color.dsTextSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
          ForEach(bankStore.recentTransactions()) { transaction in
            DSListRow(
              title: transaction.title,
              subtitle: transaction.subtitle(accountName: bankStore.accountName(for: transaction)),
              systemImage: transaction.systemImage,
              trailingText: transaction.formattedAmount(),
              trailingForegroundColor: amountColor(for: transaction),
              showsDisclosure: true,
              action: {}
            )
          }
        }
      }
      .padding(DSSpacing.lg)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.dsBackgroundPrimary)
  }

  private var recentActivityHeader: some View {
    HStack(alignment: .firstTextBaseline, spacing: DSSpacing.md) {
      Text("RECENT ACTIVITY")
        .font(DSTypography.captionMedium)
        .foregroundStyle(Color.dsTextSecondary)
        .accessibilityAddTraits(.isHeader)

      Spacer(minLength: DSSpacing.sm)

      periodFilterMenu
    }
  }

  private var periodFilterMenu: some View {
    Menu {
      ForEach(TransactionPeriodFilter.allCases) { period in
        Button {
          bankStore.activityPeriodFilter = period
        } label: {
          if bankStore.activityPeriodFilter == period {
            Label(period.menuLabel, systemImage: "checkmark")
          } else {
            Text(period.menuLabel)
          }
        }
      }
    } label: {
      HStack(spacing: DSSpacing.xs) {
        Text(bankStore.activityPeriodFilter.menuLabel)
          .font(DSTypography.captionMedium)
          .foregroundStyle(Color.dsAccent)
        Image(systemName: "chevron.down")
          .font(DSTypography.caption)
          .foregroundStyle(Color.dsAccent)
      }
    }
    .accessibilityLabel("Activity period: \(bankStore.activityPeriodFilter.menuLabel)")
  }

  private var headerRow: some View {
    HStack(alignment: .center, spacing: DSSpacing.md) {
      Text(bankStore.user.greeting)
        .font(DSTypography.largeTitle)
        .foregroundStyle(Color.dsTextPrimary)
        .lineLimit(1)
        .minimumScaleFactor(0.8)

      Spacer(minLength: DSSpacing.sm)

      accountMenu
    }
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
          .font(DSTypography.bodyMedium)
          .foregroundStyle(Color.dsAccent)
          .lineLimit(1)
        Image(systemName: "chevron.down")
          .font(DSTypography.captionMedium)
          .foregroundStyle(Color.dsAccent)
      }
      .padding(.horizontal, DSSpacing.md)
      .padding(.vertical, DSSpacing.sm)
      .background(Color.dsBackgroundElevated)
      .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))
      .overlay(
        RoundedRectangle(cornerRadius: DSRadius.sm)
          .stroke(Color.dsBorderSubtle, lineWidth: 1)
      )
    }
    .accessibilityLabel("Selected account: \(bankStore.selectedAccountLabel)")
  }

  private func amountColor(for transaction: Transaction) -> Color {
    if transaction.isCredit { return Color.dsSuccess }
    if transaction.isDebit { return Color.dsAmountDebit }
    return Color.dsTextPrimary
  }
}

// MARK: - Preview

#Preview("Light") {
  ContentView()
    .environment(BankStore())
    .preferredColorScheme(.light)
}

#Preview("Dark") {
  ContentView()
    .environment(BankStore())
    .preferredColorScheme(.dark)
}
