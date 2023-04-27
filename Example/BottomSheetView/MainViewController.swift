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

final class MainViewController: UIViewController {

  // MARK: - UI

  private let bottomSheetView = BottomSheetView()

  private let mapView = MKMapView()

  /// ✨ Examples : you can unmark line to show how certain style works
  private let contentViewController = ListViewController(
    collectionViewLayout: UICollectionViewFlowLayout()
  )
//  private let contentViewController = GridViewController(
//    collectionViewLayout: UICollectionViewFlowLayout()
//  )
//  private let contentViewController = UIViewController()

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
      self.bottomSheetView.move(to: .absolute(50))
    }
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
    bottomSheetView.delegate = self
    
    setupBottomSheetLayout()
    setupBottomSheetAppearance()
  }
  
  private func setupBottomSheetLayout() {
    let layout = BottomSheetLayout(
      full: .fractional(1.0),
      half: .fractional(0.7),
      tip: .fractional(0)
    )
    bottomSheetView.layout = layout
  }
  
  private func setupBottomSheetAppearance() {
    bottomSheetView.appearance = BottomSheetAppearance(
      grabberBackgroundColor: .black,
      grabberWidth: 100,
      grabberHeight: 8,
      grabberCornerRadius: 4,
      ignoreSafeArea: [.bottom]
    )
  }
}


// MARK: - BottomSheetViewDelegate

extension MainViewController: BottomSheetViewDelegate {
  
  func bottomSheetView(_ bottomSheetView: BottomSheetView,
                       willMoveTo destination: BottomSheetPosition,
                       from startPosition: BottomSheetPosition) {
    print("✨ willMove: \(destination), from: \(startPosition)")
    print(bottomSheetView.layout.anchoring(of: destination).height(with: self))
    print(bottomSheetView.layout.anchoring(of: destination).topAnchor(with: self))
  }
  
  func bottomSheetView(_ bottomSheetView: BottomSheetView,
                       didMoveTo destination: BottomSheetPosition,
                       from startPosition: BottomSheetPosition) {
    print("✨ didMove: \(destination), from: \(startPosition)")
  }
  
}


// MARK: - MKMapViewDelegate

extension MainViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
    bottomSheetView.move(to: .tip)
  }
}
