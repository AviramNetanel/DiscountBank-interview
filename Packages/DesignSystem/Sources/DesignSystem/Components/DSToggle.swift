//
//  DSToggle.swift
//  DesignSystem
//

import SwiftUI

/// Design-system switch with accent fill and edge gradient when on.
public struct DSToggle: View {
  private let label: String?
  @Binding private var isOn: Bool

  public init(isOn: Binding<Bool>, label: String? = nil) {
    _isOn = isOn
    self.label = label
  }

  public var body: some View {
    Toggle(isOn: $isOn) {
      if let label {
        Text(label)
          .font(DSTypography.body)
          .foregroundStyle(Color.dsTextPrimary)
      }
    }
    .toggleStyle(DSToggleStyle())
  }
}

// MARK: - Toggle style

private struct DSToggleStyle: ToggleStyle {
  private let trackWidth: CGFloat = 60
  private let trackHeight: CGFloat = 31
  private let thumbSize: CGFloat = 27
  private let thumbPadding: CGFloat = 2

  func makeBody(configuration: Configuration) -> some View {
    Button {
      withAnimation(.easeInOut(duration: 0.2)) {
        configuration.isOn.toggle()
      }
    } label: {
      VStack(spacing: DSSpacing.md) {
        configuration.label
        track(isOn: configuration.$isOn.wrappedValue)
      }
    }
    .buttonStyle(.plain)
    .accessibilityAddTraits(configuration.isOn ? [.isSelected] : [])
  }

  private func track(isOn: Bool) -> some View {
    ZStack(alignment: isOn ? .trailing : .leading) {
      Group {
        if isOn {
          ZStack {
            Color.dsAccent
            DSTogglePalette.onGradient
          }
        } else {
          Color.dsTextSecondary
        }
      }
      .frame(width: trackWidth, height: trackHeight)
      .clipShape(Capsule())
      .overlay {
        Capsule()
          .stroke(
            isOn ? Color.dsAccent.opacity(0.35) : Color.dsBorderSubtle,
            lineWidth: 1
          )
      }

      Circle()
        .fill(Color.white)
        .shadow(color: Color.black.opacity(0.12), radius: 1, x: 0, y: 1)
        .frame(width: thumbSize, height: thumbSize)
        .padding(thumbPadding)
    }
    .frame(width: trackWidth, height: trackHeight)
  }
}

// MARK: - Gradient (aligned with DSButton)

private enum DSTogglePalette {
  static let onGradient = LinearGradient(
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

// MARK: - Previews

#Preview("Light") {
  DSTogglePreview()
    .preferredColorScheme(.light)
}

#Preview("Dark") {
  DSTogglePreview()
    .preferredColorScheme(.dark)
}

private struct DSTogglePreview: View {
  @State private var isOn = true

  var body: some View {
    VStack(alignment: .leading, spacing: DSSpacing.xl) {
      DSToggle(isOn: $isOn, label: "Demo")
    }
    .padding(DSSpacing.lg)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.dsBackgroundPrimary)
  }
}
