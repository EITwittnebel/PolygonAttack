//
//  BoardCell.swift
//  PolygonWar
//
//  Created by Gavin Li on 4/18/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class BoardCell: UIView {
    
    let xCoordinate: Int
    let yCoordinate: Int
    var coordinates: (Int, Int) {
        (xCoordinate, yCoordinate)
    }
    
    var cellUnit: UnitType = .none
    
    var imageView: UIImageView
    var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    var hpBar: HPBar

    init(frame: CGRect, xCoodInBoard xCood: Int, yCoodInBoard yCood: Int) {
        xCoordinate = xCood
        yCoordinate = yCood
        imageView = UIImageView(frame: CGRect(origin: .zero, size: frame.size))
        hpBar = HPBar.init(frame: CGRect(x: 2, y: frame.height - 8, width: frame.width - 4, height: 6))
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        
        self.addSubview(imageView)
        self.addSubview(hpBar)
        self.bringSubviewToFront(hpBar)
        hpBar.isHidden = true
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
        switch index {
        case 0:
            self.image = UIImage(named: "ninja")
            self.cellUnit = .ninja
            hpBar.updateStatus(status: (Ninja.init(Posx: 0, Posy: 0).health, Ninja.init(Posx: 0, Posy: 0).health))
            hpBar.isHidden = false
        case 1:
            self.image = UIImage(named: "baby")
            self.cellUnit = .baby
            hpBar.updateStatus(status: (Baby.init(Posx: 0, Posy: 0).health, Baby.init(Posx: 0, Posy: 0).health))
            hpBar.isHidden = false
        case 2:
            self.image = UIImage(named: "blonde_girl")
            self.cellUnit = .blonde
            hpBar.updateStatus(status: (Blonde.init(Posx: 0, Posy: 0).health, Blonde.init(Posx: 0, Posy: 0).health))
            hpBar.isHidden = false
        default:
            self.image = nil
            self.cellUnit = .none
            hpBar.isHidden = true
        }
    }
  
    func removePiece() {
        self.image = nil
        self.cellUnit = .none
        self.hpBar.isHidden = true
    }
  
    func reverseIndex(unit: UnitType) -> Int {
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
