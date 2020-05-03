//
//  Units.swift
//  PolygonWar
//
//  Created by Gavin Li on 4/20/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

let allAvailableUnit: [GameUnit] = [
    GameUnit(unitType: .ninja, imageName: "ninja"),
    GameUnit(unitType: .baby, imageName: "baby"),
    GameUnit(unitType: .blonde, imageName: "blonde_girl")
]

struct GameUnit {
    let unitType: UnitType
    let imageName: String
}

enum UnitType {
    case ninja
    case baby
    case blonde
    
    case none
}
