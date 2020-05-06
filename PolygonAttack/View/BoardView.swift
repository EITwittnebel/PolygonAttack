//
//  BoardView.swift
//  PolygonWar
//
//  Created by Gavin Li on 4/13/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class BoardView: UIView {
    
    let viewWidth: CGFloat
    let unitWidth: CGFloat
    
    var boardCellArr: [[BoardCell]]
    
    override init(frame: CGRect) {
        viewWidth = frame.size.width
        unitWidth = viewWidth / CGFloat(Settings.boardXPieces)
        boardCellArr = [[BoardCell]].init(repeating: [], count: Settings.boardXPieces)
        super.init(frame: frame)
        self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        setupBoard(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBoard(frame: CGRect) {
        let minX = CGFloat(0)
        let minY = CGFloat(0)
        
        for yloop in 0..<Settings.boardYPieces {
            for xloop in 0..<Settings.boardXPieces {
                let frame = CGRect(x: CGFloat(minX + CGFloat(xloop) * unitWidth),
                                   y: CGFloat(minY + CGFloat(yloop) * unitWidth),
                                   width: unitWidth, height: unitWidth)
                let image2D = BoardCell(frame: frame, xCoodInBoard: xloop, yCoodInBoard: yloop)
                image2D.highlightBorder(with: .black)
                if (yloop < Settings.boardYPieces / 2) {
                    image2D.backgroundColor = Settings.player0TerritoryColor
                } else {
                    image2D.backgroundColor = Settings.player1TerritoryColor
                }
                
                self.addSubview(image2D)
                boardCellArr[xloop].append(image2D)
            }
        }
    }
    
    func checkCellOwner(cellCood: (Int, Int)) -> Int {
        let cut = Settings.boardYPieces / 2 - 1
        if cellCood.1 <= cut {
            return 0
        } else {
            return 1
        }
    }
    
    func cellHasUnit(xCoordinate: Int, yCoordinate: Int) -> Bool {
      if (xCoordinate < 0 || yCoordinate < 0 || xCoordinate >= boardCellArr.count || yCoordinate >= boardCellArr.count) {
        return false
      } else {
        return !(boardCellArr[xCoordinate][yCoordinate].cellUnit == .none)
      }
    }
}
