//
//  LoginView.swift
//  DiscountBank-interview
//

import DesignSystem
import SwiftUI

struct LoginView: View {
  @Binding var isLoggedIn: Bool
  @State private var viewModel: LoginViewModel
  @FocusState private var focusedField: Field?
  @StateObject private var keyboard = KeyboardObserver()

  private enum Field {
    case username
    case password
  }

  init(isLoggedIn: Binding<Bool>, bankStore: BankStore) {
    _isLoggedIn = isLoggedIn
    _viewModel = State(
      initialValue: LoginViewModel(
        bankStore: bankStore,
        onSignIn: { isLoggedIn.wrappedValue = true }
      )
    )
  }

  var body: some View {
    @Bindable var viewModel = viewModel

    ScrollView(.vertical) {
      VStack(alignment: .leading, spacing: DSSpacing.xxl) {
        Image("discountBankLogo")
          .resizable()
          .scaledToFit()
          .frame(width: 100)
          .frame(maxWidth: .infinity, alignment: .center)
          .accessibilityLabel("Discount Bank logo")

        VStack(alignment: .leading, spacing: DSSpacing.sm) {
          HStack {
            Text("Sign in")
              .font(DSTypography.largeTitle)
              .foregroundStyle(Color.dsTextPrimary)

            Spacer()

            VStack(alignment: .trailing, spacing: DSSpacing.xs) {
              DSToggle(isOn: $viewModel.isDemoOn)
              Text("Demo Account")
                .font(DSTypography.subheadline)
                .foregroundStyle(Color.dsTextSecondary)
            }
          }
        }

        VStack(alignment: .leading, spacing: DSSpacing.lg) {
          DSCard {
            VStack(alignment: .leading, spacing: DSSpacing.md) {
              fieldLabel("Username")

              TextField("Username", text: $viewModel.username)
                .focused($focusedField, equals: .username)
                .textContentType(.username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .font(DSTypography.body)
                .foregroundStyle(Color.dsTextPrimary)
                .padding(DSSpacing.md)
                .background(Color.dsBackgroundPrimary)
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.sm))
                .overlay(
                  RoundedRectangle(cornerRadius: DSRadius.sm)
                    .stroke(Color.dsBorderSubtle, lineWidth: 1)
                )

              fieldLabel("Password")

              SecureField("Password", text: $viewModel.password)
                .focused($focusedField, equals: .password)
                .textContentType(.password)
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

          DSButton(
            title: "Sign in",
            style: .primary,
            isEnabled: viewModel.canSignIn
          ) {
            focusedField = nil
            viewModel.signIn()
          }
          .accessibilityHint("Opens your accounts.")

          DSButton(title: "Forgot Password?", style: .ghost) {
            focusedField = nil
            viewModel.forgotPasswordTapped()
          }
        }

        Spacer(minLength: DSSpacing.xxxl)
      }
      .padding(DSSpacing.lg)
    }
    .scrollDisabled(true)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .offset(y: keyboard.keyboardHeight > 0 ? -150 : 0)
    .animation(.easeInOut(duration: 0.25), value: keyboard.keyboardHeight)
    .background(Color.dsBackgroundPrimary)
    .alert("Forgot Password?", isPresented: $viewModel.showsForgotPasswordAlert) {
      Button("OK", role: .cancel) {}
    } message: {
      Text("bummer...")
    }
  }

  private func fieldLabel(_ text: String) -> some View {
    Text(text.uppercased())
      .font(DSTypography.captionMedium)
      .foregroundStyle(Color.dsTextSecondary)
  }
}

// MARK: - Preview

#Preview("Light") {
  LoginView(isLoggedIn: .constant(false), bankStore: BankStore())
    .preferredColorScheme(.light)
}

#Preview("Dark") {
  LoginView(isLoggedIn: .constant(false), bankStore: BankStore())
    .preferredColorScheme(.dark)
}
