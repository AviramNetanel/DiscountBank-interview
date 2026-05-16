//
//  DSListRow.swift
//  DesignSystem
//

import SwiftUI

public struct DSListRow: View {
  let title: String
  var subtitle: String?
  var systemImage: String?
  var trailingText: String?
  var trailingForegroundColor: Color?
  var showsDisclosure: Bool
  var action: (() -> Void)?

  public init(
    title: String,
    subtitle: String? = nil,
    systemImage: String? = nil,
    trailingText: String? = nil,
    trailingForegroundColor: Color? = nil,
    showsDisclosure: Bool = false,
    action: (() -> Void)? = nil
  ) {
    self.title = title
    self.subtitle = subtitle
    self.systemImage = systemImage
    self.trailingText = trailingText
    self.trailingForegroundColor = trailingForegroundColor
    self.showsDisclosure = showsDisclosure
    self.action = action
  }

  public var body: some View {
    Group {
      if let action {
        Button(action: action) {
          rowContent
        }
        .buttonStyle(.plain)
      } else {
        rowContent
      }
    }
    .accessibilityElement(children: .combine)
    .accessibilityAddTraits(action == nil ? [] : .isButton)
  }

  private var rowContent: some View {
    HStack(alignment: .center, spacing: DSSpacing.md) {
      if let systemImage {
        Image(systemName: systemImage)
          .font(DSTypography.bodyMedium)
          .foregroundStyle(Color.dsTextPrimary)
          .frame(width: 28, height: 28)
          .accessibilityHidden(true)
      }

      VStack(alignment: .leading, spacing: DSSpacing.xs) {
        Text(title)
          .font(DSTypography.bodyEmphasis)
          .foregroundStyle(Color.dsTextPrimary)
          .multilineTextAlignment(.leading)

        if let subtitle, !subtitle.isEmpty {
          Text(subtitle)
            .font(DSTypography.subheadline)
            .foregroundStyle(Color.dsTextSecondary)
            .multilineTextAlignment(.leading)
        }
      }

      Spacer(minLength: DSSpacing.sm)

      if let trailingText, !trailingText.isEmpty {
        Text(trailingText)
          .font(DSTypography.bodyMedium)
          .foregroundStyle(trailingForegroundColor ?? Color.dsTextPrimary)
          .multilineTextAlignment(.trailing)
      }

      if showsDisclosure {
        Image(systemName: "chevron.right")
          .font(DSTypography.captionMedium)
          .foregroundStyle(Color.dsTextSecondary)
          .accessibilityHidden(true)
      }
    }
    .padding(.vertical, DSSpacing.sm)
    .contentShape(Rectangle())
  }
}

#Preview("Light") {
  DSListRowPreview()
    .preferredColorScheme(.light)
}

#Preview("Dark") {
  DSListRowPreview()
    .preferredColorScheme(.dark)
}

private struct DSListRowPreview: View {
  var body: some View {
    ScrollView(.vertical) {
      VStack(spacing: 0) {
        DSListRow(
          title: "Coffee Shop",
          subtitle: "Yesterday · Checking",
          systemImage: "cup.and.saucer.fill",
          trailingText: "-₪ 18.50",
          trailingForegroundColor: .dsAmountDebit,
          showsDisclosure: true,
          action: {}
        )
        Divider().padding(.leading, DSSpacing.lg)

        DSListRow(
          title: "Salary deposit",
          subtitle: "3 May · Savings",
          systemImage: "arrow.down.circle.fill",
          trailingText: "+₪ 12,000",
          trailingForegroundColor: .dsSuccess,
          showsDisclosure: false
        )
      }
      .padding(.horizontal, DSSpacing.lg)
    }
    .background(Color.dsBackgroundElevated)
  }
}
