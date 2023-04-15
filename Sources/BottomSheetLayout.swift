//
//  BottomSheetLayout.swift
//  
//
//  Created by Mason Kim on 2023/04/15.
//

import UIKit

public protocol BottomSheetLayout {
  func anchoring(of position: BottomSheetPosition) -> BottomSheetAnchoring
  var thresholdFraction: CGFloat { get }
}

public enum BottomSheetAnchoring {
  case absolute(CGFloat)
  case fractional(CGFloat)

  func topAnchor(with parentViewController: UIViewController) -> CGFloat {
    switch self {
    case .absolute(let value):
      return abs(value - parentViewController.view.frame.height)
    case .fractional(let value):
      return abs(value * parentViewController.view.frame.height - parentViewController.view.frame.height)
    }
  }

  func height(with parentViewController: UIViewController) -> CGFloat {
    switch self {
    case .absolute(let value):
      return value
    case .fractional(let value):
      return value * parentViewController.view.frame.height
    }
  }
}

public struct DefaultBottomSheetLayout: BottomSheetLayout {
  public func anchoring(of position: BottomSheetPosition) -> BottomSheetAnchoring {
    switch position {
    case .full:
      return BottomSheetAnchoring.fractional(1.0)
    case .half:
      return BottomSheetAnchoring.absolute(320)
    case .tip:
      return BottomSheetAnchoring.fractional(0.2)
    }
  }

  public var thresholdFraction: CGFloat = 0.6
}
