//
//  MainBoardView.swift
//  PolygonAttack
//
//  Created by Field Employee on 4/1/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class MainBoardView: UICollectionViewController {
  
  //var theBoard: UICollectionViewController?
  
  // Data to be passed to MainBoardView from Character Selection
  // TODO: Change String to Character Class type once the class file has been implemented

  var player1CharData: [(name: String, xCoord: Int, yCoord: Int)] = []
  var player2CharData: [(name: String, xCoord: Int, yCoord: Int)] = []
  
  var stdBgColors = [UIColor.cyan, UIColor.green]
  
  private var collectionview: UICollectionView!
  
  let rowsPerPlayer = 2
  let colsPerPlayer = 3
  
  // MARK - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // MARK - Forming Layout
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let tileSizeWidth: CGFloat = (self.view.frame.width / CGFloat(colsPerPlayer))
    layout.estimatedItemSize = CGSize(width: tileSizeWidth, height: tileSizeWidth)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "mainBoardCell")
    collectionView.collectionViewLayout = layout
    
    
    //baked charlocationdata for testing
    player1CharData = [("test", 1, 2), ("sample",2,0)]
    player2CharData = [("triangle", 2, 2)]
  }

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 2 * rowsPerPlayer
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return colsPerPlayer
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainBoardCell", for: indexPath)
    cell.backgroundColor = .clear
    cell.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    cell.layer.borderWidth = 2
    
    if (isPlayer1Cell(indexPath: indexPath)) {
      cell.backgroundColor = .cyan
    } else {
      cell.backgroundColor = .green
    }
    
    for index in 0..<player1CharData.count {
      if ((indexPath.section == player1CharData[index].yCoord) && (indexPath.row == player1CharData[index].xCoord)) {
        cell.backgroundColor = .red
      }
    }
    
    for index in 0..<player2CharData.count {
      if ((indexPath.section == player2CharData[index].yCoord) && (indexPath.row == player2CharData[index].xCoord)) {
        cell.backgroundColor = .red
      }
    }
    
    return cell
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if cellHasUnit(indexPath: indexPath) {
      if isPlayer1Cell(indexPath: indexPath) {
        attack(player: 1, from: indexPath)
      } else {
        attack(player: 2, from: indexPath)
      }
    }
  }
  
}

extension MainBoardView {
  func isPlayer1Cell(indexPath: IndexPath) -> Bool {
    return indexPath.section < rowsPerPlayer && indexPath.row < colsPerPlayer
  }
  
  func cellHasUnit(indexPath: IndexPath) -> Bool {
    return collectionView.cellForItem(at: indexPath)?.backgroundColor == .red
  }
  
  // friendly fire currently exists btw
  func attack(player: Int, from initLocation: IndexPath) {
    var currAttackLocation: Int = initLocation.section
    var pastEndOfBoard: Int = -1
    var increment: Int = -1
    if (player == 1) {
      pastEndOfBoard = collectionView.numberOfSections
      increment = 1
    }
    
    
    currAttackLocation += increment
    while (currAttackLocation != pastEndOfBoard) {
      let currIndexPath = IndexPath(row: initLocation.row, section: currAttackLocation)
      if cellHasUnit(indexPath: currIndexPath) {
        // unit was attacked
        let attackedUnitCell = collectionView.cellForItem(at: currIndexPath)
        attackedUnitCell?.backgroundColor = stdBgColors[2 - player]
        break
      }
      currAttackLocation += increment
    }
    
    
  }
}
