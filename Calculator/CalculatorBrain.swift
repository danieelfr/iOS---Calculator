//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Daniel on 4/18/17.
//  Copyright © 2017 DanielFR. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    private var accumulator = 0.0
    private var pending: PenddingBinaryOperationInfo?
    private var internalProgram = [AnyObject]()
    
    
    func setOperand(operand:Double) {
        
        accumulator = operand
        internalProgram.append(operand)
    }
    
    private var operations: Dictionary<String, Operation> = [
    
        "Pi" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "x" : Operation.BinaryOperation({$0 * $1}),
        "=" : Operation.Equals,
        "/" : Operation.BinaryOperation({$0 / $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1})
    ]
    
    private enum Operation {
        
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        
        internalProgram.append(symbol)
        
        if let operation = operations[symbol] {
        
            switch operation {
            
            case .Constant(let value) :
                accumulator = value
                
            case .UnaryOperation (let function) :
                accumulator = function(accumulator)
                
            case .BinaryOperation (let function) :
                pending = PenddingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                
            case .Equals :
                executePendingBinaryOperation()
                
            }
        
        }
        
    }
    
    private func executePendingBinaryOperation() {
    
        if pending != nil {
            
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
        
    }
    
    private struct PenddingBinaryOperationInfo {
        
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram 
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }                    
                }
            }
        }
    }
    
    func clear()
    {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        
        get { return accumulator }
        
    }
}

