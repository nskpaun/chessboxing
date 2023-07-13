//
//  ChessBoxingTests.swift
//  ChessBoxingTests
//
//  Created by NathanSpaun on 6/19/23.
//

import XCTest
@testable import ChessBoxing

final class ChessBoxingTests: XCTestCase {
    
    var sceneModel: CBZSceneModel?

    override func setUpWithError() throws {
        let device: MTLDevice = MTLCreateSystemDefaultDevice()!
        self.sceneModel = CBZSceneModel(device: device, viewPort: CBZViewport(width: 1, height: 1, distanceFromCamera: 1))
    }

    override func tearDownWithError() throws {
        self.sceneModel = nil
    }

    func testExample() throws {
        let ptr = self.sceneModel?.fragmentUniformsBuffer.contents().bindMemory(to: FragmentUniforms.self, capacity: 1)
        
        XCTAssertTrue(ptr!.pointee.brightness == 1.0, "brigtness failed to initialize: \(ptr!.pointee.brightness)")
        
        // Initial frame pump to initialize the last frame time
        self.sceneModel?.update(systemtime: 1)
        
        // Second frame pump to update current time to a new current time
        self.sceneModel?.update(systemtime: 2)
        
        // Third frame pump with new current time
        self.sceneModel?.update(systemtime: 3)
        
        XCTAssertTrue(ptr!.pointee.brightness < 0.99, "brigtness failed to update: \(ptr!.pointee.brightness)")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testScaleMatrix() {
        let scaleMatrix = getScaleMatrix(scaleFactor: 2)
        XCTAssert(scaleMatrix[0][0] == 2)
    }
    
    func testRotationMatrix() {
        let identity = simd_float4x4(columns: (
            simd_float4(1, 0, 0, 0),
            simd_float4(0, 1, 0, 0),
            simd_float4(0, 0, 1, 0),
            simd_float4(0, 0, 0, 1)
        ))
        let ir = getRotationMatrix(axis: simd_float3(1,0,0), angle: 0);
        XCTAssert(areMatricesEqual(ir, identity))
        
        let t1 = simd_float4x4(columns: (
            simd_float4(1, 0, 0, 0),
            simd_float4(0, 0.5403, -0.84147, 0),
            simd_float4(0, 0.84147, 0.5403, 0),
            simd_float4(0, 0, 0, 1)
        ))
        let r1 = getRotationMatrix(axis: simd_float3(1,0,0), angle: 1);
        XCTAssert(areMatricesEqual(t1, r1))
        
        let t2 = simd_float4x4(columns: (
            simd_float4(-0.4161468, -0.6429704,  0.6429704, 0),
            simd_float4(0.6429704,  0.2919266,  0.7080734, 0),
            simd_float4(-0.6429704,  0.7080734,  0.2919266, 0),
            simd_float4(0, 0, 0, 1)
        ))
        let r2 = getRotationMatrix(axis: simd_float3(0,1,1), angle: 2);
        XCTAssert(areMatricesEqual(t2, r2))
    }
    
    func testTranslationMatrix() {
        let identity = simd_float4x4(columns: (
            simd_float4(1, 0, 0, 0),
            simd_float4(0, 1, 0, 0),
            simd_float4(0, 0, 1, 0),
            simd_float4(0, 0, 0, 1)
        ))
        let ir = getTranslationMatrix(translation: simd_float4(0,0,0,0))
        XCTAssert(areMatricesEqual(ir, identity))
        
        let t1 = simd_float4x4(columns: (
            simd_float4(1, 0, 0, 1),
            simd_float4(0, 1, 0, 2),
            simd_float4(0, 0, 1, 3),
            simd_float4(0, 0, 0, 1)
        ))
        let r1 = getTranslationMatrix(translation: simd_float4(1,2,3,0))
        XCTAssert(areMatricesEqual(t1, r1))
    }
    
    func testProjectionMatrix() {
        let identity = simd_float3x4(columns: (
            simd_float4(1, 0, 0, 0),
            simd_float4(0, 1, 0, 0),
            simd_float4(0, 0, 1, 0)
        ))
        let ir = getProjectionMatrix(projectionPlaneDepth: 1, vh: 1, ch: 1, vw: 1, cw: 1)
        XCTAssert(are3x4MatricesEqual(ir, identity))
        
        let t1 = simd_float3x4(columns: (
            simd_float4(0.5, 0, 0, 0),
            simd_float4(0, 0.5, 0, 0),
            simd_float4(0, 0, 1, 0)
        ))
        let r1 = getProjectionMatrix(projectionPlaneDepth: 0.5, vh: 1, ch: 1, vw: 1, cw: 1)
        XCTAssert(are3x4MatricesEqual(t1, r1))
    }
    
    func areMatricesEqual(_ matrix1: simd_float4x4, _ matrix2: simd_float4x4) -> Bool {
        for i in 0..<4 {
            for j in 0..<4 {
                if abs(matrix1[i][j] - matrix2[i][j]) > 0.001 {
                    return false
                }
            }
        }
        return true
    }
    
    func are3x4MatricesEqual(_ matrix1: simd_float3x4, _ matrix2: simd_float3x4) -> Bool {
        for i in 0..<3 {
            for j in 0..<4 {
                if abs(matrix1[i][j] - matrix2[i][j]) > 0.001 {
                    return false
                }
            }
        }
        return true
    }

}
