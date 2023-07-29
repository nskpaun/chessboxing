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
    let metalKitView: CBZMetalView
    var sceneGraph: [CBZSceneNode]
    
    var lastRenderTime: CFTimeInterval? = nil
    var currentTime: Double = 0
    
    init(device: MTLDevice, viewPort: CBZViewport, metalKitView: CBZMetalView) {
        self.metalKitView = metalKitView
        self.device = device
        self.viewPort = viewPort
        self.camera = CBZCamera()
        self.sceneGraph = [];
        
        self.sceneGraph.append(CBZTetrahedron(center: [-0.5,0.5,-1,0],scale: 0.5, angle: 1, axis: [0,0,1]))
        self.sceneGraph.append(CBZTetrahedron(center: [0.5,-0.5,-1,0],scale: 0.25, angle: 0, axis: [0,0,1]))
        
        var sceneVertices: [Vertex] = []
        var sceneIndices: [UInt32] = []
        var currentMaxIndex: UInt32 = 0
        for node in self.sceneGraph {
            sceneVertices.append(contentsOf: node.getVertexData())
            let indexData = node.getIndexData()
            var localMaxIndex: UInt32 = 0
            for idx in indexData {
                if (localMaxIndex < idx) {
                    localMaxIndex = idx
                }
                sceneIndices.append(idx + currentMaxIndex)
            }
            currentMaxIndex += UInt32(localMaxIndex) + 1
        }
        let dataSize = sceneVertices.count * MemoryLayout<Vertex>.stride
        self.vertexBuffer = self.device.makeBuffer(bytes: sceneVertices, length: dataSize, options: [])!
        
        self.indexBuffer = self.device.makeBuffer(bytes: sceneIndices, length: MemoryLayout<UInt32>.stride * sceneIndices.count)!
        
        var initVertexUniforms = VertexUniforms(
            projection_plane_z: self.viewPort.distanceFromCamera,
            canvas_height: self.viewPort.height,
            canvas_width: self.viewPort.width,
            viewport_size: 1,
            camera_transform: camera.getCameraTransform()
        )
        self.vertexUniformsBuffer = self.device.makeBuffer(bytes: &initVertexUniforms, length: MemoryLayout<VertexUniforms>.stride)!
        
        var fragmentUniforms = FragmentUniforms(brightness: 1.0)
        self.fragmentUniformsBuffer = self.device.makeBuffer(bytes: &fragmentUniforms, length: MemoryLayout<FragmentUniforms>.stride)!
        
    }
    
    func getIndexDataCount() -> Int {
        var result = 0;
        for node in self.sceneGraph {
            result += node.getIndexData().count
        }
        return result
    }
    
    func update(systemtime: CFTimeInterval) {
        let timeDifference = (self.lastRenderTime == nil) ? 0 : systemtime - self.lastRenderTime!
        
        self.lastRenderTime = systemtime
        
        // Camera Interactions
        self.camera.processInteractions(keys: metalKitView.keys)
        
//        camera.angle = Float(currentTime)
        
        let fptr = self.fragmentUniformsBuffer.contents().bindMemory(to: FragmentUniforms.self, capacity: 1)
//        fptr.pointee.brightness = Float(0.5 * cos(currentTime) + 0.5)
        
        let vptr = self.vertexUniformsBuffer.contents().bindMemory(to: VertexUniforms.self, capacity: 1)
        vptr.pointee.camera_transform = camera.getCameraTransform()
        
        currentTime += timeDifference
    }
}
