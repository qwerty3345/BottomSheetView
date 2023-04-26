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

  /// Grabber
  public var grabberBackgroundColor: UIColor
  public var grabberWidth: CGFloat
  public var grabberHeight: CGFloat
  public var grabberContainerHeight: CGFloat
  public var grabberCornerRadius: CGFloat

  /// Settings
  public var isContentScrollViewBouncingWhenScrollDown: Bool
  
  
  // MARK: - Initializers
  
  public init(
    backgroundColor: UIColor = .white,
    bottomSheetCornerRadius: CGFloat = 20,
    grabberBackgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.7),
    grabberWidth: CGFloat = 32,
    grabberHeight: CGFloat = 6,
    grabberContainerHeight: CGFloat = 30,
    grabberCornerRadius: CGFloat = 3,
    isContentScrollViewBouncingWhenScrollDown: Bool = false
  ) {
    self.backgroundColor = backgroundColor
    self.bottomSheetCornerRadius = bottomSheetCornerRadius
    self.grabberBackgroundColor = grabberBackgroundColor
    self.grabberWidth = grabberWidth
    self.grabberHeight = grabberHeight
    self.grabberContainerHeight = grabberContainerHeight
    self.grabberCornerRadius = grabberCornerRadius
    self.isContentScrollViewBouncingWhenScrollDown = isContentScrollViewBouncingWhenScrollDown
  }
}
