//
//  File.swift
//  ChessBoxing
//
//  Created by Nathan Spaun on 7/15/23.
//

import Foundation

public protocol CBZSceneNode {
    func getVertexData() -> [Vertex]
    func getIndexData() -> [UInt32]
}
