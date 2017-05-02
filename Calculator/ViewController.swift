//
//  ViewController.swift
//  Calculator
//
//  Created by Daniel on 4/17/17.
//  Copyright © 2017 DanielFR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var brain = CalculatorBrain()
    private var userIsInTheMiddleOfTyping = false
    private var displayValue: Double {
        get { return Double(display.text!)! }
        set { display.text = String(newValue) }
    }
    
    @IBOutlet private weak var display: UILabel!
    
    @IBAction private func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
    
            let textCurrentInDisplay = display.text!
            display.text = textCurrentInDisplay + digit
            
        }
        else {
            
            display.text = digit
        }
        
       self.userIsInTheMiddleOfTyping = true
    }    
    
    @IBAction private func performOperation(sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            
            brain.setOperand(displayValue)
            self.userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            
            brain.performOperation(mathematicalSymbol)
            
        }
        
        displayValue = brain.result
    }
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    
    @IBAction func GetSavedValue() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction func SaveValue() {
        savedProgram = brain.program
    }
    
}

