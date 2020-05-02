//
//  BoardCell.swift
//  PolygonWar
//
//  Created by Gavin Li on 4/18/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class BoardCell: UIImageView {
    
    let xCoordinate: Int
    let yCoordinate: Int
    var coordinates: (Int, Int) {
        (xCoordinate, yCoordinate)
    }
    
    var unitToDraw = 0
    var cellUnit: Unit = .none

    init(frame: CGRect, xCoodInBoard xCood: Int, yCoodInBoard yCood: Int) {
        xCoordinate = xCood
        yCoordinate = yCood
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func highlightBorder(with color: BorderColor) {
        switch color {
        case .red:
            self.layer.borderColor = UIColor.red.cgColor
            self.layer.borderWidth = 4
        case .green:
            self.layer.borderColor = UIColor.green.cgColor
            self.layer.borderWidth = 4
        case .black:
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 1
        }
    }
  
    func drawUnit(index: Int) {
        guard unitToDraw > 0 else { return }
        switch index {
        case 0:
            self.image = UIImage(named: "ninja")
            self.cellUnit = .ninja
        case 1:
            self.image = UIImage(named: "baby")
            self.cellUnit = .baby
        case 2:
            self.image = UIImage(named: "blonde_girl")
            self.cellUnit = .blonde
        default:
            self.image = nil
            self.cellUnit = .none
        }
        unitToDraw -= 1
    }
  
    func removePiece() {
        self.image = nil
        self.cellUnit = .none
    }
  
    func reverseIndex(unit: Unit) -> Int {
      switch unit {
      case .ninja:
          return 0
      case .baby:
          return 1
      case .blonde:
          return 2
      default:
          return -1
      }
    }
}

enum BorderColor {
    case red
    case green
    case black
}
