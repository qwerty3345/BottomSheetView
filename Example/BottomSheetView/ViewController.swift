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

  let bottomSheetView = BottomSheetView(frame: .zero)

  let mapView = MKMapView()
  let cakeShopListViewController = CakeShopListViewController()

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  // MARK: - Public

  // MARK: - Private

  private func setup() {
    setupLayout()
    setupStyle()
    setupBottomSheet()
  }

  private func setupLayout() {
    view.addSubview(mapView)
    mapView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }

  private func setupStyle() {
    view.backgroundColor = .lightGray
  }

  private func setupBottomSheet() {
    bottomSheetView.configure(parentVC: self, contentVC: cakeShopListViewController)
  }

}
