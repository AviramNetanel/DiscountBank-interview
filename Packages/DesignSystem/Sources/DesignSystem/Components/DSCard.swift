//
//  DSCard.swift
//  DesignSystem
//

import SwiftUI

public struct DSCard<Content: View>: View {
  private let content: Content

  public init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  public var body: some View {
    content
      .padding(DSSpacing.lg)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color.dsBackgroundElevated)
      .clipShape(RoundedRectangle(cornerRadius: DSRadius.md))
      .overlay(
        RoundedRectangle(cornerRadius: DSRadius.md)
          .stroke(Color.dsBorderSubtle, lineWidth: 1)
      )
  }
}

#Preview("Light") {
  DSCardPreview()
    .preferredColorScheme(.light)
}

#Preview("Dark") {
  DSCardPreview()
    .preferredColorScheme(.dark)
}

private struct DSCardPreview: View {
  var body: some View {
    ScrollView(.vertical) {
      DSCard {
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
          Text("Balance")
            .font(DSTypography.captionMedium)
            .foregroundStyle(Color.dsTextSecondary)
          DSAmountText(value: 12_430.50, coloring: .monochrome)
        }
      }
      .padding()
    }
    .background(Color.dsBackgroundPrimary)
  }
}
