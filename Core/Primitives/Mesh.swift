//
//  Mesh.swift
//  MetalTest
//
//  Created by MacBook Pro on 6/26/19.
//  Copyright © 2019 Borb. All rights reserved.
//

import Foundation
import MetalKit

class Mesh {
    var vertexBuffer: MTLBuffer!
    var indecesBuffer: MTLBuffer!
    var indecesCount: Int {
        get {
            return indeces.count
        }
    }
    private var vertices: [Vertex] = [Vertex]()
    private var indeces: [UInt16] = [UInt16]()
    
    init(_ vertices: [Vertex], _ indeces: [UInt16]) {
        self.indeces = indeces
        self.vertices = vertices
        vertexBuffer = CoreData.getDevice().makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])!
        indecesBuffer = CoreData.getDevice().makeBuffer(bytes: indeces, length: indeces.count * MemoryLayout<UInt16>.stride, options: [])!
    }
}
