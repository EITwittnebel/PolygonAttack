//
//  HPBar.swift
//  PolygonAttack
//
//  Created by Gavin Li on 5/7/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit

@IBDesignable
class HPBar: UIView {
    let barLayer = CAShapeLayer()
    let levelLayer = CAShapeLayer()
    let maskLayer = CAShapeLayer()
    
    var lineWidth: CGFloat {
        return bounds.height
    }
    
    @IBInspectable var level: CGFloat = 0.5 {
        didSet {
            levelLayer.strokeEnd = level
            if level < 0.5 {
                levelLayer.strokeColor = UIColor.red.cgColor
            } else {
                levelLayer.strokeColor = UIColor.green.cgColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    private func setup() {
        layer.addSublayer(barLayer)
        layer.addSublayer(levelLayer)
        let width = bounds.width - lineWidth
        let height = bounds.height - lineWidth
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height / 2))
        path.addLine(to: CGPoint(x: width, y: height / 2))
        barLayer.path = path.cgPath
        barLayer.strokeColor = UIColor.lightGray.cgColor
        barLayer.lineWidth = lineWidth
        barLayer.position.x = lineWidth / 2
        barLayer.position.y = lineWidth / 2
        barLayer.lineCap = CAShapeLayerLineCap.round
        
        maskLayer.path = barLayer.path
        maskLayer.lineCap = barLayer.lineCap
        maskLayer.position = barLayer.position
        maskLayer.strokeColor = barLayer.strokeColor
        maskLayer.lineWidth = barLayer.lineWidth - 8
        maskLayer.fillColor = nil
        
        buildLevelLayer()
        levelLayer.mask = maskLayer
    }
    
    private func buildLevelLayer() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
        levelLayer.strokeColor = UIColor.white.cgColor
        levelLayer.path = path.cgPath
        levelLayer.lineWidth = bounds.height
        levelLayer.strokeEnd = level
    }
}
