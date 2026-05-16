//
//  TransactionPeriodFilter.swift
//  DiscountBank-interview
//

import Foundation

enum TransactionPeriodFilter: String, CaseIterable, Identifiable {
  case oneMonth = "1 month"
  case threeMonths = "3 months"
  case sixMonths = "6 months"
  case oneYear = "1 year"
  case max = "Max"

  var id: String { rawValue }

  var menuLabel: String { rawValue }

  func includes(date: Date, relativeTo now: Date = Date(), calendar: Calendar = .current) -> Bool {
    guard let cutoff = cutoffDate(relativeTo: now, calendar: calendar) else {
      return true
    }
    return date >= cutoff
  }

  private func cutoffDate(relativeTo now: Date, calendar: Calendar) -> Date? {
    switch self {
    case .oneMonth:
      return calendar.date(byAdding: .month, value: -1, to: now)
    case .threeMonths:
      return calendar.date(byAdding: .month, value: -3, to: now)
    case .sixMonths:
      return calendar.date(byAdding: .month, value: -6, to: now)
    case .oneYear:
      return calendar.date(byAdding: .year, value: -1, to: now)
    case .max:
      return nil
    }
  }
}
