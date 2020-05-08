//
//  Units.swift
//  PolygonWar
//
//  Created by Gavin Li on 4/20/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

let allAvailableUnit: [BoardSetupUnit] = [
    BoardSetupUnit(unitType: .ninja, imageName: "ninja",
                   desc: "MOV: 99 \nHP: \(UnitStats.Ninja.1) \nSTR: \(UnitStats.Ninja.2) (Diagonal)"),
    BoardSetupUnit(unitType: .baby, imageName: "baby",
                   desc: "MOV: \(UnitStats.Baby.0) \nHP: \(UnitStats.Baby.1) \nSTR: \(UnitStats.Baby.2)"),
    BoardSetupUnit(unitType: .blonde, imageName: "blonde_girl",
                   desc: "MOV: \(UnitStats.Blonde.0) \nHP: \(UnitStats.Blonde.1) \nSTR: \(UnitStats.Blonde.2) \nHEAL: \(UnitStats.Blonde.3)")
]

struct BoardSetupUnit {
    let unitType: UnitType
    let imageName: String
    let desc: String
}

enum UnitType {
    case ninja
    case baby
    case blonde
    
    case none
}
