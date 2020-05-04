//
//  MainBoardView.swift
//  PolygonAttack
//
//  Created by Field Employee on 4/1/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class MainBoardView: UIViewController {
  
  let squaresPerRow = Settings.boardXPieces
  let rowsPerPlayer = Settings.boardYPieces/2
  var player1CharData: [BoardUnit] = []
  var player2CharData: [BoardUnit] = []
  var boardView: BoardView!
  var playerTurn: Int = 1
  var player1CastleHp: Int = 2
  var player2CastleHp: Int = 2
  var pieceToMove: BoardUnit?
  var playerTurnLabel: UILabel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  func configureView() {
    configureBoard()
    setPieces()
    configureLabel()
  }
  
  func setPieces() {
    for char in player1CharData {
      boardView.boardCellArr[char.xCoord][char.yCoord].drawUnit(index: char.imageIndex)
    }
    for char in player2CharData {
      boardView.boardCellArr[char.xCoord][char.yCoord].drawUnit(index: char.imageIndex)
    }
  }
  
  func configureLabel() {
    playerTurnLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
    playerTurnLabel!.text = "Player \(playerTurn)'s turn"
    playerTurnLabel!.center.x = view.center.x
    playerTurnLabel!.center.y = 50
    playerTurnLabel!.textAlignment = .center
    view.addSubview(playerTurnLabel!)
  }
  
  func configureBoard() {
    let sideMargin = Settings.boardSideMargin
    let boardWidth = view.frame.width - sideMargin * 2
    let boardHeight = boardWidth / CGFloat(Settings.boardXPieces) * CGFloat(Settings.boardYPieces)
    boardView = BoardView(frame: CGRect(x: 0, y: 0, width: boardWidth, height: boardHeight))
    view.addSubview(boardView)
    boardView.translatesAutoresizingMaskIntoConstraints = false
    boardView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    boardView.widthAnchor.constraint(equalToConstant: boardWidth).isActive = true
    boardView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    boardView.heightAnchor.constraint(equalToConstant: boardHeight).isActive = true
    boardView.backgroundColor = .clear
    
    createCastleCells(aboveAndBelow: boardView, of: boardWidth / CGFloat(Settings.boardXPieces))
    
    for rows in boardView.boardCellArr {
      for item in rows {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewPressed))
        item.addGestureRecognizer(gesture)
      }
    }
  }
  
  @objc func viewPressed(sender: Any) {
    if let recognizer = sender as? UITapGestureRecognizer {
      if let cell = recognizer.view as? BoardCell {
        if (boardView.checkCellOwner(cellCood: cell.coordinates) == playerTurn - 1) {
          if cell.cellUnit != .none {
            openActionMenu(cell: cell)
          } else {
            if ((pieceToMove != nil) && (boardView.checkCellOwner(cellCood: cell.coordinates) == boardView.checkCellOwner(cellCood: (pieceToMove!.xCoord, pieceToMove!.yCoord)))){
              move(piece: &pieceToMove!, to: cell)
            }
            pieceToMove = nil
          }
        }
      }
    }
  }
  
  func openActionMenu(cell: BoardCell) {
    let actionAlert = UIAlertController(title: "Perform Action", message: "Select action to perform.", preferredStyle: .actionSheet)
    
    let attackAction = UIAlertAction(title: "Attack", style: .default, handler: {
      action in
      self.attack(from: cell)
    })
    
    let moveAction = UIAlertAction(title: "Move", style: .default, handler: {
      action in
      for item in self.player1CharData {
        if item.xCoord == cell.xCoordinate && item.yCoord == cell.yCoordinate {
          self.pieceToMove = item
          break
        }
      }
      for item in self.player2CharData {
        if item.xCoord == cell.xCoordinate && item.yCoord == cell.yCoordinate {
          self.pieceToMove = item
          break
        }
      }
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    
    actionAlert.addAction(attackAction)
    actionAlert.addAction(moveAction)
    actionAlert.addAction(cancelAction)
    present(actionAlert,animated: true)
  }
  
  func move(piece: inout BoardUnit, to destination: BoardCell) {
    boardView.boardCellArr[piece.xCoord][piece.yCoord].removePiece()
    piece.moveTo(cell: destination)
    turnEnd()
  }
  
  // friendly fire currently exists btw
  func attack(from initLocation: BoardCell) {
    let player = boardView.checkCellOwner(cellCood: initLocation.coordinates) + 1
    var currAttackLocation: (Int, Int) = (initLocation.xCoordinate, initLocation.yCoordinate)
    var increment: Int = -1
    if (player == 1) {
      increment = 1
    }
    
    var hitUnit: Bool = false
    currAttackLocation.1 += increment
    while ((currAttackLocation.1 >= 0) && (currAttackLocation.1 < (2 * rowsPerPlayer))) {
      if boardView.cellHasUnit(xCoordinate: currAttackLocation.0, yCoordinate: currAttackLocation.1) {
        // unit was attacked
        hitUnit = true
        let attackedUnitCell = boardView.boardCellArr[currAttackLocation.0][currAttackLocation.1]
        if (!Settings.friendlyFire) {
          let attackedPlayer = boardView.checkCellOwner(cellCood: currAttackLocation) + 1
          if (attackedPlayer == player) {
            // do nothing right now, maybe bypass the unit?
          } else {
            removePiece(atCell: attackedUnitCell)
          }
        } else {
          removePiece(atCell: attackedUnitCell)
        }
        break
      }
      currAttackLocation.1 += increment
    }
    
    // no unit was in the way, attack the enemy castle
    if (!hitUnit) {
      attackCastle(by: player)
    }
    
    turnEnd()
  }
  
  func removePiece(atCell: BoardCell) {
    for index in 0..<player1CharData.count {
      if (player1CharData[index].xCoord == atCell.xCoordinate && player1CharData[index].yCoord == atCell.yCoordinate) {
        player1CharData.remove(at: index)
        break
      }
    }
    for index in 0..<player2CharData.count {
      print(index)
      if (player2CharData[index].xCoord == atCell.xCoordinate && player2CharData[index].yCoord == atCell.yCoordinate) {
        player2CharData.remove(at: index)
        break
      }
    }
    atCell.removePiece()
  }
  
  func attackCastle(by player: Int) {
    if player == 1 {
      player2CastleHp -= 1
    } else {
      player1CastleHp -= 1
    }
  }
  
  func turnEnd() {
    if let winner = gameWinner() {
      playerTurnLabel!.text = "Player \(winner) won!"
    } else {
      playerTurn = 3 - playerTurn
      playerTurnLabel!.text = "Player \(playerTurn)'s turn"
    }
  }
  
  func gameWinner() -> Int? {
    if player1CharData.count == 0 || player1CastleHp <= 0 {
      return 2
    } else if player2CharData.count == 0 || player2CastleHp <= 0 {
      return 1
    }
    return nil
  }
  
  func createCastleCells(aboveAndBelow boardView: UIView, of height: CGFloat) {
    let castle0 = CastleCell(frame: .zero, image: UIImage(named: "castle-color"))
    castle0.highlightBorder(with: .black)
    view.addSubview(castle0)
    castle0.translatesAutoresizingMaskIntoConstraints = false
    castle0.leadingAnchor.constraint(equalTo: boardView.leadingAnchor).isActive = true
    castle0.trailingAnchor.constraint(equalTo: boardView.trailingAnchor).isActive = true
    castle0.bottomAnchor.constraint(equalTo: boardView.topAnchor).isActive = true
    castle0.heightAnchor.constraint(equalToConstant: height).isActive = true
    
    let castle1 = CastleCell(frame: .zero, image: UIImage(named: "castle-black"))
    castle1.highlightBorder(with: .black)
    view.addSubview(castle1)
    castle1.translatesAutoresizingMaskIntoConstraints = false
    castle1.trailingAnchor.constraint(equalTo: boardView.trailingAnchor).isActive = true
    castle1.leadingAnchor.constraint(equalTo: boardView.leadingAnchor).isActive = true
    castle1.topAnchor.constraint(equalTo: boardView.bottomAnchor).isActive = true
    castle1.heightAnchor.constraint(equalToConstant: height).isActive = true
  }
}
