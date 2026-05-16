//
//  TransactionDetailView.swift
//  DiscountBank-interview
//

import DesignSystem
import SwiftUI

struct TransactionDetailView: View {
  let transaction: Transaction
  let accountName: String

  @Environment(BankStore.self) private var bankStore
  @Environment(\.dismiss) private var dismiss

  @State private var isEditing = false
  @State private var selectedDetent: PresentationDetent = .medium
  @State private var draft = TransactionDraft.empty

  var body: some View {
    NavigationStack {
      ScrollView(.vertical) {
        VStack(alignment: .leading, spacing: DSSpacing.lg) {
          headerSection

          DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
              if isEditing {
                editableField(label: "Sender", text: $draft.sender)
                Divider().overlay(Color.dsBorderSubtle)
                editableField(label: "Receiver", text: $draft.receiver)
                Divider().overlay(Color.dsBorderSubtle)
                editableDateField
                Divider().overlay(Color.dsBorderSubtle)
                detailRow(label: "Account", value: accountName)
                Divider().overlay(Color.dsBorderSubtle)
                detailRow(label: "Transaction ID", value: transaction.id.uuidString)
              } else {
                detailRow(label: "Sender", value: displayTransaction.sender)
                Divider().overlay(Color.dsBorderSubtle)
                detailRow(label: "Receiver", value: displayTransaction.receiver)
                Divider().overlay(Color.dsBorderSubtle)
                detailRow(label: "Date", value: displayTransaction.formattedDetailDate())
                Divider().overlay(Color.dsBorderSubtle)
                detailRow(label: "Account", value: accountName)
                Divider().overlay(Color.dsBorderSubtle)
                detailRow(label: "Transaction ID", value: transaction.id.uuidString)
              }
            }
          }
        }
        .padding(DSSpacing.lg)
      }
      .background(Color.dsBackgroundPrimary)
      .navigationTitle("Transaction")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
              .font(DSTypography.bodyMedium)
              .foregroundStyle(Color.dsTextPrimary)
          }
          .accessibilityLabel("Close without saving")
        }

        ToolbarItem(placement: .topBarTrailing) {
          Button {
            if isEditing {
              saveEdits()
            } else {
              beginEditing()
            }
          } label: {
            Image(systemName: isEditing ? "checkmark.circle" : "pencil")
              .font(.title3)
              .foregroundStyle(Color.dsAccent)
          }
          .accessibilityLabel(isEditing ? "Save changes" : "Edit transaction")
        }
      }
    }
    .presentationDetents(
      isEditing ? [.large] : [.medium, .large],
      selection: $selectedDetent
    )
    .presentationDragIndicator(.visible)
  }

  private var displayTransaction: Transaction {
    bankStore.transactions.first { $0.id == transaction.id } ?? transaction
  }

  private var activeCategory: TransactionCategory {
    isEditing ? draft.category : displayTransaction.category
  }

  private var headerSection: some View {
    VStack(alignment: .leading, spacing: DSSpacing.md) {
      DSAmountText(
        value: displayTransaction.amount,
        coloring: .signedSemantic,
        prominent: true
      )

      if isEditing {
        TextField("Title", text: $draft.title)
          .font(DSTypography.headline)
          .foregroundStyle(Color.dsTextPrimary)
      } else {
        Text(displayTransaction.title)
          .font(DSTypography.headline)
          .foregroundStyle(Color.dsTextPrimary)
      }

      if isEditing {
        categoryPickerRow
      } else {
        categoryDisplayRow
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var categoryDisplayRow: some View {
    HStack(spacing: DSSpacing.sm) {
      Image(systemName: displayTransaction.category.systemImage)
        .font(DSTypography.bodyMedium)
        .foregroundStyle(Color.dsAccent)
        .frame(width: 28, height: 28)
        .background(Color.dsBackgroundElevated)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))

      Text(displayTransaction.category.title)
        .font(DSTypography.subheadline)
        .foregroundStyle(Color.dsTextSecondary)
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel("Category: \(displayTransaction.category.title)")
  }

  private var categoryPickerRow: some View {
    Menu {
      ForEach(TransactionCategory.allCases) { category in
        Button {
          draft.category = category
        } label: {
          if activeCategory == category {
            Label(category.title, systemImage: category.systemImage)
          } else {
            Label {
              Text(category.title)
            } icon: {
              Image(systemName: category.systemImage)
            }
          }
        }
      }
    } label: {
      HStack(spacing: DSSpacing.sm) {
        Image(systemName: activeCategory.systemImage)
          .font(DSTypography.bodyMedium)
          .foregroundStyle(Color.dsAccent)
          .frame(width: 28, height: 28)
          .background(Color.dsBackgroundElevated)
          .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))

        Text(activeCategory.title)
          .font(DSTypography.subheadline)
          .foregroundStyle(Color.dsTextSecondary)

        Image(systemName: "chevron.down")
          .font(DSTypography.captionMedium)
          .foregroundStyle(Color.dsTextSecondary)
      }
    }
    .buttonStyle(.plain)
    .accessibilityLabel("Category: \(activeCategory.title). Tap to change.")
  }

  private var editableDateField: some View {
    VStack(alignment: .leading, spacing: DSSpacing.xs) {
      Text("DATE")
        .font(DSTypography.captionMedium)
        .foregroundStyle(Color.dsTextSecondary)
      DatePicker(
        "",
        selection: $draft.date,
        displayedComponents: [.date, .hourAndMinute]
      )
      .labelsHidden()
      .datePickerStyle(.compact)
      .tint(Color.dsAccent)
    }
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

  private func editableField(label: String, text: Binding<String>) -> some View {
    VStack(alignment: .leading, spacing: DSSpacing.xs) {
      Text(label.uppercased())
        .font(DSTypography.captionMedium)
        .foregroundStyle(Color.dsTextSecondary)
      TextField(label, text: text)
        .font(DSTypography.body)
        .foregroundStyle(Color.dsTextPrimary)
        .padding(DSSpacing.sm)
        .background(Color.dsBackgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))
        .overlay(
          RoundedRectangle(cornerRadius: DSRadius.sm)
            .stroke(Color.dsBorderSubtle, lineWidth: 1)
        )
    }
  }

  private func beginEditing() {
    draft = TransactionDraft(transaction: displayTransaction)
    withAnimation {
      isEditing = true
      selectedDetent = .large
    }
  }

  private func saveEdits() {
    var updated = displayTransaction
    updated.title = draft.title.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    updated.category = draft.category
    updated.sender = draft.sender.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    updated.receiver = draft.receiver.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    updated.date = draft.date

    bankStore.updateTransaction(updated)

    withAnimation {
      isEditing = false
    }
  }
}

// MARK: - Edit draft

private struct TransactionDraft {
  var title: String
  var category: TransactionCategory
  var sender: String
  var receiver: String
  var date: Date

  static let empty = TransactionDraft()

  init(
    title: String = "",
    category: TransactionCategory = .dining,
    sender: String = "",
    receiver: String = "",
    date: Date = .now
  ) {
    self.title = title
    self.category = category
    self.sender = sender
    self.receiver = receiver
    self.date = date
  }

  init(transaction: Transaction) {
    self.init(
      title: transaction.title,
      category: transaction.category,
      sender: transaction.sender,
      receiver: transaction.receiver,
      date: transaction.date
    )
  }
}

#Preview {
  TransactionDetailView(
    transaction: MockBankRepository.sampleTransactions[0],
    accountName: "234 4521"
  )
  .environment(BankStore())
}
