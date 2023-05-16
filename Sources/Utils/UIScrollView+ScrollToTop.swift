//
//  UIScrollView+ScrollToTop.swift
//  BottomSheetView
//
//  Created by 이승기 on 2023/05/16.
//

import UIKit

extension UIScrollView {
  func scrollToTop() {
    let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
    setContentOffset(desiredOffset, animated: true)
  }
}
