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
  
  /// Shadows
  public var shadowOffset: CGSize?
  public var shadowColor: CGColor?
  public var shadowPath: CGPath?
  public var shadowOpacity: Float?
  public var shadowRadius: CGFloat?

  /// Settings
  public var isContentScrollViewBouncingWhenScrollDown: Bool
  public var ignoreSafeArea: [SafeAreaLocation]
  
  
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
