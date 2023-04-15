//
//  ViewController.swift
//  BottomSheetView
//
//  Created by qwerty3345 on 04/15/2023.
//  Copyright (c) 2023 qwerty3345. All rights reserved.
//

import UIKit
import MapKit

import BottomSheetView

class ViewController: UIViewController {


  // MARK: - Constants

  enum Metric { }

  // MARK: - Properties

  // MARK: - UI
  @IBOutlet weak var mapView: MKMapView!

  let bottomSheetView = BottomSheetView(frame: .zero)

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  // MARK: - Public

  // MARK: - Private

  private func setup() {
    setupLayout()
  }

  private func setupLayout() {
    view.addSubview(bottomSheetView)
    bottomSheetView.configure(parentVC: self, contentVC: ViewController())
  }

}

