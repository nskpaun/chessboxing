//
//  CBZMetalView.swift
//  ChessBoxing
//
//  Created by Nathan Spaun on 7/28/23.
//

import Cocoa
import MetalKit
import Foundation

class CBZMetalView: MTKView {
    var keys: [Int: Bool] = [:]
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    override func keyDown(with event: NSEvent) {
        let keyCode = Int(event.keyCode)
        print("got a key!")
        print(keyCode)
        keys[keyCode] = true
    }
    
    override func keyUp(with event: NSEvent) {
        let keyCode = Int(event.keyCode)
        print("got a keyup!")
        print(keyCode)
        keys[keyCode] = false
    }
}
