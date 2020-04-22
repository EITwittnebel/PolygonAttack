//
//  ViewController.swift
//  PolygonWar
//
//  Created by Gavin Li on 4/13/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class PreGameVC: UIViewController {
    
    var boardView: BoardView!
    var cellGenerator0: BoardCell!
    var cellGenerator1: BoardCell!
    
    var boardCellWidth: CGFloat = 0
    
    var player0TotalUnits = 0 {
        didSet {
            if player0TotalUnits == Settings.playerMaxStartUnits
                && player1TotalUnits == Settings.playerMaxStartUnits {
                print(boardView.reportGameCondition(0))
            }
        }
    }
    var player1TotalUnits = 0 {
        didSet {
            if player0TotalUnits == Settings.playerMaxStartUnits
                && player1TotalUnits == Settings.playerMaxStartUnits {
                print(boardView.reportGameCondition(1))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func drawNewUnit() {
        if cellGenerator0.image == nil && cellGenerator0.unitToDraw > 0 {
            cellGenerator0.drawUnit(index: player0TotalUnits)
        }
        if cellGenerator1.image == nil && cellGenerator1.unitToDraw > 0 {
            cellGenerator1.drawUnit(index: player1TotalUnits)
        }
    }
    
    func configureView() {
        
        let sideMargin = CGFloat(32)
        let boardWidth = view.safeAreaLayoutGuide.layoutFrame.width - sideMargin * 2
        boardCellWidth = boardWidth / CGFloat(Settings.boardXPieces)
        let boardHeight = boardWidth / CGFloat(Settings.boardXPieces) * CGFloat(Settings.boardYPieces)
        
        boardView = BoardView(frame: CGRect(x: 0, y: 0, width: boardWidth, height: boardHeight))
        boardView.preGameVC = self
        view.addSubview(boardView)
        boardView.translatesAutoresizingMaskIntoConstraints = false
        boardView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        boardView.widthAnchor.constraint(equalToConstant: boardWidth).isActive = true
        boardView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        boardView.heightAnchor.constraint(equalToConstant: boardHeight).isActive = true
        boardView.backgroundColor = .gray
        
        cellGenerator0 = BoardCell(frame: .zero, xCoodInBoard: 0, yCoodInBoard: -1)
        cellGenerator0.unitToDraw = Settings.playerMaxStartUnits
        cellGenerator0.highlightBorder(with: .black)
        let dragInteraction0 = UIDragInteraction(delegate: self)
        cellGenerator0.addInteraction(dragInteraction0)
        dragInteraction0.isEnabled = true
        
        view.addSubview(cellGenerator0)
        cellGenerator0.translatesAutoresizingMaskIntoConstraints = false
        cellGenerator0.leadingAnchor.constraint(equalTo: boardView.leadingAnchor).isActive = true
        cellGenerator0.bottomAnchor.constraint(equalTo: boardView.topAnchor).isActive = true
        cellGenerator0.widthAnchor.constraint(equalToConstant: 64).isActive = true
        cellGenerator0.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        cellGenerator1 = BoardCell(frame: .zero,
                                   xCoodInBoard: Settings.boardXPieces - 1, yCoodInBoard: Settings.boardYPieces)
        cellGenerator1.unitToDraw = Settings.playerMaxStartUnits
        cellGenerator1.highlightBorder(with: .black)
        let dragInteraction1 = UIDragInteraction(delegate: self)
        cellGenerator1.addInteraction(dragInteraction1)
        dragInteraction1.isEnabled = true
        
        view.addSubview(cellGenerator1)
        cellGenerator1.translatesAutoresizingMaskIntoConstraints = false
        cellGenerator1.trailingAnchor.constraint(equalTo: boardView.trailingAnchor).isActive = true
        cellGenerator1.topAnchor.constraint(equalTo: boardView.bottomAnchor).isActive = true
        cellGenerator1.widthAnchor.constraint(equalToConstant: 64).isActive = true
        cellGenerator1.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        drawNewUnit()
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let dest = segue.destination as! MainBoardView
    dest.player1CharData = boardView.reportGameCondition(0)
    dest.player2CharData = boardView.reportGameCondition(1)
  }
}

extension PreGameVC: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let cellGenerator = interaction.view as! BoardCell
        boardView.image2M = cellGenerator
        guard let image = cellGenerator.image else { return [] }
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = image
        return [item]
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        let image2M = interaction.view as! BoardCell
        guard let image = item.localObject as? UIImage else { return nil }
        
        let frame = CGRect(x: 0, y: 0, width: boardCellWidth, height: boardCellWidth)
        
        let previewImageView = UIImageView(image: image)
        previewImageView.contentMode = .scaleAspectFit
        previewImageView.frame = frame
        
        /*
         Provide a custom targeted drag preview that lifts from the center
         of imageView. The center is calculated because it needs to be in
         the coordinate system of imageView. Using imageView.center returns
         a point that is in the coordinate system of imageView's superview,
         which is not what is needed here.
         */
        let center = CGPoint(x: image2M.bounds.midX, y: image2M.bounds.midY)
        let target = UIDragPreviewTarget(container: image2M, center: center)
        return UITargetedDragPreview(view: previewImageView, parameters: UIDragPreviewParameters(), target: target)
    }
}
