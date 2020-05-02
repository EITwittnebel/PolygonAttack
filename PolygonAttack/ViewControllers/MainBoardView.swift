//
//  MainBoardView.swift
//  PolygonAttack
//
//  Created by Field Employee on 4/1/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class MainBoardView: UIViewController {
  
  var player1CharData: [(name: Units?, xCoord: Int, yCoord: Int)] = []
  var player2CharData: [(name: Units?, xCoord: Int, yCoord: Int)] = []
  var boardView: BoardView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  func configureView() {
    configureBoard()
    //configureLabel()
  }
  /*
  func configureLabel() {
    let playerTurnLabel = UILabel(frame: CGRect(x: 0, y: 0, width: <#T##CGFloat#>, height: <#T##CGFloat#>))
    playerTurnLabel.
  }*/
  
  func configureBoard() {
    let sideMargin = CGFloat(32)
    let boardWidth = view.safeAreaLayoutGuide.layoutFrame.width - sideMargin * 2
    let boardHeight = boardWidth / CGFloat(Settings.boardXPieces) * CGFloat(Settings.boardYPieces)
    boardView = BoardView(frame: CGRect(x: 0, y: 0, width: boardWidth, height: boardHeight))
    view.addSubview(boardView)
    boardView.translatesAutoresizingMaskIntoConstraints = false
    boardView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    boardView.widthAnchor.constraint(equalToConstant: boardWidth).isActive = true
    boardView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    boardView.heightAnchor.constraint(equalToConstant: boardHeight).isActive = true
    boardView.backgroundColor = .clear
    
    for rows in boardView.boardCellArr {
      for item in rows {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewPressed))
        item.addGestureRecognizer(gesture)
      }
    }

  }
  
  @objc func viewPressed() {
    print("test")
  }
  
}
  
  // Data to be passed to MainBoardView from Character Selection
  // TODO: Change String to Character Class type once the class file has been implemented
/*
  
  var stdBgColors = [UIColor.cyan, UIColor.green]
  
  let rowsPerPlayer = 3
  let squaresPerRow = 3
  
  
  
  // MARK - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // MARK - Forming Layout
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    
    let desiredWidth: CGFloat = (view.frame.width / CGFloat(squaresPerRow))
    let desiredHeight: CGFloat = (view.frame.height / CGFloat(2 * rowsPerPlayer))
    let tileSizeWidth: CGFloat = min(desiredWidth, desiredHeight)
    layout.estimatedItemSize = CGSize(width: tileSizeWidth, height: tileSizeWidth)
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    
    collView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "mainBoardCell")
    collView.collectionViewLayout = layout

    //baked charlocationdata for testing
    //player1CharData = [("test", 1, 2), ("sample",2,0), ("another one",2,1)]
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
    cell.layer.borderWidth = 1
    
    if (isPlayer1Cell(indexPath: indexPath)) {
      cell.backgroundColor = stdBgColors[0]
    } else {
      cell.backgroundColor = stdBgColors[1]
    }
    
    for index in 0..<player1CharData.count {
      if ((indexPath.row / squaresPerRow == player1CharData[index].yCoord) && (indexPath.row % 3 == player1CharData[index].xCoord)) {
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
*/
