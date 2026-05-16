//
//  KeyboardObserver.swift
//  DiscountBank-interview
//

import Combine
import UIKit

final class KeyboardObserver: ObservableObject {
  @Published var keyboardHeight: CGFloat = 0

  private var cancellables = Set<AnyCancellable>()

  init() {
    let willShow = NotificationCenter.default.publisher(
      for: UIResponder.keyboardWillShowNotification
    )
    .compactMap { notification -> CGFloat? in
      guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
      else { return nil }
      return frame.height
    }

    let willHide = NotificationCenter.default.publisher(
      for: UIResponder.keyboardWillHideNotification
    )
    .map { _ in CGFloat(0) }

    Publishers.Merge(willShow, willHide)
      .receive(on: RunLoop.main)
      .sink { [weak self] height in
        self?.keyboardHeight = height
      }
      .store(in: &cancellables)
  }
}
