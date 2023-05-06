//
//  BottomSheetGrabberAppearance.swift
//  BottomSheetView
//
//  Created by Mason Kim on 2023/05/06.
//

import Foundation

public struct BottomSheetGrabberAppearance {
  
  // MARK: - Properties
  
  public var backgroundColor: UIColor
  public var width: CGFloat
  public var height: CGFloat
  public var containerHeight: CGFloat
  public var cornerRadius: CGFloat
  
  // MARK: - Initializers
  
  public init(
    backgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.7),
    width: CGFloat = 32,
    height: CGFloat = 6,
    containerHeight: CGFloat = 30,
    cornerRadius: CGFloat = 3
  ) {
    self.backgroundColor = backgroundColor
    self.width = width
    self.height = height
    self.containerHeight = containerHeight
    self.cornerRadius = cornerRadius
    }
}
