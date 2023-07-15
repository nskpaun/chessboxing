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

func getRotationMatrix(axis: simd_float3, angle: Float) -> simd_float4x4 {
    let normalizedAxis = normalize(axis)

    // Convert the angle to radians
    let radians = angle

    // Calculate the quaternion components
    let halfAngle = radians * 0.5
    let sinHalfAngle = sin(halfAngle)
    let cosHalfAngle = cos(halfAngle)

    // Calculate the quaternion
    let quaternion = simd_float4(normalizedAxis.x * sinHalfAngle,
                                 normalizedAxis.y * sinHalfAngle,
                                 normalizedAxis.z * sinHalfAngle,
                                 cosHalfAngle)

    // Calculate the rotation matrix
    let x2 = quaternion.x * quaternion.x
    let y2 = quaternion.y * quaternion.y
    let z2 = quaternion.z * quaternion.z
    let xy = quaternion.x * quaternion.y
    let xz = quaternion.x * quaternion.z
    let yz = quaternion.y * quaternion.z
    let wx = quaternion.w * quaternion.x
    let wy = quaternion.w * quaternion.y
    let wz = quaternion.w * quaternion.z

    let rotationMatrix = simd_float4x4(columns: (
        simd_float4(1 - 2 * (y2 + z2), 2 * (xy - wz), 2 * (xz + wy), 0.0),
        simd_float4(2 * (xy + wz), 1 - 2 * (x2 + z2), 2 * (yz - wx), 0.0),
        simd_float4(2 * (xz - wy), 2 * (yz + wx), 1 - 2 * (x2 + y2), 0.0),
        simd_float4(0.0, 0.0, 0.0, 1.0)
        ))
    return rotationMatrix
}

func getScaleMatrix(scaleFactor: Float) -> simd_float4x4 {
    return simd_float4x4(rows: [
        simd_float4(scaleFactor, 0, 0, 0),
        simd_float4(0, scaleFactor, 0, 0),
        simd_float4(0, 0, scaleFactor, 0),
        simd_float4(0, 0, 0, 1)
    ])
}

func getTranslationMatrix(translation: simd_float4) -> simd_float4x4 {
    assert(translation[3] == 0)
    return simd_float4x4(rows: [
        simd_float4(1, 0, 0, translation.x),
        simd_float4(0, 1, 0, translation.y),
        simd_float4(0, 0, 1, translation.z),
        simd_float4(0, 0, 0, 1)
    ])
}

func getProjectionMatrix(projectionPlaneDepth: Float, vh: Float, ch: Float, vw: Float, cw:Float) -> simd_float4x3 {
    return simd_float4x3(rows: [
        simd_float4(projectionPlaneDepth*cw/vw, 0, 0, 0),
        simd_float4(0, projectionPlaneDepth*ch/vh, 0, 0),
        simd_float4(0, 0, 1, 0)
    ])
}
