//
//  GraphViewController.swift
//  Calculator
//
//  Created by Vadim Gribanov on 05/04/2017.
//  Copyright © 2017 Vadim Gribanov. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource {

    var program: AnyObject {
        get {
            return calculatorBrain.program
        }
        set {
            calculatorBrain.program = newValue
            navigationHeader.title = calculatorBrain.description
        }
    }
    
    @IBOutlet weak var navigationHeader: UINavigationItem!
    private var calculatorBrain = CalculatorBrain()
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            let panGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(GraphViewController.moveGraph(_:)))
            graphView.addGestureRecognizer(panGestureRecognizer)
            
            let pinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(GraphViewController.zoomGraph(_:)))
            graphView.addGestureRecognizer(pinchGestureRecognizer)
            
            let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(GraphViewController.tapGraph(_:)))
            graphView.addGestureRecognizer(tapGestureRecognizer)
        }
    }

    func getPoint(_ x: Double) -> Double? {
        calculatorBrain.variableValues["M"] = x
        calculatorBrain.program = calculatorBrain.program
        if calculatorBrain.result != Double.infinity {
            return calculatorBrain.result
        }
        return nil
    }
    
    func moveGraph(_ sender: UIPanGestureRecognizer) {
        graphView.move(sender)
    }
    
    func zoomGraph(_ sender: UIPinchGestureRecognizer) {
        graphView.zoom(sender)
    }
    
    func tapGraph(_ sender: UITapGestureRecognizer) {
        graphView.tap(sender)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
