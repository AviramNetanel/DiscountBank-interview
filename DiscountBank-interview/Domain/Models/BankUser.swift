//
//  BankUser.swift
//  DiscountBank-interview
//

import Foundation

struct BankUser: Hashable, Sendable {
  var firstName: String
  var lastName: String

  var fullName: String {
    "\(firstName) \(lastName)"
  }

  var greeting: String {
    "Hello, \(firstName)"
  }
}
