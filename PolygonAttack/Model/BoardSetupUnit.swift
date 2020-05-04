//
//  Units.swift
//  PolygonWar
//
//  Created by Gavin Li on 4/20/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

let allAvailableUnit: [BoardSetupUnit] = [
    BoardSetupUnit(unitType: .ninja, imageName: "ninja"),
    BoardSetupUnit(unitType: .baby, imageName: "baby"),
    BoardSetupUnit(unitType: .blonde, imageName: "blonde_girl")
]

struct BoardSetupUnit {
    let unitType: UnitType
    let imageName: String
}

enum UnitType {
    case ninja
    case baby
    case blonde
    
    case none
}
