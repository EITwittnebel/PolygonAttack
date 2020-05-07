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
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            levelLayer.strokeEnd = level
            CATransaction.commit()
            if level <= 0.5 {
                levelLayer.strokeColor = UIColor.red.cgColor
            } else {
                levelLayer.strokeColor = UIColor.green.cgColor
            }
        }
    }
    
    var curHP: Int = 1
    var maxHP: Int = 2
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        setup()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    func updateStatus(status: (Int, Int)) {
        curHP = status.0
        maxHP = status.1
        var temp = CGFloat(curHP) / CGFloat(maxHP)
        temp = max(0, min(1.0, CGFloat(curHP) / CGFloat(maxHP)))
        level = temp
    }
    
    func reportStatus() -> (Int, Int) {
        return (curHP, maxHP)
    }
    
    func setup() {
        layer.addSublayer(barLayer)
        layer.addSublayer(levelLayer)
        let width = bounds.width - lineWidth
        let height = bounds.height - lineWidth
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height / 2))
        path.addLine(to: CGPoint(x: width, y: height / 2))
        barLayer.path = path.cgPath
        barLayer.strokeColor = UIColor.black.cgColor
        barLayer.lineWidth = lineWidth
        barLayer.position.x = lineWidth / 2
        barLayer.position.y = lineWidth / 2
        barLayer.lineCap = CAShapeLayerLineCap.round
        
        maskLayer.path = barLayer.path
        maskLayer.lineCap = barLayer.lineCap
        maskLayer.position = barLayer.position
        maskLayer.strokeColor = barLayer.strokeColor
        maskLayer.lineWidth = barLayer.lineWidth - 2
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
