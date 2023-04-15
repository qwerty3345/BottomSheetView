//
//  UIView+SpringAnimation.swift
//  
//
//  Created by Mason Kim on 2023/04/15.
//

import UIKit

extension UIView {
  static func animateWithSpring(animation: @escaping () -> Void,
                                completion: ((Bool) -> Void)? = nil) {
    UIView.animate(
      withDuration: 0.45,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0.8,
      options: [.allowUserInteraction],
      animations: {
        animation()
      },
      completion: { bool in
        completion?(bool)
      }
    )
  }
}
