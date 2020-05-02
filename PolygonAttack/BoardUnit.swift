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
  var name: Unit { get set }
  var xCoord: Int { get set }
  var yCoord: Int { get set }
}

class Ninja: BoardUnit, Attacker {
  var name: Unit = .ninja
  var xCoord: Int
  var yCoord: Int
  
  init(Posx: Int, Posy: Int) {
    xCoord = Posx
    yCoord = Posy
  }
  
  func attack(onBoard boardView: BoardView) {
    
  }
}
