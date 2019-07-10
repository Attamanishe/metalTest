//
//  Sprite.swift
//  MetalTest
//
//  Created by MacBook Pro on 6/26/19.
//  Copyright © 2019 Borb. All rights reserved.
//

import Foundation
import MetalKit

class Sprite: SceneObject, Texturable, Renderable {
    var pipelineState: MTLRenderPipelineState!

    var texture: MTLTexture?
    
    private var meshComponent: MeshComponent!
    
    func getIndecesCount() -> Int {
        return meshComponent.mesh?.indecesCount ?? 0
    }
    
    func getVertexShader() -> String {
       return "vertex_shader"
    }
    
    func setup() {
        pipelineState = buildPipelineState()
    }
    
    func getFragmentShader() -> String {
        if texture == nil
        {
            return "fragment_shader"
        }
        return "textured_fragment_shader"
    }
    
    func getVertexBuffer() -> MTLBuffer {
        return meshComponent.mesh!.vertexBuffer
    }
    
    func getIndecesBuffer() -> MTLBuffer {
        return meshComponent.mesh!.indecesBuffer
    }
    
    init(imageName: String) {
        super.init()
        texture = getTexture(imageName)
        setup()
        let mesh = Mesh(
            [
                Vertex(position: float3(-1, 1, 0), color: float4(1, 1, 1, 1),texture: float2(0,1)),
                Vertex(position: float3(1, 1, 0), color: float4(1, 1, 1, 1),texture: float2(1,1)),
                Vertex(position: float3(1, -1, 0), color: float4(1, 1, 1, 1),texture: float2(1,0)),
                Vertex(position: float3(-1, -1, 0), color: float4(1, 1, 1, 1),texture: float2(0,0)),
            ],
            [
                0, 1, 2,
                2, 3, 0
            ]
        )
        meshComponent = MeshComponent();
        meshComponent.mesh = mesh
    }
    
    func drawInternal(commandEncoder: MTLRenderCommandEncoder) {
        commandEncoder.setVertexBuffer(getVertexBuffer(), offset: 0, index: 0)
        var const = ModelConstants()
        const.modelViewMatrix = getModelMatrix() * const.modelViewMatrix
        const.modelViewMatrix = (Camera.Main!.viewMatrix) * const.modelViewMatrix
        const.modelViewMatrix = (Camera.Main!.projectionMatrix) * const.modelViewMatrix
        commandEncoder.setVertexBytes(&const, length: MemoryLayout<ModelConstants>.stride, index: 1)
        if texture != nil
        {
            commandEncoder.setFragmentTexture(texture, index: 0)
        }
        let indicesBuffer = getIndecesBuffer()
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: getIndecesCount(), indexType: .uint16, indexBuffer: indicesBuffer, indexBufferOffset: 0)
    }
}
