//
//  CastleCell.swift
//  PolygonAttack
//
//  Created by Gavin Li on 5/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

class CastleCell: UIImageView {
    
    init(frame: CGRect, image: UIImage?) {
        super.init(frame: frame)
        self.image = image
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
