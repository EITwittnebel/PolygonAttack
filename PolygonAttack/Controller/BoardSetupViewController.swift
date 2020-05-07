//
//  ViewController.swift
//  PolygonWar
//
//  Created by Gavin Li on 4/13/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class BoardSetupViewController: UIViewController {
    
    @IBOutlet weak var unitSelectionView: UIView!
    var gameBeginBtun: UIButton!
    var boardView: BoardSetupView!
    var castle0: CastleCell!
    var castle1: CastleCell!
    
    var boardCellWidth: CGFloat = 0
    
    var player0TotalUnits = 0
    var player1TotalUnits = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        // TODO: These two checks should be done in the game's Settings screen
        guard Settings.boardYPieces % 2 == 0 else { fatalError("Should have an even number of vertical pieces") }
        let boardProportion = CGFloat(Settings.boardYPieces + 2) / CGFloat(Settings.boardXPieces)
        let viewProportion = view.frame.height / view.frame.width
       // guard boardProportion < viewProportion else { fatalError("Board is too long") }
        
        let sideMargin = Settings.boardSideMargin
        let boardWidth = view.frame.width - sideMargin * 2
        boardCellWidth = boardWidth / CGFloat(Settings.boardXPieces)
        let boardHeight = boardWidth / CGFloat(Settings.boardXPieces) * CGFloat(Settings.boardYPieces)
        
        boardView = BoardSetupView(frame: CGRect(x: 0, y: 0, width: boardWidth, height: boardHeight))
        boardView.preGameVC = self
        view.addSubview(boardView)
        boardView.translatesAutoresizingMaskIntoConstraints = false
        boardView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        boardView.widthAnchor.constraint(equalToConstant: boardWidth).isActive = true
        boardView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        boardView.heightAnchor.constraint(equalToConstant: boardHeight).isActive = true
        boardView.backgroundColor = .clear
        
        castle0 = CastleCell(frame: .zero, image: UIImage(named: "castle-color"))
        castle0.highlightBorder(with: .black)
        view.addSubview(castle0)
        castle0.translatesAutoresizingMaskIntoConstraints = false
        castle0.leadingAnchor.constraint(equalTo: boardView.leadingAnchor).isActive = true
        castle0.trailingAnchor.constraint(equalTo: boardView.trailingAnchor).isActive = true
        castle0.bottomAnchor.constraint(equalTo: boardView.topAnchor).isActive = true
        castle0.heightAnchor.constraint(equalToConstant: boardCellWidth).isActive = true
        
        castle1 = CastleCell(frame: .zero, image: UIImage(named: "castle-black"))
        castle1.highlightBorder(with: .black)
        view.addSubview(castle1)
        castle1.translatesAutoresizingMaskIntoConstraints = false
        castle1.trailingAnchor.constraint(equalTo: boardView.trailingAnchor).isActive = true
        castle1.leadingAnchor.constraint(equalTo: boardView.leadingAnchor).isActive = true
        castle1.topAnchor.constraint(equalTo: boardView.bottomAnchor).isActive = true
        castle1.heightAnchor.constraint(equalToConstant: boardCellWidth).isActive = true
        
        gameBeginBtun = UIButton()
        gameBeginBtun.setTitle("Begin Game", for: .normal)
        gameBeginBtun.setTitleColor(.link, for: .normal)
        gameBeginBtun.layer.borderWidth = 1.0
        gameBeginBtun.layer.cornerRadius = 5.0
        gameBeginBtun.layer.borderColor = UIColor.link.cgColor
        gameBeginBtun.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        gameBeginBtun.addTarget(self, action: #selector(beginGameBtnClicked(_:)), for: .touchUpInside)
        view.addSubview(gameBeginBtun)
        gameBeginBtun.translatesAutoresizingMaskIntoConstraints = false
        gameBeginBtun.topAnchor.constraint(equalTo: castle1.bottomAnchor, constant: 8).isActive = true
        gameBeginBtun.centerXAnchor.constraint(equalTo: boardView.centerXAnchor).isActive = true
    }
    
    @objc func beginGameBtnClicked(_ sender: Any) {
        if player0TotalUnits == Settings.playerMaxStartUnits
            && player1TotalUnits == Settings.playerMaxStartUnits {
            
            if let mainBoard = self.storyboard?.instantiateViewController(withIdentifier: "MainBoard") as? MainBoardView {
                mainBoard.modalPresentationStyle = .fullScreen
                mainBoard.player1CharData = boardView.reportGameCondition(0)
                mainBoard.player2CharData = boardView.reportGameCondition(1)
                self.present(mainBoard, animated: false)
            }
        }
    }
    
    func drawNewUnit(at cell: BoardSetupCell, of player: Int, completionHandler: @escaping ((BoardSetupUnit) -> Void)) {
        if player == 0 && player0TotalUnits < Settings.playerMaxStartUnits ||
            player == 1 && player1TotalUnits < Settings.playerMaxStartUnits || cell.cellUnit != nil {
            
            let selectionVC = UnitSelectionViewController()
            selectionVC.completionHandler = { [unowned self, player] (unit: BoardSetupUnit) in
                if cell.cellUnit == nil {
                    if player == 0 {
                        self.player0TotalUnits += 1
                    } else if player == 1 {
                        self.player1TotalUnits += 1
                    }
                }
                completionHandler(unit)
            }
            selectionVC.modalPresentationStyle = .popover
            selectionVC.popoverPresentationController?.delegate = selectionVC
            self.present(selectionVC, animated: true, completion: nil)
            selectionVC.preferredContentSize = CGSize(width: 200, height: 200)
            selectionVC.popoverPresentationController?.sourceView = cell
            selectionVC.popoverPresentationController?.permittedArrowDirections = .init(arrayLiteral: [.down, .up])
        }
    }
}
