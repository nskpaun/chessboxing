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
        self.axis = [1,0,0]
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
        print(result)
        return result
    }
}
