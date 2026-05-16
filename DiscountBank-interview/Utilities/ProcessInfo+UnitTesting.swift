//
//  ProcessInfo+UnitTesting.swift
//  DiscountBank-interview
//

import Foundation

extension ProcessInfo {
  /// True when the app is loaded as the host for an XCTest bundle.
  static var isUnitTesting: Bool {
    processInfo.environment["XCTestConfigurationFilePath"] != nil
  }
}
