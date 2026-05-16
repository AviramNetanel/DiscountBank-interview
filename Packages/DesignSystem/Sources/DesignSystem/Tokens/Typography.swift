//
//  Typography.swift
//  DesignSystem
//
//  Roboto variable font from Resources/Fonts.
//

import SwiftUI

public enum DSTypography {
  public static let largeTitle = roboto(size: 30, weight: .black)
  public static let headline = roboto(size: 17, weight: .semibold)
  public static let body = roboto(size: 16, weight: .regular)
  public static let bodyEmphasis = roboto(size: 16, weight: .semibold)
  public static let bodyMedium = roboto(size: 16, weight: .medium)
  public static let subheadline = roboto(size: 13, weight: .regular)
  public static let caption = roboto(size: 12, weight: .regular)
  public static let captionMedium = roboto(size: 12, weight: .medium)

  private static func roboto(size: CGFloat, weight: Font.Weight) -> Font {
    DSFontRegistration.registerIfNeeded()
    return .custom(DSFontName.variable, size: size).weight(weight)
  }
}

private enum DSFontName {
  static let variable = "Roboto"
}
