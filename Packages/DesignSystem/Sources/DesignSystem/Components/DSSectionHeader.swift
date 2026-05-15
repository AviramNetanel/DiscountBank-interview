//
//  DSSectionHeader.swift
//  DesignSystem
//

import SwiftUI

public struct DSSectionHeader: View {
  let title: String
  var accessoryTitle: String?
  var accessoryAction: (() -> Void)?

  public init(
    title: String,
    accessoryTitle: String? = nil,
    accessoryAction: (() -> Void)? = nil
  ) {
    self.title = title
    self.accessoryTitle = accessoryTitle
    self.accessoryAction = accessoryAction
  }

  public var body: some View {
    HStack(alignment: .firstTextBaseline) {
      Text(title.uppercased())
        .font(DSTypography.captionMedium)
        .foregroundStyle(Color.dsTextSecondary)
        .accessibilityAddTraits(.isHeader)

      Spacer(minLength: DSSpacing.md)

      if let accessoryTitle, let accessoryAction {
        Button(accessoryTitle, action: accessoryAction)
          .font(DSTypography.captionMedium)
          .foregroundStyle(Color.dsAccent)
          .buttonStyle(.plain)
      }
    }
  }
}

#Preview("Light") {
  DSSectionHeaderPreview()
    .preferredColorScheme(.light)
}

#Preview("Dark") {
  DSSectionHeaderPreview()
    .preferredColorScheme(.dark)
}

private struct DSSectionHeaderPreview: View {
  var body: some View {
    VStack(alignment: .leading, spacing: DSSpacing.lg) {
      DSSectionHeader(title: "Recent activity")
      DSSectionHeader(title: "Accounts", accessoryTitle: "See all") {}
    }
    .padding()
    .background(Color.dsBackgroundPrimary)
  }
}
