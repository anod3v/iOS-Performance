//
//  LikeButton.swift
//  LoginForm
//
//  Created by Andrey on 17/08/2020.
//  Copyright © 2020 Andrey. All rights reserved.
//

import UIKit

class LikeButton: UIButton { // TODO: redo the button
    
    var filled: Bool = false {
        didSet {
            setNeedsDisplay()
//            print("filled has changed")
        }
    }
    
    var strokeWidth: CGFloat = 2.0 // TODO: to adjust
    
    var strokeColor: UIColor?
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let bezierPath = UIBezierPath(heartIn: self.bounds)
        
        if self.strokeColor != nil {
            self.strokeColor!.setStroke()
        } else {
            self.tintColor.setStroke()
        }
        
        
        bezierPath.lineWidth = self.strokeWidth
        bezierPath.stroke()
        
        context.saveGState()
        context.addPath(bezierPath.cgPath)
        context.restoreGState()
        
        if self.filled {
            self.tintColor.setFill()
            bezierPath.fill()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.isOpaque = false
        self.backgroundColor = .clear
        self.addTarget(self, action:#selector(buttonIsTapped), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isOpaque = false
        self.backgroundColor = .clear
        self.addTarget(self, action:#selector(buttonIsTapped), for: .touchUpInside)
    }
    
    
    
    @objc func buttonIsTapped() {
        //        print("button is tapped")
        if self.filled {
            self.filled = false
        } else {
            self.filled = true
        }
    }
    
}

extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()
        
        //Calculate Radius of Arcs using Pythagoras
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2
        
        //Left Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)
        
        //Top Centre Dip
        self.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))
        
        //Right Hand Curve
        self.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)
        
        //Right Bottom Line
        self.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))
        
        //Left Bottom Line
        self.close()
    }
}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
