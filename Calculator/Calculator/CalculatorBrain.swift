//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Vadim Gribanov on 24/03/2017.
//  Copyright © 2017 Vadim Gribanov. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    enum CalculatorOperation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double, (String) -> String)
        case BinaryOperation((Double, Double) -> Double, (String, String) -> String, Int)
        case Equals
    }
    
    struct PendingBinaryOperationInfo {
        var firstOperand: Double
        var binaryFunction: (Double, Double) -> Double
        var descriptionOperand: String
        var descriptionFunction: (String, String) -> String
    }
    
    private var internalProgram = [AnyObject]()
    
    private let operations = [
        "π": CalculatorOperation.Constant(Double.pi),
        "e": CalculatorOperation.Constant(M_E),
        "√": CalculatorOperation.UnaryOperation(sqrt, { "√(\($0))" }),
        "cos": CalculatorOperation.UnaryOperation(cos, { "cos(\($0))" }),
        "sin": CalculatorOperation.UnaryOperation(sin, { "sin(\($0))" }),
        "ln": CalculatorOperation.UnaryOperation(log, { "ln(\($0))" }),
        "e^x": CalculatorOperation.UnaryOperation(exp, { "e^(\($0))" }),
        "±": CalculatorOperation.UnaryOperation({ -$0 }, { "-\($0)" }),
        "+": CalculatorOperation.BinaryOperation(+, { "\($0) + \($1)" }, 0),
        "-": CalculatorOperation.BinaryOperation(-, { "\($0) - \($1)" }, 0),
        "×": CalculatorOperation.BinaryOperation(*, { "\($0) × \($1)" }, 1),
        "÷": CalculatorOperation.BinaryOperation(/, { "\($0) ÷ \($1)"}, 1),
        "x^y": CalculatorOperation.BinaryOperation(pow, { "(\($0)) ^ \($1)" }, 2),
        "=": CalculatorOperation.Equals
    ]
    
    private var accumulator = 0.0
    private var descriptionAccumulator = "" {
        didSet {
            if pendingBinaryOperation == nil {
                currentPrecendence = Int.max
            }
        }
    }
    private var currentPrecendence = Int.max
    
    private var pendingBinaryOperation: PendingBinaryOperationInfo?
    
    public var isPartialResult: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    
    var variableValues: Dictionary<String, Double> = [:]
    
    func setOperand(_ operand: Double) {
        accumulator = operand
        descriptionAccumulator = String(accumulator)
        internalProgram.append(operand as AnyObject)
    }
    
    func setOperand(_ variableName: String) {
        variableValues[variableName] = variableValues[variableName] ?? 0.0
        accumulator = variableValues[variableName]!
        descriptionAccumulator = variableName
        internalProgram.append(variableName as AnyObject)
    }
    
    func perfomOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            internalProgram.append(symbol as AnyObject)
            switch operation {
            case .Constant(let value):
                accumulator = value
                descriptionAccumulator = symbol
            case .UnaryOperation(let function, let descriptionFunction):
                accumulator = function(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
            case .BinaryOperation(let function, let descriptionFunction, let precendence):
                executePendingBinaryOperation()
                if currentPrecendence < precendence {
                    descriptionAccumulator = "(\(descriptionAccumulator))"
                }
                currentPrecendence = precendence
                pendingBinaryOperation = PendingBinaryOperationInfo(
                    firstOperand: accumulator,
                    binaryFunction: function,
                    descriptionOperand: descriptionAccumulator,
                    descriptionFunction: descriptionFunction
                )
            case .Equals:
                executePendingBinaryOperation()
            }
        }
    }
    
    func executePendingBinaryOperation() {
        if pendingBinaryOperation != nil {
            accumulator = pendingBinaryOperation!.binaryFunction(pendingBinaryOperation!.firstOperand, accumulator)
            descriptionAccumulator = pendingBinaryOperation!.descriptionFunction(pendingBinaryOperation!.descriptionOperand, descriptionAccumulator)
            pendingBinaryOperation = nil
        }
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList
        }
        
        set {
            clearBrain()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        if operations[operation] != nil {
                            perfomOperation(operation)
                        } else {
                            setOperand(operation)
                        }
                    }
                }
            }
        }
    }
    
    
    func clearBrain() {
        accumulator = 0.0
        internalProgram.removeAll()
        pendingBinaryOperation = nil
        descriptionAccumulator = " "
    }
    
    func clearVariables() {
        variableValues.removeAll()
    }
    
    var description: String {
        get {
            if let pending = pendingBinaryOperation {
                return pending.descriptionFunction(pending.descriptionOperand, pending.descriptionOperand != descriptionAccumulator ? descriptionAccumulator : "")
            } else {
                return descriptionAccumulator
            }
        }
    }
    
}
