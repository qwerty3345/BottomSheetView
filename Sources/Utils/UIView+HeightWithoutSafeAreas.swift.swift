//
//  UIView+HeightWithoutSafeAreas.swift
//  
//
//  Created by Mason Kim on 2023/04/15.
//

import UIKit

extension UIView {
  var heightWithoutSafeAreas: CGFloat {
    return frame.height - safeAreaInsets.top - safeAreaInsets.bottom
  }
}
