//
//  UIView+RemoveSubviews.swift
//  BottomSheetView
//
//  Created by Mason Kim on 2023/05/16.
//

import UIKit

extension UIView {
  public func removeSubviews() {
    subviews.forEach {
      $0.removeFromSuperview()
    }
  }
}
