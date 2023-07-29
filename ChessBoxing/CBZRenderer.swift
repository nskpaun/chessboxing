//
//  CBZRenderer.swift
//  ChessBoxing
//
//  Created by NathanSpaun on 6/28/23.
//

import Foundation
import MetalKit

class CBZRenderer: NSObject, MTKViewDelegate {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let sceneModel: CBZSceneModel
    let depthTexture: MTLTexture
    let depthStencilState: MTLDepthStencilState
    var renderPipelineState: MTLRenderPipelineState?
    var viewportSize: simd_float2
    let gpuLock = DispatchSemaphore(value: 1)
    
    
    init?(metalKitView: CBZMetalView) {
        self.device = metalKitView.device!
        self.viewportSize = simd_float2(x: Float(metalKitView.drawableSize.width), y: Float(metalKitView.drawableSize.height))
        let viewport = CBZViewport(width: viewportSize.x, height: viewportSize.y, distanceFromCamera: 1.0)
        let depthDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .depth32Float,
                                                                       width: Int(viewport.width),
                                                                       height: Int(viewport.height),
                                                                        mipmapped: false)
        
        depthDescriptor.usage = [.renderTarget, .shaderRead]
        depthDescriptor.storageMode = .private
        
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilDescriptor.isDepthWriteEnabled = true

        self.depthStencilState = device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
        self.depthTexture = device.makeTexture(descriptor: depthDescriptor)!
        self.commandQueue = self.device.makeCommandQueue()!
        
        self.sceneModel = CBZSceneModel(device: self.device, viewPort: viewport, metalKitView: metalKitView)
        super.init()
        
        let library = self.device.makeDefaultLibrary()
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalKitView.colorPixelFormat
        
        self.renderPipelineState = try! self.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
       
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // This method is called when the drawable size (i.e., the view's size) changes.
        // You can update any resources or configurations related to the new size here.
    }
    
    func draw(in view: MTKView) {
        gpuLock.wait()
        
        self.sceneModel.update(systemtime: CACurrentMediaTime())
        
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor else {
            NSLog("Error on getting descriptor")
            return
        }
        descriptor.depthAttachment.texture = depthTexture
        guard let commandBuffer = self.commandQueue.makeCommandBuffer() else {
            NSLog("Error on getting command buffer")
            return
        }
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
            NSLog("Error on getting command encoder")
            return
        }
        
        commandEncoder.setDepthStencilState(depthStencilState)
        commandEncoder.setRenderPipelineState(self.renderPipelineState!)
        commandEncoder.setVertexBuffer(self.sceneModel.vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBuffer(self.sceneModel.vertexUniformsBuffer, offset: 0, index: 1)
        commandEncoder.setFragmentBuffer(self.sceneModel.fragmentUniformsBuffer, offset: 0, index: 0)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: self.sceneModel.getIndexDataCount(), indexType: MTLIndexType.uint32, indexBuffer: self.sceneModel.indexBuffer, indexBufferOffset: 0)
        
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.addCompletedHandler { _ in
            self.gpuLock.signal()
        }
        commandBuffer.commit()
    }
    
    
}
