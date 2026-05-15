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

    let extensions = ["ttf", "otf"]
    for ext in extensions {
      guard let urls = Bundle.module.urls(forResourcesWithExtension: ext, subdirectory: nil) else {
        continue
      }
      for url in urls {
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
      }
    }
  }
}
