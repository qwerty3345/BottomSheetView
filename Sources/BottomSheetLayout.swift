//
//  BottomSheetLayout.swift
//  
//
//  Created by Mason Kim on 2023/04/15.
//

import UIKit

public struct BottomSheetLayout {
  public private(set) var full: BottomSheetAnchoring
  public private(set) var half: BottomSheetAnchoring
  public private(set) var tip: BottomSheetAnchoring
  
  public func anchoring(of position: BottomSheetPosition) -> BottomSheetAnchoring {
    switch position {
    case .full:
      return full
    case .half:
      return half
    case .tip:
      return tip
    }
  }
  
  public init(full: BottomSheetAnchoring = .fractional(1.0),
              half: BottomSheetAnchoring = .absolute(320),
              tip: BottomSheetAnchoring = .absolute(100)) {
    self.full = full
    self.half = half
    self.tip = tip
  }
}

public enum BottomSheetAnchoring {
  case absolute(CGFloat)
  case fractional(CGFloat)

  public func topAnchor(with parentViewController: UIViewController) -> CGFloat {
    switch self {
    case .absolute(let value):
      return abs(value - parentViewController.view.frame.height)
    case .fractional(let value):
      return abs(value * parentViewController.view.frame.height - parentViewController.view.frame.height)
    }
  }

  public func height(with parentViewController: UIViewController) -> CGFloat {
    switch self {
    case .absolute(let value):
      return value
    case .fractional(let value):
      return value * parentViewController.view.frame.height
    }
  }
}
