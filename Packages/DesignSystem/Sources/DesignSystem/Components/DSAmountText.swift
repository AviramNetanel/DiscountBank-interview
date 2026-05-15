//
//  DSAmountText.swift
//  DesignSystem
//

import SwiftUI

public enum DSAmountColoring {
  case monochrome
  case signedSemantic
}

public struct DSAmountText: View {
  public var value: Decimal
  public var currencyCode: String
  public var coloring: DSAmountColoring
  public var prominent: Bool

  public init(
    value: Decimal,
    currencyCode: String = "ILS",
    coloring: DSAmountColoring = .monochrome,
    prominent: Bool = false
  ) {
    self.value = value
    self.currencyCode = currencyCode
    self.coloring = coloring
    self.prominent = prominent
  }

  public var body: some View {
    Text(value, format: .currency(code: currencyCode).precision(.fractionLength(2)))
      .font(prominent ? DSTypography.largeTitle : DSTypography.bodyEmphasis)
      .monospacedDigit()
      .foregroundStyle(foregroundColor)
  }

  private var foregroundColor: Color {
    switch coloring {
    case .monochrome:
      return Color.dsTextPrimary
    case .signedSemantic:
      if value > 0 { return Color.dsSuccess }
      if value < 0 { return Color.dsAmountDebit }
      return Color.dsTextPrimary
    }
  }
}

#Preview("Light") {
  DSAmountTextPreview()
    .preferredColorScheme(.light)
}

#Preview("Dark") {
  DSAmountTextPreview()
    .preferredColorScheme(.dark)
}

private struct DSAmountTextPreview: View {
  var body: some View {
    VStack(alignment: .leading, spacing: DSSpacing.md) {
      DSAmountText(value: 1_250, coloring: .monochrome)
      DSAmountText(value: -42.37, coloring: .signedSemantic)
      DSAmountText(value: 99, coloring: .signedSemantic, prominent: true)
    }
    .padding()
    .background(Color.dsBackgroundPrimary)
  }
}
