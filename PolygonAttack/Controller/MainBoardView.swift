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
  var player1CastleHp: Int = 3
  var player2CastleHp: Int = 3
  var pieceToMove: BoardUnit?
  var pieceToHeal: Healer?
  var pieceToAttack: Attacker?
  var playerTurnLabel: UILabel?
  var tempCells: [BoardCell] = []
  var tempHealCells: [BoardCell] = []
  var sword: UIImageView?
  var healImage: UIImageView?
  var soundPlayer: AVAudioPlayer?
  
  let castle0 = CastleCell(frame: .zero, image: UIImage(named: "castle-color"))
  let castle1 = CastleCell(frame: .zero, image: UIImage(named: "castle-black"))

  
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
    
    healImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    healImage?.center.x = view.center.x
    healImage?.center.y = 50
    healImage?.image = UIImage(named: "heal")
    healImage?.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0)
    healImage?.isHidden = true
    view.addSubview(healImage!)
  }
  
  func configureLabel() {
    playerTurnLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
    playerTurnLabel!.text = "Player \(playerTurn)'s turn"
    playerTurnLabel!.center.x = view.center.x
    playerTurnLabel!.center.y = boardView.boardCellArr[0][0].frame.width - 5
    playerTurnLabel!.textAlignment = .center
    view.addSubview(playerTurnLabel!)
  }
  
  func configureBoard() {
    let boardProportion = CGFloat(Settings.boardYPieces + 4) / CGFloat(Settings.boardXPieces)
    let viewProportion = view.frame.height / view.frame.width
    
    let boardWidth: CGFloat
    let boardHeight: CGFloat
    if boardProportion < viewProportion {
        boardWidth = view.frame.width - Settings.boardSideMargin * 2
        boardHeight = boardWidth / CGFloat(Settings.boardXPieces) * CGFloat(Settings.boardYPieces)
    } else {
        boardHeight = view.frame.height / CGFloat(Settings.boardYPieces + 4) * CGFloat(Settings.boardYPieces)
        boardWidth = boardHeight / CGFloat(Settings.boardYPieces) * CGFloat(Settings.boardXPieces)
    }
    
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
              animateHealingFrom(piece: pieceToHeal as! BoardUnit, to: cell)
              //heal(location: cell)
              //pieceToHeal = nil
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
            //this function also performs the attack
            animateAttackFrom(piece: pieceToAttack as! BoardUnit, to: cell)
          }
        }
      }
    }
    clearTempCells()
    clearTempHealCells()
  }
  
  func animateHealingFrom(piece: BoardUnit, to dest: BoardCell) {
    
    let boardMinX = dest.superview!.frame.minX
    let boardMinY = dest.superview!.frame.minY
    
    let startLocationX = boardMinX + (dest.bounds.width * CGFloat(piece.xCoord)) + (dest.bounds.width/2)
    let startLocationY = boardMinY + (dest.bounds.width * CGFloat(piece.yCoord)) + (dest.bounds.width/2)
    
    UIView.animate(withDuration: 0.001, animations: {self.healImage!.transform = CGAffineTransform(translationX: startLocationX - self.healImage!.center.x, y: startLocationY - self.healImage!.center.y)}, completion: nil)
    
    healImage?.isHidden = false
    
    var endLocationX = boardMinX + (dest.bounds.width * CGFloat(dest.coordinates.0)) + (dest.bounds.width/2)
    var endLocationY = boardMinY + (dest.bounds.width * CGFloat(dest.coordinates.1)) + (dest.bounds.width/2)

    UIView.animate(withDuration: 0.5, animations: {
      self.healImage!.transform = CGAffineTransform(translationX: endLocationX - self.healImage!.center.x, y: endLocationY - self.healImage!.center.y)
    }, completion: {
      _ in
      UIView.animate(withDuration: 0.25, animations: {
        dest.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        dest.backgroundColor = .green
        self.healImage?.isHidden = true
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
          self.heal(location: dest)
          self.pieceToHeal = nil
        })
      })
    })
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
          self.attack(location: dest)
          self.pieceToAttack = nil
        })
      })
    })
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
        location.hpBar.updateStatus(status: (player1CharData[defenderInfo.1].health, player1CharData[defenderInfo.1].maxHealth))
    } else {
      player2CharData[defenderInfo.1].health += pieceToHeal!.healPower
        location.hpBar.updateStatus(status: (player2CharData[defenderInfo.1].health, player2CharData[defenderInfo.1].maxHealth))
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
        if ((attacker as! BoardUnit).name != .ninja) {
          attackCastle(by: attackerInfo.0)
        } else {
          // special case for ninja, this really should be generalized though
          let ninja = attacker as! Ninja
          if ninja.canAttackCastle {
            attackCastle(by: ninja.strength)
            ninja.canAttackCastle = false
          }
        }
      }
    }
  }
  
  func attack(location: BoardCell) {
    let defenderInfo = findIndexOfPieceAtCell(atCell: location)
    if defenderInfo.0 == 1 {
      player1CharData[defenderInfo.1].takeDamage(amount: pieceToAttack!.strength)
        location.hpBar.updateStatus(status: (player1CharData[defenderInfo.1].health, player1CharData[defenderInfo.1].maxHealth))
      if (player1CharData[defenderInfo.1].health <= 0) {
        removePiece(atCell: location)
      }
    } else {
      player2CharData[defenderInfo.1].takeDamage(amount: pieceToAttack!.strength)
        location.hpBar.updateStatus(status: (player2CharData[defenderInfo.1].health, player2CharData[defenderInfo.1].maxHealth))
      if (player2CharData[defenderInfo.1].health <= 0) {
        removePiece(atCell: location)
      }
    }
  
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
    var castle = castle0
    if player == 1 {
      player2CastleHp -= 1
      castle = castle1
    } else {
      player1CastleHp -= 1
      castle0.backgroundColor = .red
    }
    
    UIView.animate(withDuration: 0.25, animations: {
      castle.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
      castle.backgroundColor = .red
      self.sword?.isHidden = true
    }, completion: {
      _ in
      UIView.animate(withDuration: 0.25, animations: {
        castle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        if (player != 1) {
          castle.backgroundColor = Settings.player0TerritoryColor
        } else {
          castle.backgroundColor = Settings.player1TerritoryColor
        }
      })
    })
    
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
      let vc = storyboard?.instantiateViewController(identifier: "WinScreen") as! WinViewController
      vc.winner = 2
      vc.modalPresentationStyle = .fullScreen
      present(vc, animated: true)
      return 2
    } else if player2CharData.count == 0 || player2CastleHp <= 0 {
      let vc = storyboard?.instantiateViewController(identifier: "WinScreen") as! WinViewController
      vc.winner = 1
      vc.modalPresentationStyle = .fullScreen
      present(vc, animated: true)
      return 1
    }
    return nil
  }
  
  func createCastleCells(aboveAndBelow boardView: UIView, of height: CGFloat) {
    
    castle0.highlightBorder(with: .black)
    view.addSubview(castle0)
    castle0.backgroundColor = Settings.player0TerritoryColor
    castle0.translatesAutoresizingMaskIntoConstraints = false
    castle0.leadingAnchor.constraint(equalTo: boardView.leadingAnchor).isActive = true
    castle0.trailingAnchor.constraint(equalTo: boardView.trailingAnchor).isActive = true
    castle0.bottomAnchor.constraint(equalTo: boardView.topAnchor).isActive = true
    castle0.heightAnchor.constraint(equalToConstant: height).isActive = true
    
    castle1.highlightBorder(with: .black)
    view.addSubview(castle1)
    castle1.backgroundColor = Settings.player1TerritoryColor
    castle1.translatesAutoresizingMaskIntoConstraints = false
    castle1.trailingAnchor.constraint(equalTo: boardView.trailingAnchor).isActive = true
    castle1.leadingAnchor.constraint(equalTo: boardView.leadingAnchor).isActive = true
    castle1.topAnchor.constraint(equalTo: boardView.bottomAnchor).isActive = true
    castle1.heightAnchor.constraint(equalToConstant: height).isActive = true
  }
}
