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
  public var backgroundColor: UIColor = .white
  public var bottomSheetCornerRadius: CGFloat = 20

  /// Grabber
  public var grabberBackgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.7)
  public var grabberWidth: CGFloat = 32
  public var grabberHeight: CGFloat = 6

  /// Settings
  public var isContentScrollViewBouncingWhenScrollDown: Bool = true
  
  
  // MARK: - Initializers
  
  public init(
    backgroundColor: UIColor = .white,
    bottomSheetCornerRadius: CGFloat = 20,
    grabberBackgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.7),
    grabberWidth: CGFloat = 32,
    grabberHeight: CGFloat = 6,
    isContentScrollViewBouncingWhenScrollDown: Bool = true
  ) {
    self.backgroundColor = backgroundColor
    self.bottomSheetCornerRadius = bottomSheetCornerRadius
    self.grabberBackgroundColor = grabberBackgroundColor
    self.grabberWidth = grabberWidth
    self.grabberHeight = grabberHeight
    self.isContentScrollViewBouncingWhenScrollDown = isContentScrollViewBouncingWhenScrollDown
  }
}
