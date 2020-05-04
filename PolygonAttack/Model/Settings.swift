//
//  Settings.swift
//  PolygonWar
//
//  Created by Gavin Li on 4/20/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

enum Settings {
    static let boardXPieces: Int = 4
    
    // this value must be even
    static let boardYPieces: Int = 4
    
    static let playerMaxStartUnits: Int = 2
    
    static let player0TerritoryColor: UIColor = .lightGray
    static let player1TerritoryColor: UIColor = .cyan
    static let boardSideMargin: CGFloat = 32.0
  
    static let friendlyFire: Bool = false
}
