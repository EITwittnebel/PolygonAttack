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
    
    var image2M: BoardCell!
    var boardCellArr: [[BoardCell]]
    
    weak var preGameVC: PreGameVC!
    
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
        
        var cellIndex = 0
        for yloop in 0..<Settings.boardYPieces {
            for xloop in 0..<Settings.boardXPieces {
                let frame = CGRect(x: CGFloat(minX + CGFloat(xloop) * unitWidth),
                                   y: CGFloat(minY + CGFloat(yloop) * unitWidth),
                                   width: unitWidth, height: unitWidth)
                let image2D = BoardCell(frame: frame, xCoodInBoard: xloop, yCoodInBoard: yloop)
                image2D.highlightBorder(with: .black)
                
                cellIndex = cellIndex + 1
                self.addSubview(image2D)
                boardCellArr[xloop].append(image2D)
                
                let dragInteraction = UIDragInteraction(delegate: self)
                image2D.addInteraction(dragInteraction)
                dragInteraction.isEnabled = true
                let dropInteraction = UIDropInteraction(delegate: self)
                image2D.addInteraction(dropInteraction)
            }
        }
    }
    
    //TODO: modify
    func reportGameCondition() -> [(Int, Units, Int, Int)] {
        var gameCondition: [(Int, Units, Int, Int)] = []
        for yloop in 0..<Settings.boardYPieces {
            for xloop in 0..<Settings.boardXPieces {
                let cell = boardCellArr[xloop][yloop]
                if cell.image != nil {
                    gameCondition.append((checkCellOwner(cellCood: cell.coordinates),
                                          cell.cellUnit, xloop, yloop))
                }
            }
        }
        return gameCondition
    }
    
    func checkCellOwner(cellCood: (Int, Int)) -> Int {
        let cut = Settings.boardYPieces / 2 - 1
        if cellCood.1 <= cut {
            return 0
        } else {
            return 1
        }
    }
}

extension BoardView: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        image2M = interaction.view as? BoardCell
        guard let image = image2M.image else { return [] }
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = image
        //        print("sourceIndex \(sourceCood)")
        return [item]
    }
}

extension BoardView: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.items.count == 1
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        let dropLocation = session.location(in: self)
        resetBoardCellBoarder()
        updateLayers(forDropLocation: dropLocation)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction,
                         sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: self)
        if let dropCood = getCoordinate(from: dropLocation) {
            let dropCell = boardCellArr[dropCood.0][dropCood.1]
            if checkCellOwner(cellCood: image2M.coordinates) == checkCellOwner(cellCood: dropCood)
            && dropCell.image == nil {
                return UIDropProposal(operation: .move)
            }
        }
        return UIDropProposal(operation: .cancel)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        session.loadObjects(ofClass: UIImage.self) { [unowned self] imageItems in
            let images = imageItems as! [UIImage]
            let dropLocation: CGPoint = session.location(in: self)
            if let coordinate = self.getCoordinate(from: dropLocation),
                coordinate != self.image2M.coordinates {
                self.boardCellArr[coordinate.0][coordinate.1].image = images.first
                self.boardCellArr[coordinate.0][coordinate.1].cellUnit = self.image2M.cellUnit
                self.image2M.image = nil
                self.image2M.cellUnit = .none
                
                let sourceCood = self.image2M.coordinates
                if sourceCood.1 < 0 {
                    self.preGameVC.player0TotalUnits += 1
                    self.preGameVC.drawNewUnit()
                } else if sourceCood.1 >= Settings.boardYPieces {
                    self.preGameVC.player1TotalUnits += 1
                    self.preGameVC.drawNewUnit()
                }
                //                print("objectIndex \(self.objectCood)")
            }
        }
    }
    
    // Update UI, as needed, when touch point of drag session leaves view.
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        resetBoardCellBoarder()
        updateLayers(forDropLocation: session.location(in: self))
    }
    
    // Update UI and model, as needed, when drop session ends.
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        resetBoardCellBoarder()
        //        print("End \(session.location(in: self))")
    }
    
    private func getCoordinate(from point: CGPoint) -> (Int, Int)? {
        guard point.x >= 0 && point.x <= CGFloat(Settings.boardXPieces) * unitWidth else { return nil }
        guard point.y >= 0 && point.y <= CGFloat(Settings.boardYPieces) * unitWidth else { return nil }
        let xCood = Int(point.x / unitWidth)
        let yCood = Int(point.y / unitWidth)
        return (xCood, yCood)
    }
    
    private func resetBoardCellBoarder() {
        for columnCellArr in boardCellArr {
            for cell in columnCellArr {
                cell.highlightBorder(with: .black)
            }
        }
    }
    
    private func updateLayers(forDropLocation dropLocation: CGPoint) {
        if let dropCood = getCoordinate(from: dropLocation) {
            let dropCell = boardCellArr[dropCood.0][dropCood.1]
            if dropCell.image != nil {
                dropCell.highlightBorder(with: .red)
            } else if checkCellOwner(cellCood: image2M.coordinates) == checkCellOwner(cellCood: dropCood) {
                dropCell.highlightBorder(with: .green)
            } else {
                dropCell.highlightBorder(with: .red)
            }
        }
    }
}
