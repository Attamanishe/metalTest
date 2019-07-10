//
//   MaskedSprite.swift
//  MetalTest
//
//  Created by MacBook Pro on 6/28/19.
//  Copyright © 2019 Borb. All rights reserved.
//

import Foundation
import MetalKit

class MaskedSprite: Sprite
{
    var textureMask: MTLTexture?
    override func getFragmentShader() -> String {
        if texture == nil
        {
            return "fragment_shader"
        }else if textureMask == nil
        {
            return "textured_fragment_shader"
        }
        else
        {
            return "masked_textured_fragment_shader"
        }
    }
    
    init(imageName: String, maskImageName: String) {
        super.init(imageName: imageName)
        textureMask = getTexture(maskImageName)
        setup()
    }
    
    override func drawInternal(commandEncoder: MTLRenderCommandEncoder) {
        commandEncoder.setVertexBuffer(getVertexBuffer(), offset: 0, index: 0)
        var const = ModelConstants()
        const.modelViewMatrix = getModelMatrix() * const.modelViewMatrix
        const.modelViewMatrix = (Camera.Main!.viewMatrix) * const.modelViewMatrix
        const.modelViewMatrix = (Camera.Main!.projectionMatrix) * const.modelViewMatrix
        commandEncoder.setVertexBytes(&const, length: MemoryLayout<ModelConstants>.stride, index: 1)
        if texture != nil
        {
            commandEncoder.setFragmentTexture(texture, index: 0)
            commandEncoder.setFragmentTexture(textureMask, index: 1)
        }
        let indicesBuffer = getIndecesBuffer()
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: getIndecesCount(), indexType: .uint16, indexBuffer: indicesBuffer, indexBufferOffset: 0)
    }
}
