//
//  BottomSheetLayout.swift
//  
//
//  Created by Mason Kim on 2023/04/15.
//

import Foundation

public protocol BottomSheetLayout {
  var bottomSheetPositions: [BottomSheetPosition : BottomSheetAnchoring] { get }
  var thresholdFraction: CGFloat { get }
}

public struct BottomSheetAnchoring {
  public var height: CGFloat?
  public var fractional: CGFloat?
}

public struct DefaultBottomSheetLayout: BottomSheetLayout {
  public var bottomSheetPositions: [BottomSheetPosition : BottomSheetAnchoring] = [
    .full: BottomSheetAnchoring(fractional: 1.0),
    .tip: BottomSheetAnchoring(height: 320)
  ]
  public var thresholdFraction: CGFloat = 0.6
}
