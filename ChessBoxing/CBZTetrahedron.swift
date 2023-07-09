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
    
    init(center: simd_float3, angle: Float = 0, axis: simd_float3 = [0,0,1]) {
        var vertexPose = [
            Vertex(color: [1,0,0,1], pos: [center.x + -0.5, center.y + -0.5, center.z + 4, 1.0]),
            Vertex(color: [0,1,0,1], pos: [center.x +  0.0, center.y +  0.5, center.z + 4, 1.0]),
            Vertex(color: [0,0,1,1], pos: [center.x +  0.5, center.y + -0.5, center.z + 4, 1.0]),
            Vertex(color: [1,1,1,1], pos: [center.x +  0.0, center.y +  0.0, center.z + 3, 1.0]),
        ]
        
        for i in 0..<vertexPose.count {
            vertexPose[i].pos = rotateVector(vector: vertexPose[i].pos, angle: angle, axis: axis)
        }
        
        self.vertexData = vertexPose
        
        self.indexData = [
            0,1,2,
            0,1,3,
            0,2,3,
            1,2,3,
        ]
    }
}
