//
//  CBZViewport.swift
//  ChessBoxing
//
//  Created by NathanSpaun on 7/8/23.
//

import Foundation

class CBZViewport {
    let width: Float
    let height: Float
    let distanceFromCamera: Float
    init(width: Float, height: Float, distanceFromCamera: Float) {
        self.width = width
        self.height = height
        self.distanceFromCamera = distanceFromCamera
    }
}
