//
//  CBZCamera.swift
//  ChessBoxing
//
//  Created by NathanSpaun on 7/8/23.
//

import Foundation

class CBZCamera {
    var position: simd_float4
    var quaternion: simd_quatf
    
    
    init() {
        self.position = [0,0,0,0]

        // Create the normalized quaternion
        self.quaternion = simd_quatf(angle: 0.0, axis: [1, 0, 0])
    }
    
    private func getInverseRotationMatrix() -> simd_float4x4 {
        let rotation = getRotationMatrix(axis: self.quaternion.axis, angle: self.quaternion.angle)
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
    
    func processInteractions(keys: [Int: Bool]) {
        if(keys[SPACE_BAR] ?? false) {
            if (keys[UP_KEY] ?? false) {
                updateCameraPos(zDelta: -0.1)
                return
            }
            
            if (keys[DOWN_KEY] ?? false) {
                updateCameraPos(zDelta: 0.1)
                return
            }
            
            if (keys[LEFT_KEY] ?? false) {
                updateCameraRotation(deltaQuaternion: simd_quatf(angle: -0.1, axis: [0,0,1]))
                return
            }
            
            if (keys[RIGHT_KEY] ?? false) {
                updateCameraRotation(deltaQuaternion: simd_quatf(angle: 0.1, axis: [0,0,1]))
                return
            }
            return
        }
        
        if (keys[LEFT_KEY] ?? false) {
            updateCameraPos(xDelta: -0.1)
        }
        
        if (keys[RIGHT_KEY] ?? false) {
            updateCameraPos(xDelta: 0.1)
        }
        
        if (keys[UP_KEY] ?? false) {
            updateCameraPos(yDelta: -0.1)
        }
        
        if (keys[DOWN_KEY] ?? false) {
            updateCameraPos(yDelta: 0.1)
        }
        
        if (keys[A_KEY] ?? false) {
            updateCameraRotation(deltaQuaternion: simd_quatf(angle: 0.1, axis: [0,1,0]))
        }
        
        if (keys[D_KEY] ?? false) {
            updateCameraRotation(deltaQuaternion: simd_quatf(angle: -0.1, axis: [0,1,0]))
        }
        
        if (keys[W_KEY] ?? false) {
            updateCameraRotation(deltaQuaternion: simd_quatf(angle: -0.1, axis: [1,0,0]))
        }
        
        if (keys[S_KEY] ?? false) {
            updateCameraRotation(deltaQuaternion: simd_quatf(angle: 0.1, axis: [1,0,0]))
        }
    }
    
    func updateCameraRotation(deltaQuaternion: simd_quatf) {
        self.quaternion = self.quaternion * deltaQuaternion
    }
    
    func updateCameraPos(xDelta: Float = 0.0, yDelta: Float = 0.0, zDelta: Float = 0.0) {
        let posDeltaVec = simd_float4(
            xDelta,
            yDelta,
            zDelta,
            self.position[3]
        )
        
        let rotDelta = getRotationMatrix(axis: self.quaternion.axis, angle: self.quaternion.angle) * posDeltaVec
        self.position = self.position + rotDelta
    }
}
