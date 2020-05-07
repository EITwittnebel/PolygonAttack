//
//  MainBoardView.swift
//  PolygonAttack
//
//  Created by Field Employee on 4/1/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import AVFoundation

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
  var pieceToHeal: Healer?
  var pieceToAttack: Attacker?
  var playerTurnLabel: UILabel?
  var tempCells: [BoardCell] = []
  var tempHealCells: [BoardCell] = []
  var sword: UIImageView?
  var soundPlayer: AVAudioPlayer?

  
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
    sword = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    sword?.center.x = view.center.x
    sword?.center.y = 50
    sword?.image = UIImage(named: "CartoonSword-1")
    sword?.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0)
    sword?.isHidden = true
    view.addSubview(sword!)
  }
  
  func configureLabel() {
    playerTurnLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
    playerTurnLabel!.text = "Player \(playerTurn)'s turn"
    playerTurnLabel!.center.x = view.center.x
    playerTurnLabel!.center.y = boardView.boardCellArr[0][0].frame.width
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
            if (cell.backgroundColor == .green && pieceToHeal != nil) {
              heal(location: cell)
              pieceToHeal = nil
            } else {
              openActionMenu(cell: cell)
            }
          } else if (cell.backgroundColor != .green) {
          } else {
            if (pieceToMove != nil) {
              move(piece: &pieceToMove!, to: cell)
            }
          }
          pieceToMove = nil
        } else {
          if (cell.backgroundColor == .red && pieceToAttack != nil) {
            playAttackAudio((pieceToAttack as! BoardUnit).name)
            animateAttackFrom(piece: pieceToAttack as! BoardUnit, to: cell)
            attack(location: cell)
            pieceToAttack = nil
          }
        }
      }
    }
    clearTempCells()
    clearTempHealCells()
  }
  
  func animateAttackFrom(piece: BoardUnit, to dest: BoardCell) {
    
    let boardMinX = dest.superview!.frame.minX
    let boardMinY = dest.superview!.frame.minY
    
    let startLocationX = boardMinX + (dest.bounds.width * CGFloat(piece.xCoord)) + (dest.bounds.width/2)
    let startLocationY = boardMinY + (dest.bounds.width * CGFloat(piece.yCoord)) + (dest.bounds.width/2)
    
    UIView.animate(withDuration: 0.001, animations: {self.sword!.transform = CGAffineTransform(translationX: startLocationX - self.sword!.center.x, y: startLocationY - self.sword!.center.y)}, completion: nil)
    
    sword?.isHidden = false
    
    let endLocationX = boardMinX + (dest.bounds.width * CGFloat(dest.coordinates.0)) + (dest.bounds.width/2)
    let endLocationY = boardMinY + (dest.bounds.width * CGFloat(dest.coordinates.1)) + (dest.bounds.width/2)

    UIView.animate(withDuration: 0.5, animations: {
      self.sword!.transform = CGAffineTransform(translationX: endLocationX - self.sword!.center.x, y: endLocationY - self.sword!.center.y)
    }, completion: {
      _ in
      UIView.animate(withDuration: 0.25, animations: {
        dest.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        dest.backgroundColor = .red
        self.sword?.isHidden = true
      }, completion: {
        _ in
        UIView.animate(withDuration: 0.25, animations: {
          dest.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
          if (self.boardView.checkCellOwner(cellCood: dest.coordinates) == 0) {
            dest.backgroundColor = Settings.player0TerritoryColor
          } else {
            dest.backgroundColor = Settings.player1TerritoryColor
          }
        }, completion: {
          _ in
        })
      })
    })
    
    
    //sword?.removeFromSuperview()
    //sleep(1)
    //sword?.isHidden = true

  }
  
  func playAttackAudio(_ unitName: UnitType) {
    do
    {
      var path = Bundle.main.path(forResource: "Music&Sound/knightAttack.wav", ofType:nil)!
      switch unitName {
      case .baby:
        path = Bundle.main.path(forResource: "Music&Sound/knightAttack.wav", ofType:nil)!
      case .blonde:
        path = Bundle.main.path(forResource: "Music&Sound/magicAttack.mp3", ofType:nil)!
      case .ninja:
        path = Bundle.main.path(forResource: "Music&Sound/rogueAttack.mp3", ofType:nil)!
      case .none:
        path = Bundle.main.path(forResource: "Music&Sound/knightAttack.wav", ofType:nil)!
      }
      let url = URL(fileURLWithPath: path)
      
      do {
        soundPlayer = try AVAudioPlayer(contentsOf: url)
        soundPlayer?.play()
      } catch {}
    }
    catch {}
  }
  
  func openActionMenu(cell: BoardCell) {
    let actionAlert = UIAlertController(title: "Perform Action", message: "Select action to perform.", preferredStyle: .actionSheet)
    
    let attackAction = UIAlertAction(title: "Attack", style: .default, handler: {
      action in
      self.prepAttack(from: cell)
    })
    
    let pieceIndex = findIndexOfPieceAtCell(atCell: cell)
    var playerData = player1CharData
    if (pieceIndex.0 == 2) {
      playerData = player2CharData
    }
    
    let moveAction = UIAlertAction(title: "Move", style: .default, handler: {
      action in
    
      self.pieceToMove = playerData[pieceIndex.1]
      self.displayMoveRadius(ofPiece: self.pieceToMove!)
    })
    
    let healAction = UIAlertAction(title: "Heal", style: .default, handler: {
      action in
      
      self.prepHeal(from: cell)
    })
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    
    actionAlert.addAction(attackAction)
    actionAlert.addAction(moveAction)
    if let _ = playerData[pieceIndex.1] as? Healer {
      actionAlert.addAction(healAction)
    }
    actionAlert.addAction(cancelAction)
    
    present(actionAlert,animated: true)
  }
  
  func displayMoveRadius(ofPiece: BoardUnit) {
    let playerMoving = boardView.checkCellOwner(cellCood: (ofPiece.xCoord, ofPiece.yCoord))
    for col in boardView.boardCellArr {
      for index in 0..<col.count {
        if (boardView.checkCellOwner(cellCood: (0, index)) == playerMoving) {
          if (col[index].cellUnit == .none) {
            if (ofPiece.moveRadius == -1) {
              col[index].backgroundColor = .green
              tempCells.append(col[index])
            } else if ((col[index].xCoordinate - ofPiece.xCoord).magnitude + (col[index].yCoordinate - ofPiece.yCoord).magnitude <= ofPiece.moveRadius) {
              col[index].backgroundColor = .green
              tempCells.append(col[index])
            }
          }
        }
      }
    }
  }
  
  func clearTempCells() {
    var bgColour = Settings.player0TerritoryColor
    if (tempCells.count > 0) {
      if (boardView.checkCellOwner(cellCood: (tempCells[0].xCoordinate, tempCells[0].yCoordinate)) == 1) {
        bgColour = Settings.player1TerritoryColor
      }
    }
    
    for item in tempCells {
      item.backgroundColor = bgColour
    }
    tempCells = []
  }
  
  func clearTempHealCells() {
    var bgColour = Settings.player0TerritoryColor
    if (tempHealCells.count > 0) {
      if (boardView.checkCellOwner(cellCood: (tempHealCells[0].xCoordinate, tempHealCells[0].yCoordinate)) == 1) {
        bgColour = Settings.player1TerritoryColor
      }
    }
    
    for item in tempHealCells {
      item.backgroundColor = bgColour
    }
    tempHealCells = []
  }
  
  func move(piece: inout BoardUnit, to destination: BoardCell) {
    boardView.boardCellArr[piece.xCoord][piece.yCoord].removePiece()
    piece.moveTo(cell: destination)
    turnEnd()
  }
  
  func prepHeal(from initLocation: BoardCell) {
    let healerInfo = findIndexOfPieceAtCell(atCell: initLocation)
    var nilHealer: Healer?
    if (healerInfo.0 == 1) {
      nilHealer = player1CharData[healerInfo.1] as? Healer
    } else {
      nilHealer = player2CharData[healerInfo.1] as? Healer
    }
    
    if let healer = nilHealer {
      let cells: [BoardCell] = healer.getHealableCells(onBoard: boardView)
      for item in cells {
        item.backgroundColor = .green
        tempHealCells.append(item)
      }
      pieceToHeal = healer
    }
  }
  
  func heal(location: BoardCell) {
    let defenderInfo = findIndexOfPieceAtCell(atCell: location)
    if defenderInfo.0 == 1 {
      player1CharData[defenderInfo.1].health += pieceToHeal!.healPower
    } else {
      player2CharData[defenderInfo.1].health += pieceToHeal!.healPower
    }
    turnEnd()
  }
  
  func prepAttack(from initLocation: BoardCell) {
    
    let attackerInfo = findIndexOfPieceAtCell(atCell: initLocation)
    var nilAttacker: Attacker?
    if (attackerInfo.0 == 1) {
      nilAttacker = player1CharData[attackerInfo.1] as? Attacker
    } else {
      nilAttacker = player2CharData[attackerInfo.1] as? Attacker
    }
    
    if let attacker = nilAttacker {
      let cells: [BoardCell] = attacker.getAttackableCells(onBoard: boardView)
      for item in cells {
        item.backgroundColor = .red
        tempCells.append(item)
      }
      pieceToAttack = attacker
      if (cells.count == 0) {
        attackCastle(by: attackerInfo.0)
      }
    }
  }
  
  func attack(location: BoardCell) {
    let defenderInfo = findIndexOfPieceAtCell(atCell: location)
    if defenderInfo.0 == 1 {
      player1CharData[defenderInfo.1].takeDamage(amount: pieceToAttack!.strength)
      if (player1CharData[defenderInfo.1].health <= 0) {
        removePiece(atCell: location)
      }
    } else {
      player2CharData[defenderInfo.1].takeDamage(amount: pieceToAttack!.strength)
      if (player2CharData[defenderInfo.1].health <= 0) {
        removePiece(atCell: location)
      }
    }
    
    /*
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
    */
    turnEnd()
  }
  
  func removePiece(atCell: BoardCell) {
    let playerIndex: (Int, Int) = findIndexOfPieceAtCell(atCell: atCell)
    if (playerIndex.0 != -1) {
      if (playerIndex.0 == 1) {
        player1CharData.remove(at: playerIndex.1)
      } else {
        player2CharData.remove(at: playerIndex.1)
      }
      atCell.removePiece()
    }
  }
  
  // returns (Player, index)
  func findIndexOfPieceAtCell(atCell: BoardCell) -> (Int, Int) {
    for index in 0..<player1CharData.count {
      if (player1CharData[index].xCoord == atCell.xCoordinate && player1CharData[index].yCoord == atCell.yCoordinate) {
        return (1, index)
      }
    }
    for index in 0..<player2CharData.count {
      if (player2CharData[index].xCoord == atCell.xCoordinate && player2CharData[index].yCoord == atCell.yCoordinate) {
        return (2, index)
      }
    }
    return (-1,-1)
  }
  
  func attackCastle(by player: Int) {
    if player == 1 {
      player2CastleHp -= 1
    } else {
      player1CastleHp -= 1
    }
    turnEnd()
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
