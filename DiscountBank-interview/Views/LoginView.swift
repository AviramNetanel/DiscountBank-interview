//
//  LoginView.swift
//  DiscountBank-interview
//

import DesignSystem
import SwiftUI

struct LoginView: View {
  @Binding var isLoggedIn: Bool
  @State private var username: String = ""
  @State private var password: String = ""
  @State private var isDemoOn : Bool = true
  @FocusState private var focusedField: Field?

  
  private enum Field {
    case username
    case password
  }

  var body: some View {
    ScrollView(.vertical) {
      VStack(alignment: .leading, spacing: DSSpacing.xxl) {
          Image("discountBankLogo")
            .resizable()
            .scaledToFit()
            .frame(width: 100)
            .frame(maxWidth: .infinity,
                   alignment: .center)
            .accessibilityLabel("Discount Bank logo")
        
        VStack(alignment: .leading, spacing: DSSpacing.sm) {
          HStack{
            Text("Sign in")
              .font(DSTypography.largeTitle)
              .foregroundStyle(Color.dsTextPrimary)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: DSSpacing.xs) {
              DSToggle(isOn: $isDemoOn)
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

              TextField("Username", text: $username)
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

              SecureField("Password", text: $password)
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
            isEnabled: !usernameTrimmed.isEmpty && isDemoOn
          ) {
            signIn()
          }
          .accessibilityHint("Opens your accounts.")
          
          DSButton(title: "Forgot Password?",
                   style: .ghost,
                   action: {

          }
          )
        }

        Spacer(minLength: DSSpacing.xxxl)
      }
      .padding(DSSpacing.lg)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.dsBackgroundPrimary)
    .scrollDismissesKeyboard(.interactively)
  }

  private var usernameTrimmed: String {
    username.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
  }

  private var passwordTrimmed: String {
    password.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
  }

  private func fieldLabel(_ text: String) -> some View {
    Text(text.uppercased())
      .font(DSTypography.captionMedium)
      .foregroundStyle(Color.dsTextSecondary)
  }

  private func signIn() {
    guard !usernameTrimmed.isEmpty && isDemoOn else { return }
    focusedField = nil
    isLoggedIn = true
  }
}


//MARK: -
#Preview("Light") {
  LoginView(isLoggedIn: .constant(false))
    .preferredColorScheme(.light)
}

#Preview("Dark") {
  LoginView(isLoggedIn: .constant(false))
    .preferredColorScheme(.dark)
}
