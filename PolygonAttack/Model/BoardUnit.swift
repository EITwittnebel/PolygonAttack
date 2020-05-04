//
//  Character.swift
//  PolygonAttack
//
//  Created by Field Employee on 4/4/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit


protocol Attacker {
  func attack(onBoard boardView: BoardView)
}

protocol BoardUnit {
  var name: UnitType { get }
  var imageIndex: Int { get }
  var xCoord: Int { get set }
  var yCoord: Int { get set }
  var isMoving: Bool { get set }
  
  mutating func moveTo(cell: BoardCell)
}

extension BoardUnit {
  mutating func moveTo(cell: BoardCell) {
    isMoving = false
    xCoord = cell.xCoordinate
    yCoord = cell.yCoordinate
    cell.cellUnit = name
    cell.drawUnit(index: imageIndex)
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
  
  init(Posx: Int, Posy: Int) {
    xCoord = Posx
    yCoord = Posy
    isMoving = false
  }
  
  func attack(onBoard boardView: BoardView) {
    
  }
}

class Baby: BoardUnit, Attacker {
  var name: UnitType = .baby
  var xCoord: Int
  var yCoord: Int
  var isMoving: Bool
  var imageIndex: Int = 1
  
  init(Posx: Int, Posy: Int) {
    xCoord = Posx
    yCoord = Posy
    isMoving = false
  }
  
  func attack(onBoard boardView: BoardView) {
    
  }
}

class Blonde: BoardUnit, Attacker {
  var name: UnitType = .blonde
  var xCoord: Int
  var yCoord: Int
  var isMoving: Bool
  var imageIndex: Int = 2
  
  init(Posx: Int, Posy: Int) {
    xCoord = Posx
    yCoord = Posy
    isMoving = false
  }
  
  func attack(onBoard boardView: BoardView) {
    
  }
}
