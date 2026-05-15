//
//  ContentView.swift
//  DiscountBank-interview
//
//  Created by Aviram Netanel on 13/05/2026.
//

import DesignSystem
import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: DSSpacing.lg) {
                Text("Design system")
                    .font(DSTypography.largeTitle)
                    .foregroundStyle(Color.dsTextPrimary)

                DSAmountText(value: 9_900.15, coloring: .signedSemantic, prominent: true)

                Text("Smoke test: semantic colors, type scale, spacing, and radii adapt in light and dark mode.")
                    .font(DSTypography.body)
                    .foregroundStyle(Color.dsTextSecondary)

                HStack(spacing: DSSpacing.md) {
                    RoundedRectangle(cornerRadius: DSRadius.md)
                        .fill(Color.dsAccent)
                        .frame(width: 44, height: 44)
                        .accessibilityLabel("Accent swatch")
                    RoundedRectangle(cornerRadius: DSRadius.sm)
                        .fill(Color.dsSuccess)
                        .frame(width: 44, height: 44)
                        .accessibilityLabel("Success swatch")
                }

                DSCard {
                    VStack(alignment: .leading, spacing: DSSpacing.sm) {
                        Text("Headline")
                            .font(DSTypography.headline)
                            .foregroundStyle(Color.dsTextPrimary)
                        Text("Body emphasis")
                            .font(DSTypography.bodyEmphasis)
                            .foregroundStyle(Color.dsTextPrimary)
                        Text("Caption medium")
                            .font(DSTypography.captionMedium)
                            .foregroundStyle(Color.dsTextSecondary)
                    }
                }

                DSSectionHeader(title: "Components")

                DSListRow(
                    title: "Sample transaction",
                    subtitle: "DSCard · DSButton · DSListRow",
                    systemImage: "building.columns.fill",
                    trailingText: "-₪ 120.00",
                    showsDisclosure: true,
                    action: {}
                )

                DSButton(title: "Primary action", style: .primary) {}
                DSButton(title: "Secondary", style: .secondary) {}
            }
            .padding(DSSpacing.lg)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.dsBackgroundPrimary)
    }
}

#Preview("Light") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ContentView()
        .preferredColorScheme(.dark)
}
