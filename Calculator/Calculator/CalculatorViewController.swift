//
//  ViewController.swift
//  Calculator
//
//  Created by Vadim Gribanov on 23/03/2017.
//  Copyright © 2017 Vadim Gribanov. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    
    var calculatorBrain = CalculatorBrain()
    
    var userIsInTheMiddleOfTyping = false
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue)
            history.text = calculatorBrain.description + (calculatorBrain.isPartialResult ? "..." : "=")
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping || digit == "." && display.text!.range(of: ".") == nil {
            display.text = display.text! + digit
        } else if digit != "." {
            display.text = digit
        }
        
        userIsInTheMiddleOfTyping = true
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if (userIsInTheMiddleOfTyping) {
            calculatorBrain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let symbol = sender.currentTitle {
            calculatorBrain.perfomOperation(symbol)
        }
        displayValue = calculatorBrain.result
    }
    
    @IBAction func undo() {
        if (userIsInTheMiddleOfTyping) {
            let _ = display.text!.characters.popLast()
        } else {
            var program = calculatorBrain.program as! [AnyObject]
            let _ = program.popLast()
            calculatorBrain.program = program as CalculatorBrain.PropertyList
            displayValue = calculatorBrain.result
        }
    }
    
    @IBAction func cleanCalculator(_ sender: UIButton) {
        calculatorBrain.clearVariables()
        calculatorBrain.clearBrain()
        userIsInTheMiddleOfTyping = false
        display.text = "0"
        history.text = " "
    }
    
    @IBAction func useVariable() {
        calculatorBrain.setOperand("M")
        displayValue = calculatorBrain.result
    }
    
    @IBAction func setVariable() {
        userIsInTheMiddleOfTyping = false
        calculatorBrain.variableValues["M"] = displayValue
        calculatorBrain.program = calculatorBrain.program
        displayValue = calculatorBrain.result
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Show Graph" {
            return !calculatorBrain.isPartialResult
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationController = segue.destination
        if let navigationController = destinationController as? UINavigationController {
            destinationController = navigationController.visibleViewController!
        }
        
        if let graphViewController = destinationController as? GraphViewController, let identifier = segue.identifier {
            switch identifier {
            case "Show Graph":
                graphViewController.program = calculatorBrain.program
            default:
                break
            }
        }
    }
    
    
}

