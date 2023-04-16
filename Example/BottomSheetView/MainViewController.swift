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

class MainViewController: UIViewController {


  // MARK: - Constants

  enum Metric { }

  // MARK: - Properties

  // MARK: - UI

  let bottomSheetView = BottomSheetView()

  let mapView = MKMapView()

  /// ✨ Examples : you can unmark line to show how certain style works
  let contentViewContoller = ListViewController(collectionViewLayout: UICollectionViewFlowLayout())
//  let contentViewContoller = GridViewController(collectionViewLayout: UICollectionViewFlowLayout())
//  let contentViewContoller = UIViewController()

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  // MARK: - Private

  private func setup() {
    setupLayout()
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

  private func setupBottomSheet() {
    bottomSheetView.configure(parentViewController: self, contentViewController: contentViewContoller)
  }

}
