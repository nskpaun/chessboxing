//
//  CBZTetrahedron.swift
//  ChessBoxing
//
//  Created by NathanSpaun on 7/8/23.
//

import Foundation

class CBZTetrahedron {
    let vertexData: [Vertex]
    let indexData: [UInt32]
    
    init(center: simd_float4, scale: Float = 1, angle: Float = 0, axis: simd_float3 = [0,0,1]) {
        
        let rotationMatrix = getRotationMatrix(axis: axis, angle: angle)
        let scaleMatrix = getScaleMatrix(scaleFactor: scale)
        let translationMatrix = getTranslationMatrix(translation: center)
        let transformMatrix = rotationMatrix * scaleMatrix * translationMatrix
        
        let vertexPose = [
            Vertex(color: [1,0,0,1], pos: transformMatrix * simd_float4(-0.5, -0.5, 4, 1.0)),
            Vertex(color: [0,1,0,1], pos: transformMatrix * [0.0, 0.5, 4, 1.0]),
            Vertex(color: [0,0,1,1], pos: transformMatrix * [0.5, -0.5, 4, 1.0]),
            Vertex(color: [1,1,1,1], pos: transformMatrix * [0.0, 0.0, 3, 1.0]),
        ]
        
        self.vertexData = vertexPose
        
        self.indexData = [
            0,1,2,
            0,1,3,
            0,2,3,
            1,2,3,
        ]
    }
}
