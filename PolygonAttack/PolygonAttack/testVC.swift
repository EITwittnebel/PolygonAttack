//
//  testVC.swift
//  PolygonAttack
//
//  Created by Field Employee on 5/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class testVC: UIViewController {
  
  var player1CharData: [(name: Units?, xCoord: Int, yCoord: Int)] = []
  var player2CharData: [(name: Units?, xCoord: Int, yCoord: Int)] = []
  var boardView: BoardView!
  var cellGenerator0: BoardCell!
  var cellGenerator1: BoardCell!

  override func viewDidLoad() {
    super.viewDidLoad()
    configureBoard()
  }
  
  func configureBoard() {
    let sideMargin = CGFloat(32)
    let boardWidth = view.safeAreaLayoutGuide.layoutFrame.width - sideMargin * 2
    let boardHeight = boardWidth / CGFloat(Settings.boardXPieces) * CGFloat(Settings.boardYPieces)
    boardView = BoardView(frame: CGRect(x: 0, y: 0, width: boardWidth, height: boardHeight))
    view.addSubview(boardView)
    boardView.translatesAutoresizingMaskIntoConstraints = false
    boardView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    boardView.widthAnchor.constraint(equalToConstant: boardWidth).isActive = true
    boardView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    boardView.heightAnchor.constraint(equalToConstant: boardHeight).isActive = true
    boardView.backgroundColor = .clear
  }
}
