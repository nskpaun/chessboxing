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
    let indexBuffer: MTLBuffer
    let camera: CBZCamera
    let viewPort: CBZViewport
    let tetrahedron: CBZTetrahedron
    
    var lastRenderTime: CFTimeInterval? = nil
    var currentTime: Double = 0
    
    init(device: MTLDevice, viewPort: CBZViewport) {
        self.device = device
        self.viewPort = viewPort
        self.camera = CBZCamera()
        
        self.tetrahedron = CBZTetrahedron(center: [-0.5,0.5,-1,0],scale: 0.5, angle: 1, axis: [0,0,1])
        
        let dataSize = self.tetrahedron.vertexData.count * MemoryLayout<Vertex>.stride
        self.vertexBuffer = self.device.makeBuffer(bytes: self.tetrahedron.vertexData, length: dataSize, options: [])!
        
        
        self.indexBuffer = self.device.makeBuffer(bytes: self.tetrahedron.indexData, length: MemoryLayout<UInt32>.stride * self.tetrahedron.indexData.count)!
        
        var initVertexUniforms = VertexUniforms(
            projection_plane_z: self.viewPort.distanceFromCamera,
            canvas_height: self.viewPort.height,
            canvas_width: self.viewPort.width,
            viewport_size: 1
        )
        self.vertexUniformsBuffer = self.device.makeBuffer(bytes: &initVertexUniforms, length: MemoryLayout<VertexUniforms>.stride)!
        
        var fragmentUniforms = FragmentUniforms(brightness: 1.0)
        self.fragmentUniformsBuffer = self.device.makeBuffer(bytes: &fragmentUniforms, length: MemoryLayout<FragmentUniforms>.stride)!
        
    }
    
    func getIndexDataCount() -> Int {
        return self.tetrahedron.indexData.count
    }
    
    func update(systemtime: CFTimeInterval) {
        let timeDifference = (self.lastRenderTime == nil) ? 0 : systemtime - self.lastRenderTime!
        
        self.lastRenderTime = systemtime
        
        let ptr = self.fragmentUniformsBuffer.contents().bindMemory(to: FragmentUniforms.self, capacity: 1)
        ptr.pointee.brightness = Float(0.5 * cos(currentTime) + 0.5)
        
        currentTime += timeDifference
    }
}
