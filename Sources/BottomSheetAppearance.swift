//
//  BottomSheetAppearance.swift
//  BottomSheetView
//
//  Created by Mason Kim on 2023/04/15.
//

import UIKit

public struct BottomSheetAppearance {
    /// Bases
  public var backgroundColor: UIColor = .white
  public var bottomSheetCornerRadius: CGFloat = 20

    /// Grabber
  public var grabberBackgroundColor: UIColor = UIColor.lightGray.withAlphaComponent(0.5)
  public var grabberWidth: CGFloat = 32
  public var grabberHeight: CGFloat = 6
}
