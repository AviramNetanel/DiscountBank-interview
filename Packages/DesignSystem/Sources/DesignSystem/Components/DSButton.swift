//
//  DSButton.swift
//  DesignSystem
//

import SwiftUI

public enum DSButtonStyle {
  case primary
  case secondary
  case ghost
}

public struct DSButton: View {
  let title: String
  var style: DSButtonStyle
  var isEnabled: Bool
  let action: () -> Void

  public init(
    title: String,
    style: DSButtonStyle = .primary,
    isEnabled: Bool = true,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.style = style
    self.isEnabled = isEnabled
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      Text(title)
        .font(DSTypography.bodyEmphasis)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 44)
    }
    .buttonStyle(DSButtonVisualStyle(style: style, isEnabled: isEnabled))
    .disabled(!isEnabled)
  }
}

// MARK: - Pressed / default visuals

private struct DSButtonVisualStyle: ButtonStyle {
  let style: DSButtonStyle
  let isEnabled: Bool

  func makeBody(configuration: Configuration) -> some View {
    let isPressed = configuration.isPressed && isEnabled

    configuration.label
      .foregroundStyle(foregroundColor)
      .background {
        backgroundView(isPressed: isPressed)
          .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))
      }
      .overlay {
        overlayView
          .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))
      }
      .opacity(isEnabled ? 1 : 0.45)
      .scaleEffect(isPressed ? 0.98 : 1)
      .animation(.easeOut(duration: 0.14), value: isPressed)
  }

  @ViewBuilder
  private func backgroundView(isPressed: Bool) -> some View {
    switch style {
    case .primary:
      ZStack {
        Color.dsAccent
        DSButton.edgeGradientOverlay(isPressed: isPressed)
      }
    case .secondary:
      ZStack {
        Color.dsBackgroundElevated
        if isPressed {
          Color.dsButtonGradient.opacity(0.08)
        }
      }
    case .ghost:
      if isPressed {
        Color.dsAccent.opacity(0.12)
      } else {
        Color.clear
      }
    }
  }

  @ViewBuilder
  private var overlayView: some View {
    switch style {
    case .secondary:
      RoundedRectangle(cornerRadius: DSRadius.sm)
        .stroke(Color.dsAccent, lineWidth: 3)
    case .primary, .ghost:
      EmptyView()
    }
  }

  private var foregroundColor: Color {
    switch style {
    case .primary:
      return .white
    case .secondary:
      return Color.dsTextPrimary
    case .ghost:
      return Color.dsAccent
    }
  }
}

private extension DSButton {
  /// Default: soft top highlight + navy bottom edge. Pressed: stronger navy, subdued highlight (inset feel).
  static func edgeGradientOverlay(isPressed: Bool) -> LinearGradient {
    if isPressed {
      return LinearGradient(
        stops: [
          .init(color: Color.dsButtonGradient.opacity(0.45), location: 0),
          .init(color: Color.dsButtonGradient.opacity(0.12), location: 0.22),
          .init(color: .clear, location: 0.5),
          .init(color: Color.black.opacity(0.22), location: 1),
        ],
        startPoint: .top,
        endPoint: .bottom
      )
    }
    else{ // not Pressed
      return LinearGradient(
        stops: [
          .init(color: Color.white.opacity(0.25), location: 0),
          .init(color: .clear, location: 0.15),
          .init(color: .clear, location: 0.66),
          .init(color: Color.dsButtonGradient.opacity(0.5), location: 1),
        ],
        startPoint: .top,
        endPoint: .bottom
      )
    }
  }
}

//MARK: - PREVIEW

#Preview("Light") {
  DSButtonPreview()
    .preferredColorScheme(.light)
}

#Preview("Dark") {
  DSButtonPreview()
    .preferredColorScheme(.dark)
}

private struct DSButtonPreview: View {
  var body: some View {
    ScrollView(.vertical) {
      VStack(spacing: DSSpacing.md) {
        DSButton(title: "Primary", style: .primary) {}
        DSButton(title: "Secondary", style: .secondary) {}
        DSButton(title: "Ghost", style: .ghost) {}
        DSButton(title: "Disabled", style: .primary, isEnabled: false) {}
      }
      .padding(DSSpacing.lg)
    }
    .background(Color.dsBackgroundPrimary)
  }
}
