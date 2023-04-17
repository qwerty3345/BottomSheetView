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

  // MARK: - UI

  let bottomSheetView = BottomSheetView()

  let mapView = MKMapView()

  /// ✨ Examples : you can unmark line to show how certain style works
  let contentViewController = ListViewController(collectionViewLayout: UICollectionViewFlowLayout())
//  let contentViewController = GridViewController(collectionViewLayout: UICollectionViewFlowLayout())
//  let contentViewController = UIViewController()

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  

  // MARK: - Private

  private func setup() {
    setupLayout()
    setupView()
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
  
  private func setupView() {
    setupMapView()
    setupBottomSheet()
  }
  
  private func setupMapView() {
    mapView.delegate = self
  }
  
  private func setupBottomSheet() {
    bottomSheetView.configure(parentViewController: self, contentViewController: contentViewController)
  }
}

extension MainViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    bottomSheetView.move(to: .tip)
  }
}
