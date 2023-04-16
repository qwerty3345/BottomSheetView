//
//  GridViewController.swift
//  BottomSheetView_Example
//
//  Created by Mason Kim on 2023/04/16.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

final class GridViewController: UICollectionViewController {

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  // MARK: - Private

  private func setup() {
    setupLayout()
    setupCollectionView()
  }

  private func setupLayout() { }

  private func setupCollectionView() {
    collectionView?.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
  }

}

//MARK: - UICollectionViewDataSource

extension GridViewController {
  override func collectionView(_ collectionView: UICollectionView,
                               numberOfItemsInSection section: Int) -> Int {
    return 20
  }

  override func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath)
    cell.backgroundColor = .gray
    return cell
  }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension GridViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = view.frame.width / 2 - 10
    let height = width
    return CGSize(width: width, height: height)
  }
}
