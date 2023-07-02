//
//  CBZSceneModel.swift
//  ChessBoxing
//
//  Created by NathanSpaun on 7/1/23.
//

import Foundation
import MetalKit

class CBZSceneModel {
    
    let device: MTLDevice
    let vertexBuffer: MTLBuffer
    let vertexUniformsBuffer: MTLBuffer
    let fragmentUniformsBuffer: MTLBuffer
    
    var lastRenderTime: CFTimeInterval? = nil
    var currentTime: Double = 0
    
    init(device: MTLDevice) {
        self.device = device
        
        let vertexData = [
            Vertex(color: [1,0,0,1], pos: [-0.5, -0.5]),
            Vertex(color: [0,1,0,1], pos: [0, 0.5]),
            Vertex(color: [0,0,1,1], pos: [0.5, -0.5]),
        ]
        
        let dataSize = vertexData.count * MemoryLayout<Vertex>.stride
        self.vertexBuffer = self.device.makeBuffer(bytes: vertexData, length: dataSize, options: [])!
        
        var initVertexUniforms = VertexUniforms(rotation_matrix: CBZSceneModel.rotationMatrix(angle: 1.0))
        self.vertexUniformsBuffer = self.device.makeBuffer(bytes: &initVertexUniforms, length: MemoryLayout<VertexUniforms>.stride)!
        
        var fragmentUniforms = FragmentUniforms(brightness: 0.0)
        self.fragmentUniformsBuffer = self.device.makeBuffer(bytes: &fragmentUniforms, length: MemoryLayout<FragmentUniforms>.stride)!
        
    }
    
    func update(systemtime: CFTimeInterval) {
        let timeDifference = (self.lastRenderTime == nil) ? 0 : systemtime - self.lastRenderTime!
        
        self.lastRenderTime = systemtime
        
        let ptr = self.fragmentUniformsBuffer.contents().bindMemory(to: FragmentUniforms.self, capacity: 1)
        ptr.pointee.brightness = Float(0.5 * cos(currentTime) + 0.5)
        
        let vu_ptr = self.vertexUniformsBuffer.contents().bindMemory(to: VertexUniforms.self, capacity: 1)
        vu_ptr.pointee.rotation_matrix = CBZSceneModel.rotationMatrix(angle: currentTime)
        currentTime += timeDifference
    }
    
    static func rotationMatrix(angle: Double) -> simd_float2x2 {
        let cosAngle = Float(cos(angle));
        let sinAngle = Float(sin(angle));
        
        let matrix = simd_float2x2(columns: (simd_float2(cosAngle, sinAngle), simd_float2(-sinAngle, cosAngle)))
        
        return matrix
    }
}
