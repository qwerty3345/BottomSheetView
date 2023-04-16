//
//  CakeShopListViewController.swift
//  BottomSheetView_Example
//
//  Created by Mason Kim on 2023/04/15.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

final class ListViewController: UICollectionViewController {

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

extension ListViewController {
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

extension ListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = view.frame.width
    let height = CGFloat(200)
    return CGSize(width: width, height: height)
  }
}
