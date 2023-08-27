//
//  String.swift
//  Promise
//
//  Created by dylan on 2023/07/31.
//

import Foundation

extension String {
    func localized(comment: String = "") -> String {
    return NSLocalizedString(self, value: self, comment: comment)
  }

  func localized(with argument: CVarArg, comment: String = "") -> String {
    return String(format: self.localized(comment: comment), argument)
  }
}
