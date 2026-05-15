//
//  TransactionDetailView.swift
//  DiscountBank-interview
//

import DesignSystem
import SwiftUI

struct TransactionDetailView: View {
  let transaction: Transaction
  let accountName: String
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    NavigationStack {
      ScrollView(.vertical) {
        VStack(alignment: .leading, spacing: DSSpacing.lg) {
          headerSection

          DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
              detailRow(label: "Sender", value: transaction.sender)
              detailRow(label: "Receiver", value: transaction.receiver)
              Divider().overlay(Color.dsBorderSubtle)
              detailRow(label: "Category", value: transaction.category)
              detailRow(label: "Account", value: accountName)
              detailRow(label: "Date", value: transaction.formattedDetailDate())
            }
          }
        }
        .padding(DSSpacing.lg)
      }
      .background(Color.dsBackgroundPrimary)
      .navigationTitle("Transaction")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Done") { dismiss() }
            .font(DSTypography.bodyMedium)
            .foregroundStyle(Color.dsAccent)
        }
      }
    }
    .presentationDetents([.medium, .large])
    .presentationDragIndicator(.visible)
  }

  private var headerSection: some View {
    VStack(alignment: .leading, spacing: DSSpacing.md) {
      HStack(spacing: DSSpacing.md) {
        Image(systemName: transaction.systemImage)
          .font(.title2)
          .foregroundStyle(Color.dsAccent)
          .frame(width: 44, height: 44)
          .background(Color.dsBackgroundElevated)
          .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))

        VStack(alignment: .leading, spacing: DSSpacing.xs) {
          Text(transaction.title)
            .font(DSTypography.headline)
            .foregroundStyle(Color.dsTextPrimary)
          Text(transaction.category)
            .font(DSTypography.subheadline)
            .foregroundStyle(Color.dsTextSecondary)
        }
      }

      DSAmountText(
        value: transaction.amount,
        coloring: .signedSemantic,
        prominent: true
      )
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private func detailRow(label: String, value: String) -> some View {
    VStack(alignment: .leading, spacing: DSSpacing.xs) {
      Text(label.uppercased())
        .font(DSTypography.captionMedium)
        .foregroundStyle(Color.dsTextSecondary)
      Text(value)
        .font(DSTypography.body)
        .foregroundStyle(Color.dsTextPrimary)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

#Preview {
  TransactionDetailView(
    transaction: MockBankRepository.sampleTransactions[0],
    accountName: "234 4521"
  )
}
