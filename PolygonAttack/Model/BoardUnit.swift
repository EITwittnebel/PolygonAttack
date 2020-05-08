//
//  Character.swift
//  PolygonAttack
//
//  Created by Field Employee on 4/4/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

enum UnitStats {
    static let Ninja = (-1, 2, 1)
    static let Baby = (2, 3, 1)
    static let Blonde = (2, 2, 1, 1)
}

protocol Attacker {
  var strength: Int { get set }
  func getAttackableCells(onBoard boardView: BoardView) -> [BoardCell]
}

protocol BoardUnit {
  var name: UnitType { get }
  var imageIndex: Int { get }
  var xCoord: Int { get set }
  var yCoord: Int { get set }
  var isMoving: Bool { get set }
  var moveRadius: Int { get }
  var health: Int { get set }
  var maxHealth: Int { get }
  var owner: Int { get }
  
  mutating func moveTo(cell: BoardCell)
  
  func takeDamage(amount: Int)
}

protocol Healer {
  var healPower: Int { get set }
  func getHealableCells(onBoard boardView: BoardView) -> [BoardCell]
}

extension BoardUnit {
  mutating func moveTo(cell: BoardCell) {
    isMoving = false
    xCoord = cell.xCoordinate
    yCoord = cell.yCoordinate
    cell.cellUnit = name
    cell.drawUnit(index: imageIndex)
    cell.hpBar.updateStatus(status: (health, maxHealth))
    cell.hpBar.isHidden = false
  }
}

class UnitFactory {
  func createUnit(toCreate: UnitType, posX: Int, posY: Int) -> BoardUnit {
    switch toCreate {
    case .ninja:
      return Ninja(Posx: posX, Posy: posY)
    case .baby:
      return Baby(Posx: posX, Posy: posY)
    case .blonde:
      return Blonde(Posx: posX, Posy: posY)
    default:
      return Ninja(Posx: posX, Posy: posY)
    }
  }
}

class Ninja: BoardUnit, Attacker {
  var name: UnitType = .ninja
  var xCoord: Int
  var yCoord: Int
  var isMoving: Bool
  var imageIndex: Int = 0
    var moveRadius: Int = UnitStats.Ninja.0
  var health: Int = UnitStats.Ninja.1
  let maxHealth: Int = UnitStats.Ninja.1
  var owner: Int
  var strength: Int = UnitStats.Ninja.2
  var canAttackCastle = false
  
  init(Posx: Int, Posy: Int) {
    xCoord = Posx
    yCoord = Posy
    isMoving = false
    if (yCoord < Settings.boardYPieces/2) {
      owner = 1
    } else {
      owner = 2
    }
  }
  
  func getAttackableCells(onBoard boardView: BoardView) -> [BoardCell] {
    let player = owner
    var retCells: [BoardCell] = []
    let initAttackLocation: (Int, Int) = (xCoord, yCoord)
    var currAttackLocation: (Int, Int) = (xCoord, yCoord)
    
    var vertIncrement: Int = -1
    var horIncrement: Int = -1
    if (player == 1) {
      vertIncrement = 1
    }
    
    // One loop for each diagonal to look at
    for _ in 0...1 {
      currAttackLocation = initAttackLocation
      currAttackLocation.1 += vertIncrement
      currAttackLocation.0 += horIncrement
      while ((currAttackLocation.1 >= 0) && (currAttackLocation.1 < Settings.boardYPieces) &&
        (currAttackLocation.0 >= 0) && (currAttackLocation.0 < Settings.boardXPieces)) {
        if boardView.cellHasUnit(xCoordinate: currAttackLocation.0, yCoordinate: currAttackLocation.1) {
          // unit is attackable
          retCells.append(boardView.boardCellArr[currAttackLocation.0][currAttackLocation.1])
          break
        }
        currAttackLocation.1 += vertIncrement
        currAttackLocation.0 += horIncrement
      }
      if ((currAttackLocation.0 >= 0) && (currAttackLocation.0 < Settings.boardXPieces)) {
        canAttackCastle = true
      }
      horIncrement *= -1
    }
    
    return retCells
  }
  
  func takeDamage(amount: Int) {
    health -= amount
  }
}

