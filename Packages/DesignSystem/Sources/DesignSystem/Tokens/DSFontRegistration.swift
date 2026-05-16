//
//  DSFontRegistration.swift
//  DesignSystem
//

import CoreText
import Foundation

enum DSFontRegistration {
  private static var didRegister = false
  private static let lock = NSLock()

  static func registerIfNeeded() {
    lock.lock()
    defer { lock.unlock() }
    guard !didRegister else { return }
    didRegister = true

    // Only the variable font — static Regular/Bold .ttf files register the same
    // PostScript names and trigger GSFont "already exists" console warnings.
    guard
      let url = Bundle.module.url(
        forResource: "Roboto-VariableFont_wdth,wght",
        withExtension: "ttf"
      )
    else {
      return
    }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }
}
