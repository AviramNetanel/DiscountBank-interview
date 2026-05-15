//
//  BankUser.swift
//  DiscountBank-interview
//

import Foundation

struct BankUser: Hashable, Sendable {
  var firstName: String

  var greeting: String {
    "Hello, \(firstName)"
  }
}
