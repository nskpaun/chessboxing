//
//  CBZTetrahedron.swift
//  ChessBoxing
//
//  Created by NathanSpaun on 7/8/23.
//

import Foundation

class CBZTetrahedron : CBZSceneNode {
    let indexData: [UInt32]
    
    var center: simd_float4
    var scale: Float
    var angle: Float
    var axis: simd_float3
    
    init(center: simd_float4, scale: Float = 1, angle: Float = 0, axis: simd_float3 = [0,0,1]) {
        self.center = center
        self.scale = scale
        self.angle = angle
        self.axis = axis
        
        self.indexData = [
            0,1,2,
            0,1,3,
            0,2,3,
            1,2,3,
        ]
    }
    
    func getIndexData() -> [UInt32] {
        return self.indexData
    }
    
    func getVertexData() -> [Vertex] {
        let rotationMatrix = getRotationMatrix(axis: axis, angle: angle)
        let scaleMatrix = getScaleMatrix(scaleFactor: scale)
        let translationMatrix = getTranslationMatrix(translation: center)
        let transformMatrix = rotationMatrix * scaleMatrix * translationMatrix
        
        let vertexPose = [
            Vertex(color: [1,0,0,1], pos: transformMatrix * [-0.5, -0.5, 4, 1.0]),
            Vertex(color: [0,1,0,1], pos: transformMatrix * [0.0, 0.5, 4, 1.0]),
            Vertex(color: [0,0,1,1], pos: transformMatrix * [0.5, -0.5, 4, 1.0]),
            Vertex(color: [1,1,1,1], pos: transformMatrix * [0.0, 0.0, 3, 1.0]),
        ]
        
        return vertexPose
    }
}
