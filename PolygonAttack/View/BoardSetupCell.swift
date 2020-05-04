//
//  BoardCell.swift
//  PolygonWar
//
//  Created by Gavin Li on 4/18/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

protocol BoardSetupCellDelegate: class {
    func singleTapped(_ cell: BoardSetupCell, completionHandler: @escaping ((BoardSetupUnit) -> Void))
}

class BoardSetupCell: UIImageView {
    
    weak var delegate: BoardSetupCellDelegate?
    
    let xCoordinate: Int
    let yCoordinate: Int
    var coordinates: (Int, Int) {
        (xCoordinate, yCoordinate)
    }
    
    var cellUnit: BoardSetupUnit? {
        didSet {
            if let cellUnit = cellUnit {
                self.image = UIImage(named: cellUnit.imageName)
            }
        }
    }
    
    init(frame: CGRect, xCoodInBoard xCood: Int, yCoodInBoard yCood: Int) {
        xCoordinate = xCood
        yCoordinate = yCood
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTapped(_:)))
        singleTap.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func singleTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        if gestureRecognizer.state == .ended {
            clickAnimate()
            delegate?.singleTapped(self) { [unowned self] selectedUnit in
                self.cellUnit = selectedUnit
            }
        }
    }
    
    func highlightBorder(with color: BorderColor) {
        switch color {
        case .red:
            self.layer.borderColor = UIColor.red.cgColor
            self.layer.borderWidth = 4
        case .green:
            self.layer.borderColor = UIColor.green.cgColor
            self.layer.borderWidth = 4
        case .black:
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 1
        }
    }
}

extension BoardSetupCell {
    func clickAnimate() {
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        self.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0.0
        }, completion: { (finished : Bool) in
            if (finished) {
                self.removeFromSuperview()
            }
        })
    }
}
