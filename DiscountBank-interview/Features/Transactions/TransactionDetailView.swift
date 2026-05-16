//
//  TransactionDetailView.swift
//  DiscountBank-interview
//

import DesignSystem
import SwiftUI

struct TransactionDetailView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: TransactionDetailViewModel
  @State private var selectedDetent: PresentationDetent = .medium

  init(transaction: Transaction, accountName: String, bankStore: BankStore) {
    _viewModel = State(
      initialValue: TransactionDetailViewModel(
        transaction: transaction,
        accountName: accountName,
        bankStore: bankStore
      )
    )
  }

  var body: some View {
    @Bindable var viewModel = viewModel

    NavigationStack {
      ScrollView(.vertical) {
        VStack(alignment: .leading, spacing: DSSpacing.lg) {
          VStack(alignment: .leading, spacing: DSSpacing.md) {
            DSAmountText(
              value: viewModel.displayTransaction.amount,
              coloring: .signedSemantic,
              prominent: true
            )

            if viewModel.isEditing {
              editableField(label: nil, text: $viewModel.draft.title)
                .font(DSTypography.headline)
                .bold()
            } else {
              Text(viewModel.displayTransaction.title)
                .font(DSTypography.headline)
                .foregroundStyle(Color.dsTextPrimary)
            }

            if viewModel.isEditing {
              categoryPickerRow
            } else {
              categoryDisplayRow
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
              if viewModel.isEditing {
                editableField(label: "Sender", text: $viewModel.draft.sender)
                Divider().overlay(Color.dsBorderSubtle)
                editableField(label: "Receiver", text: $viewModel.draft.receiver)
                Divider().overlay(Color.dsBorderSubtle)
                datePickerField
                Divider().overlay(Color.dsBorderSubtle)
                detailRow(label: "Account", value: viewModel.accountName)
                Divider().overlay(Color.dsBorderSubtle)
                detailRow(label: "Transaction ID", value: viewModel.transactionIDText)
              } else {
                detailRow(label: "Sender", value: viewModel.displayTransaction.sender)
                Divider().overlay(Color.dsBorderSubtle)
                detailRow(label: "Receiver", value: viewModel.displayTransaction.receiver)
                Divider().overlay(Color.dsBorderSubtle)
                detailRow(label: "Date", value: viewModel.displayTransaction.formattedDetailDate())
                Divider().overlay(Color.dsBorderSubtle)
                detailRow(label: "Account", value: viewModel.accountName)
                Divider().overlay(Color.dsBorderSubtle)
                detailRow(label: "Transaction ID", value: viewModel.transactionIDText)
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
            withAnimation {
              let wasEditing = viewModel.isEditing
              viewModel.toolbarPrimaryTapped()
              if !wasEditing {
                selectedDetent = .large
              }
            }
          } label: {
            Image(systemName: viewModel.isEditing ? "checkmark" : "pencil")
              .font(.title3)
              .foregroundStyle(Color.dsAccent)
          }
          .accessibilityLabel(viewModel.isEditing ? "Save changes" : "Edit transaction")
        }
      }
    }
    .presentationDetents(
      viewModel.isEditing ? [.large] : [.medium, .large],
      selection: $selectedDetent
    )
    .presentationDragIndicator(.visible)
  }

  private var categoryDisplayRow: some View {
    HStack(spacing: DSSpacing.sm) {
      Image(systemName: viewModel.displayTransaction.category.systemImage)
        .font(DSTypography.bodyMedium)
        .foregroundStyle(Color.dsAccent)
        .frame(width: 28, height: 28)
        .background(Color.dsBackgroundElevated)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))

      Text(viewModel.displayTransaction.category.title)
        .font(DSTypography.subheadline)
        .foregroundStyle(Color.dsTextSecondary)
    }
    .accessibilityElement(children: .combine)
    .accessibilityLabel("Category: \(viewModel.displayTransaction.category.title)")
  }

  private var categoryPickerRow: some View {
    Menu {
      ForEach(TransactionCategory.allCases) { category in
        Button {
          viewModel.selectCategory(category)
        } label: {
          if viewModel.activeCategory == category {
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
        Image(systemName: viewModel.activeCategory.systemImage)
          .font(DSTypography.bodyMedium)
          .foregroundStyle(Color.dsAccent)
          .frame(width: 28, height: 28)
          .background(Color.dsBackgroundElevated)
          .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))

        Text(viewModel.activeCategory.title)
          .font(DSTypography.subheadline)
          .foregroundStyle(Color.dsTextSecondary)

        Image(systemName: "chevron.down")
          .font(DSTypography.captionMedium)
          .foregroundStyle(Color.dsTextSecondary)
      }
    }
    .buttonStyle(.plain)
    .accessibilityLabel("Category: \(viewModel.activeCategory.title). Tap to change.")
  }

  private var datePickerField: some View {
    VStack(alignment: .leading, spacing: DSSpacing.xs) {
      Text("DATE")
        .font(DSTypography.captionMedium)
        .foregroundStyle(Color.dsTextSecondary)
      DatePicker(
        "",
        selection: $viewModel.draft.date,
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

  private func editableField(label: String?, text: Binding<String>) -> some View {
    VStack(alignment: .leading, spacing: DSSpacing.xs) {
      if let label {
        Text(label.uppercased())
          .font(DSTypography.captionMedium)
          .foregroundStyle(Color.dsTextSecondary)
      }
      TextField(label ?? "", text: text)
        .font(DSTypography.body)
        .foregroundStyle(Color.dsTextPrimary)
        .padding(DSSpacing.md)
        .background(Color.dsBackgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))
        .overlay(
          RoundedRectangle(cornerRadius: DSRadius.sm)
            .stroke(Color.dsBorderSubtle, lineWidth: 1)
        )
    }
  }
}

#Preview("Light") {
  TransactionDetailView(
    transaction: MockBankRepository.sampleTransactions[0],
    accountName: "234 4521",
    bankStore: .preview
  )
  .preferredColorScheme(.light)
}

#Preview("Dark") {
  TransactionDetailView(
    transaction: MockBankRepository.sampleTransactions[0],
    accountName: "234 4521",
    bankStore: .preview
  )
  .preferredColorScheme(.dark)
}
