//
//  GraphView.swift
//  Calculator
//
//  Created by Vadim Gribanov on 05/04/2017.
//  Copyright © 2017 Vadim Gribanov. All rights reserved.
//

import UIKit


protocol GraphViewDataSource {
    
    func getPoint(_ x: Double) -> Double?
    
}

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable
    var color: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var axesColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var scale: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var lineWidth: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var origin: CGPoint = CGPoint.zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var dataSource: GraphViewDataSource?
    
    
    
    override func draw(_ rect: CGRect) {
        let graphCurve = UIBezierPath()
        let minX = Int(rect.minX)
        let maxX = Int(rect.maxX)
        var beginning = true
        for rectX in minX...maxX {
            let graphX = (Double(rectX) - Double(origin.x)) / Double(scale)
            if let graphY = dataSource?.getPoint(graphX) {
                let rectY = Double(origin.y) - graphY * Double(scale)
                let to = CGPoint(x: CGFloat(rectX), y: CGFloat(rectY))
                if beginning {
                    graphCurve.move(to: to)
                    beginning = false
                } else {
                    graphCurve.addLine(to: to)
                }
            } else {
                beginning = true
            }
        }
        color.set()
        graphCurve.lineWidth = lineWidth
        graphCurve.stroke()
        
        let axesDrawer = AxesDrawer(color: axesColor, contentScaleFactor: super.contentScaleFactor)
        axesDrawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
    }
    
    
    func move(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.translation(in: self)
            self.origin.x += translation.x
            self.origin.y += translation.y
            sender.setTranslation(CGPoint.zero, in: self)
        }
    }
    
    func zoom(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let translation = sender.scale
            sender.scale = 1.0
            self.scale *= translation
        }
    }
    
    func tap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let translation = sender.location(in: self)
            self.origin.x = translation.x
            self.origin.y = translation.y
        }
    }
    
}
