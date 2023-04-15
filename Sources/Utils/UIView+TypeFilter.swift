//
//  UIView+TypeFilter.swift
//  
//
//  Created by Mason Kim on 2023/04/15.
//

import UIKit

extension UIView {
//  func subViews<SomeView: UIView>(ofType type: SomeView.Type) -> [SomeView] {
//    subviews.compactMap {
//      $0 as? SomeView
//    }
//  }

  func firstView<SomeView: UIView>(ofType type: SomeView.Type) -> SomeView? {
    return subviews.first(where: { $0 is SomeView }) as? SomeView
  }
}