class Baby: BoardUnit, Attacker {
  var name: UnitType = .baby
  var xCoord: Int
  var yCoord: Int
  var isMoving: Bool
  var imageIndex: Int = 1
    var moveRadius: Int = UnitStats.Baby.0
  var health: Int =  UnitStats.Baby.1
  let maxHealth: Int =  UnitStats.Baby.1
  var owner: Int
  var strength: Int =  UnitStats.Baby.2
  
  init(Posx: Int, Posy: Int) {
    xCoord = Posx
    yCoord = Posy
    isMoving = false
    if (yCoord < Settings.boardYPieces/2) {
      owner = 1
    } else {
      owner = 2
    }
  }
  
  func getAttackableCells(onBoard boardView: BoardView) -> [BoardCell] {
    let player = owner
    var currAttackLocation: (Int, Int) = (xCoord, yCoord)
    var increment: Int = -1
    if (player == 1) {
      increment = 1
    }
    
    currAttackLocation.1 += increment
    while ((currAttackLocation.1 >= 0) && (currAttackLocation.1 < Settings.boardYPieces)) {
      if boardView.cellHasUnit(xCoordinate: currAttackLocation.0, yCoordinate: currAttackLocation.1) {
        // unit is attackable
        let attackedUnitCell = boardView.boardCellArr[currAttackLocation.0][currAttackLocation.1]
        return [attackedUnitCell]
      }
      currAttackLocation.1 += increment
    }
    return []
  }
  
  func takeDamage(amount: Int) {
    health -= amount
  }
}

class Blonde: BoardUnit, Attacker, Healer {
  var name: UnitType = .blonde
  var xCoord: Int
  var yCoord: Int
  var isMoving: Bool
  var imageIndex: Int = 2
    var moveRadius: Int =  UnitStats.Blonde.0
  var health: Int = UnitStats.Blonde.1
  let maxHealth: Int = UnitStats.Blonde.1
  var owner: Int
  var strength: Int = UnitStats.Blonde.2
    var healPower: Int = UnitStats.Blonde.3

  init(Posx: Int, Posy: Int) {
    xCoord = Posx
    yCoord = Posy
    isMoving = false
    if (yCoord < Settings.boardYPieces/2) {
      owner = 1
    } else {
      owner = 2
    }
  }
  
  func getAttackableCells(onBoard boardView: BoardView) -> [BoardCell] {
    let player = owner
    var currAttackLocation: (Int, Int) = (xCoord, yCoord)
    var increment: Int = -1
    if (player == 1) {
      increment = 1
    }
    
    currAttackLocation.1 += increment
    while ((currAttackLocation.1 >= 0) && (currAttackLocation.1 < Settings.boardYPieces)) {
      if boardView.cellHasUnit(xCoordinate: currAttackLocation.0, yCoordinate: currAttackLocation.1) {
        // unit is attackable
        let attackedUnitCell = boardView.boardCellArr[currAttackLocation.0][currAttackLocation.1]
        return [attackedUnitCell]
      }
      currAttackLocation.1 += increment
    }
    return []
  }
  
  func getHealableCells(onBoard boardView: BoardView) -> [BoardCell] {
    let player = owner
    var retCells: [BoardCell] = []
    
    if boardView.cellHasUnit(xCoordinate: xCoord-1, yCoordinate: yCoord) {
      if (boardView.checkCellOwner(cellCood: (xCoord-1, yCoord)) == player - 1) {
        retCells.append(boardView.boardCellArr[xCoord-1][yCoord])
      }
    }
    if boardView.cellHasUnit(xCoordinate: xCoord, yCoordinate: yCoord-1) {
      if (boardView.checkCellOwner(cellCood: (xCoord, yCoord-1)) == player - 1) {
        retCells.append(boardView.boardCellArr[xCoord][yCoord-1])
      }
    }
    if boardView.cellHasUnit(xCoordinate: xCoord+1, yCoordinate: yCoord) {
      if (boardView.checkCellOwner(cellCood: (xCoord+1, yCoord)) == player - 1) {
        retCells.append(boardView.boardCellArr[xCoord+1][yCoord])
      }
    }
    if boardView.cellHasUnit(xCoordinate: xCoord, yCoordinate: yCoord+1) {
      if (boardView.checkCellOwner(cellCood: (xCoord, yCoord+1)) == player - 1) {
        retCells.append(boardView.boardCellArr[xCoord][yCoord+1])
      }
    }

    return retCells
  }
  
  func takeDamage(amount: Int) {
    health -= amount
  }
}
