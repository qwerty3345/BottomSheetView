//
//  BottomSheetAppearance.swift
//  BottomSheetView
//
//  Created by Mason Kim on 2023/04/15.
//

import UIKit

public struct BottomSheetAppearance {
  
  // MARK: - Properties
  
  /// Bases
  public var backgroundColor: UIColor
  public var bottomSheetCornerRadius: CGFloat

  /// Settings
  public var isContentScrollViewBouncingWhenScrollDown: Bool
  public var ignoreSafeArea: [SafeAreaLocation]
  public var fillSafeAreaWhenPositionAtFull = false
  
  
  // MARK: - Initializers
  
  public init(
    backgroundColor: UIColor = .white,
    bottomSheetCornerRadius: CGFloat = 20,
    isContentScrollViewBouncingWhenScrollDown: Bool = false,
    ignoreSafeArea: [SafeAreaLocation] = []
  ) {
    self.backgroundColor = backgroundColor
    self.bottomSheetCornerRadius = bottomSheetCornerRadius
    self.isContentScrollViewBouncingWhenScrollDown = isContentScrollViewBouncingWhenScrollDown
    self.ignoreSafeArea = ignoreSafeArea
  }
}

public enum SafeAreaLocation {
  case top
  case bottom
}
