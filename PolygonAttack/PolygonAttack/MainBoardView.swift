//
//  MainBoardView.swift
//  PolygonAttack
//
//  Created by Field Employee on 4/1/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class MainBoardView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  //var theBoard: UICollectionViewController?
  @IBOutlet weak var collView: UICollectionView!
  
  // Data to be passed to MainBoardView from Character Selection
  // TODO: Change String to Character Class type once the class file has been implemented

  var player1CharData: [(name: Units?, xCoord: Int, yCoord: Int)] = []
  var player2CharData: [(name: Units?, xCoord: Int, yCoord: Int)] = []
  
  var stdBgColors = [UIColor.cyan, UIColor.green]
  
  let rowsPerPlayer = 2
  let squaresPerRow = 3
  
  // MARK - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // MARK - Forming Layout
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let tileSizeWidth: CGFloat = (self.view.frame.width / CGFloat(squaresPerRow))
    layout.estimatedItemSize = CGSize(width: tileSizeWidth, height: tileSizeWidth)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    collView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "mainBoardCell")
    collView.collectionViewLayout = layout
    collView.delegate = self
    collView.dataSource = self

    //baked charlocationdata for testing
   // player1CharData = [("test", 1, 2), ("sample",2,0), ("another one",2,1)]
   // player2CharData = [("triangle", 2, 2)]
  }
  
  func collectionView(in collectionView: UICollectionView) -> Int {
    return 2 * rowsPerPlayer
  }
 
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2 * rowsPerPlayer * squaresPerRow
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainBoardCell", for: indexPath)
    cell.backgroundColor = .clear
    cell.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
    cell.layer.borderWidth = 2
    
    if (isPlayer1Cell(indexPath: indexPath)) {
      cell.backgroundColor = stdBgColors[0]
    } else {
      cell.backgroundColor = stdBgColors[1]
    }
    
    for index in 0..<player1CharData.count {
      if ((indexPath.row / squaresPerRow == player1CharData[index].yCoord) && (indexPath.row % squaresPerRow == player1CharData[index].xCoord)) {
        print("TEST \(player1CharData[index].xCoord)")
        cell.backgroundColor = .red
      }
    }
    
    for index in 0..<player2CharData.count {
      if ((indexPath.row / squaresPerRow == player2CharData[index].yCoord) && (indexPath.row % squaresPerRow == player2CharData[index].xCoord)) {
        cell.backgroundColor = .red
      }
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    return indexPath.row < (rowsPerPlayer * squaresPerRow)
  }
  
  func cellHasUnit(indexPath: IndexPath) -> Bool {
    return collView.cellForItem(at: indexPath)?.backgroundColor == .red
  }
  
  // friendly fire currently exists btw
  func attack(player: Int, from initLocation: IndexPath) {
    var currAttackLocation: Int = initLocation.row
    var increment: Int = -squaresPerRow
    if (player == 1) {
      increment = squaresPerRow
    }
    
    currAttackLocation += increment
    while ((currAttackLocation > 0) && (currAttackLocation < (2 * rowsPerPlayer * squaresPerRow))) {
      let currIndexPath = IndexPath(row: currAttackLocation, section: 0)
      if cellHasUnit(indexPath: currIndexPath) {
        // unit was attacked
        let attackedUnitCell = collView.cellForItem(at: currIndexPath)
        var attackedPlayer = 2
        if (isPlayer1Cell(indexPath: currIndexPath)) {
          attackedPlayer = 1
        }
        attackedUnitCell?.backgroundColor = stdBgColors[attackedPlayer - 1]
        break
      }
      currAttackLocation += increment
    }
    
    
  }
}
