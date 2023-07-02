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
    let fragmentUniformsBuffer: MTLBuffer
    
    var lastRenderTime: CFTimeInterval? = nil
    var currentTime: Double = 0
    
    init(device: MTLDevice) {
        self.device = device
        
        let vertexData = [
            Vertex(color: [1,0,0,1], pos: [-1, -1]),
            Vertex(color: [0,1,0,1], pos: [0, 1]),
            Vertex(color: [0,0,1,1], pos: [1, -1]),
        ]
        
        let dataSize = vertexData.count * MemoryLayout<Vertex>.stride
        self.vertexBuffer = self.device.makeBuffer(bytes: vertexData, length: dataSize, options: [])!
        
        var fragmentUniforms = FragmentUniforms(brightness: 1.0)
        self.fragmentUniformsBuffer = self.device.makeBuffer(bytes: &fragmentUniforms, length: MemoryLayout<FragmentUniforms>.stride)!
    }
    
    func update(systemtime: CFTimeInterval) {
        let timeDifference = (self.lastRenderTime == nil) ? 0 : systemtime - self.lastRenderTime!
        
        self.lastRenderTime = systemtime
        
        let ptr = self.fragmentUniformsBuffer.contents().bindMemory(to: FragmentUniforms.self, capacity: 1)
        ptr.pointee.brightness = Float(0.5 * cos(currentTime) + 0.5)
        currentTime += timeDifference
    }
}
