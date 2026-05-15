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
  @State private var selectedTransaction: Transaction?

  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading, spacing: DSSpacing.lg) {
        HStack{
          headerRow
          Spacer()
          Image("discountBankLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 100)
        }
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
              action: { selectedTransaction = transaction }
            )
          }
        }
      }
      .padding(DSSpacing.lg)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.dsBackgroundPrimary)
    .sheet(item: $selectedTransaction) { transaction in
      TransactionDetailView(
        transaction: transaction,
        accountName: bankStore.accountName(for: transaction)
      )
    }
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
