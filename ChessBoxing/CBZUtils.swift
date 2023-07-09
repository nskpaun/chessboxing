//
//  CBZUtils.swift
//  ChessBoxing
//
//  Created by NathanSpaun on 7/8/23.
//

import Foundation

func rotateVector(vector: simd_float4, angle: Float, axis: simd_float3) -> simd_float4 {
    let halfAngle = angle / 2.0
    let quaternion = simd_quatf(angle: halfAngle, axis: axis)
    
    let conjugateQuaternion = simd_conjugate(quaternion)
    
    let vectorQuaternion = simd_quatf(vector: vector)
    
    let rotatedQuaternion = quaternion * vectorQuaternion * conjugateQuaternion
    
    return rotatedQuaternion.vector
}
