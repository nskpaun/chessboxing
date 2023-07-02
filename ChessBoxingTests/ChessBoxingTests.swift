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
        self.sceneModel = CBZSceneModel(device: device)
    }

    override func tearDownWithError() throws {
        self.sceneModel = nil
    }

    func testExample() throws {
        let ptr = self.sceneModel?.fragmentUniformsBuffer.contents().bindMemory(to: FragmentUniforms.self, capacity: 1)
        
        XCTAssertTrue(ptr!.pointee.brightness == 1.0, "brigtness failed to initialize")
        
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

}
