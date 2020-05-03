//
//  BoardView.swift
//  PolygonWar
//
//  Created by Gavin Li on 4/13/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class BoardSetupView: UIView {
    
    let viewWidth: CGFloat
    let unitWidth: CGFloat
    
    var cell2M: BoardSetupCell!
    var boardCellArr: [[BoardSetupCell]]
    
    weak var preGameVC: BoardSetupViewController!
    
    let factory: UnitFactory = UnitFactory()
    
    override init(frame: CGRect) {
        viewWidth = frame.size.width
        unitWidth = viewWidth / CGFloat(Settings.boardXPieces)
        boardCellArr = [[BoardSetupCell]].init(repeating: [], count: Settings.boardXPieces)
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
                let image2D = BoardSetupCell(frame: frame, xCoodInBoard: xloop, yCoodInBoard: yloop)
                image2D.highlightBorder(with: .black)
                if (yloop < Settings.boardYPieces / 2) {
                    image2D.backgroundColor = .darkGray
                } else {
                    image2D.backgroundColor = .cyan
                }
                
                image2D.delegate = self
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
    
    func reportGameCondition(_ playerNum: Int) -> [BoardUnit] {
        
        var gameCondition: [BoardUnit] = []
        for yloop in 0..<Settings.boardYPieces {
            for xloop in 0..<Settings.boardXPieces {
                let cell = boardCellArr[xloop][yloop]
                if let cellUnit = cell.cellUnit {
                    if (checkCellOwner(cellCood: cell.coordinates) == playerNum) {
                        gameCondition.append(factory.createUnit(toCreate: cellUnit.unitType, posX: xloop, posY: yloop))
                    }
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

extension BoardSetupView: BoardSetupCellDelegate {
    func singleTapped(_ cell: BoardSetupCell, completionHandler: @escaping ((GameUnit) -> Void)) {
        preGameVC.drawNewUnit(at: cell, of: checkCellOwner(cellCood: cell.coordinates), completionHandler: completionHandler)
    }
}

extension BoardSetupView: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        cell2M = interaction.view as? BoardSetupCell
        guard let image = cell2M.image else { return [] }
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = image
        return [item]
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        let interactingCell = interaction.view as! BoardSetupCell
        guard let image = item.localObject as? UIImage else { return nil }
        
        let frame = CGRect(x: 0, y: 0, width: unitWidth, height: unitWidth)
        
        let previewImageView = UIImageView(image: image)
        previewImageView.contentMode = .scaleAspectFit
        previewImageView.frame = frame
        
        /*
         Provide a custom targeted drag preview that lifts from the center of imageView. The center is calculated because it needs to be in the coordinate system of imageView. Using imageView.center returns a point that is in the coordinate system of imageView's superview, which is not what is needed here.
         */
        let center = CGPoint(x: interactingCell.bounds.midX, y: interactingCell.bounds.midY)
        let target = UIDragPreviewTarget(container: interactingCell, center: center)
        return UITargetedDragPreview(view: previewImageView, parameters: UIDragPreviewParameters(), target: target)
    }
}

extension BoardSetupView: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        if session.items.count == 1 {
            if let _ = session.items.first!.localObject as? UIImage {
                return true
            }
        }
        return false
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
            if checkCellOwner(cellCood: cell2M.coordinates) == checkCellOwner(cellCood: dropCood)
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
                coordinate != self.cell2M.coordinates {
                self.boardCellArr[coordinate.0][coordinate.1].image = images.first // This is not necessary
                self.boardCellArr[coordinate.0][coordinate.1].cellUnit = self.cell2M.cellUnit
                self.cell2M.image = nil
                self.cell2M.cellUnit = nil
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
            } else if checkCellOwner(cellCood: cell2M.coordinates) == checkCellOwner(cellCood: dropCood) {
                dropCell.highlightBorder(with: .green)
            } else {
                dropCell.highlightBorder(with: .red)
            }
        }
    }
}
