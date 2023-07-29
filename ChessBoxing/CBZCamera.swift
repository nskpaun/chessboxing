//
//  CBZCamera.swift
//  ChessBoxing
//
//  Created by NathanSpaun on 7/8/23.
//

import Foundation

class CBZCamera {
    var position: simd_float4
    var angle: Float
    var axis: simd_float3
    
    
    init() {
        self.position = [0,0,0,0]
        self.angle = 0
        self.axis = [0,0,1]
    }
    
    private func getInverseRotationMatrix() -> simd_float4x4 {
        let rotation = getRotationMatrix(axis: self.axis, angle: self.angle)
        return rotation.inverse
    }
    
    private func getInverseTranslationMatrix() -> simd_float4x4 {
        let translation = getTranslationMatrix(translation: position)
        return translation.inverse
    }
    
    func getCameraTransform() -> simd_float4x4 {
        let result = getInverseRotationMatrix() * getInverseTranslationMatrix()

        return result
    }
    
    func updateCameraPos(xDelta: Float = 0.0, yDelta: Float = 0.0, zDelta: Float = 0.0) {
        self.position = [
            self.position[0] + xDelta,
            self.position[1] + yDelta,
            self.position[2] + zDelta,
        ]
    }
}
