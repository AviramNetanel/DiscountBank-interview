//
//  TransactionCategory.swift
//  DiscountBank-interview
//

import Foundation

enum TransactionCategory: String, CaseIterable, Identifiable, Hashable, Codable, Sendable {
  case dining
  case groceries
  case income
  case transfer
  case utilities
  case cash
  case health
  case insurance
  case housing
  case education

  var id: String { rawValue }

  var title: String {
    switch self {
    case .dining: return "Dining"
    case .groceries: return "Groceries"
    case .income: return "Income"
    case .transfer: return "Transfer"
    case .utilities: return "Utilities"
    case .cash: return "Cash"
    case .health: return "Health"
    case .insurance: return "Insurance"
    case .housing: return "Housing"
    case .education : return "Education"
    }
  }

  var systemImage: String {
    switch self {
    case .dining: return "fork.knife"
    case .groceries: return "cart.fill"
    case .income: return "arrow.down.circle.fill"
    case .transfer: return "arrow.left.arrow.right.circle.fill"
    case .utilities: return "bolt.fill"
    case .cash: return "banknote.fill"
    case .health: return "figure.run"
    case .insurance: return "car.fill"
    case .housing: return "house.fill"
    case .education: return "book"
    }
  }
}
