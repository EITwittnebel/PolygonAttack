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
  let stdBgColors = [UIColor.cyan, UIColor.green]
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
      boardView.boardCellArr[char.xCoord][char.yCoord].unitToDraw = 1
      boardView.boardCellArr[char.xCoord][char.yCoord].drawUnit(index: char.imageIndex)
    }
    for char in player2CharData {
      boardView.boardCellArr[char.xCoord][char.yCoord].unitToDraw = 1
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
  
  @objc func viewPressed(sender: Any) {
    if let recognizer = sender as? UITapGestureRecognizer {
      if let cell = recognizer.view as? BoardCell {
        if cell.cellUnit != .none {
          openActionMenu(cell: cell)
        } else {
          if (pieceToMove != nil) {
            move(piece: &pieceToMove!, to: cell)
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
    
    let moveAction = UIAlertAction(title: "Move", style: .default, handler:  {
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
    actionAlert.addAction(attackAction)
    actionAlert.addAction(moveAction)
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
    
    currAttackLocation.1 += increment
    while ((currAttackLocation.1 >= 0) && (currAttackLocation.1 < (2 * rowsPerPlayer))) {
      if boardView.cellHasUnit(xCoordinate: currAttackLocation.0, yCoordinate: currAttackLocation.1) {
        // unit was attacked
        let attackedUnitCell = boardView.boardCellArr[currAttackLocation.0][currAttackLocation.1]
        //change this if you want to avoid friendly fire
        //let attackedPlayer = boardView.checkCellOwner(cellCood: currAttackLocation) + 1
        attackedUnitCell.removePiece()
        break
      }
      currAttackLocation.1 += increment
    }
    turnEnd()
  }
  
  func turnEnd() {
    playerTurn = 3 - playerTurn
    playerTurnLabel!.text = "Player \(playerTurn)'s turn"
  }
}
