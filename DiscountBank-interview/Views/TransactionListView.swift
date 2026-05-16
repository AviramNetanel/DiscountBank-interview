//
//  TransactionListView.swift
//  DiscountBank-interview
//

import DesignSystem
import SwiftUI

struct TransactionListView: View {
  @Environment(BankStore.self) private var bankStore
  @State private var selectedTransaction: Transaction?

  var body: some View {
    VStack(alignment: .leading, spacing: DSSpacing.md) {
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
    .sheet(item: $selectedTransaction) { transaction in
      TransactionDetailView(
        transaction: transaction,
        accountName: bankStore.accountName(for: transaction),
        bankStore: bankStore
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
      Image(systemName: "line.3.horizontal.decrease.circle")
        .font(.title3)
        .foregroundStyle(Color.dsAccent)
    }
    .accessibilityLabel("Activity period: \(bankStore.activityPeriodFilter.menuLabel)")
  }

  private func amountColor(for transaction: Transaction) -> Color {
    if transaction.isCredit { return Color.dsSuccess }
    if transaction.isDebit { return Color.dsAmountDebit }
    return Color.dsTextPrimary
  }
}

#Preview("Light") {
  TransactionListView()
    .environment(BankStore.preview)
    .padding(DSSpacing.lg)
    .background(Color.dsBackgroundPrimary)
    .preferredColorScheme(.light)
}

#Preview("Dark") {
  TransactionListView()
    .environment(BankStore.preview)
    .padding(DSSpacing.lg)
    .background(Color.dsBackgroundPrimary)
    .preferredColorScheme(.dark)
}
