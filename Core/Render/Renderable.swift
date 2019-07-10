//
//  Renderable.swift
//  MetalTest
//
//  Created by MacBook Pro on 6/26/19.
//  Copyright © 2019 Borb. All rights reserved.
//

import Foundation
import MetalKit

protocol Renderable
{
    var pipelineState : MTLRenderPipelineState! {get set}
    func setup()
    func getVertexShader() -> String
    func getFragmentShader() -> String
    func getVertexBuffer() -> MTLBuffer
    func getIndecesBuffer() -> MTLBuffer
    func getIndecesCount() -> Int
    func drawInternal(commandEncoder: MTLRenderCommandEncoder)
}

extension Renderable
{
    func buildPipelineState() -> MTLRenderPipelineState
    {
        var pipelineState : MTLRenderPipelineState?
        let liblary = CoreData.getDevice().makeDefaultLibrary();
        let vertexFunction = liblary?.makeFunction(name: getVertexShader())
        let fragmentFunction = liblary?.makeFunction(name:  getFragmentShader())
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()

        pipelineDescriptor.vertexFunction = vertexFunction;
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float_stencil8
        pipelineDescriptor.stencilAttachmentPixelFormat = .depth32Float_stencil8
        let renderAttachment = pipelineDescriptor.colorAttachments[0]
        renderAttachment?.isBlendingEnabled = true
        renderAttachment?.alphaBlendOperation = .add
        renderAttachment?.rgbBlendOperation = .add
        renderAttachment?.sourceRGBBlendFactor = .sourceAlpha
        renderAttachment?.sourceAlphaBlendFactor = .sourceAlpha
        renderAttachment?.destinationRGBBlendFactor = .oneMinusSourceAlpha
        renderAttachment?.destinationAlphaBlendFactor = .oneMinusSourceAlpha
        pipelineDescriptor.vertexDescriptor = Vertex.GetVertexDescriptor()
        
        do{
            pipelineState = try CoreData.getDevice().makeRenderPipelineState(descriptor: pipelineDescriptor)
            
        }catch let error as NSError
        {
            print("error:\(error.localizedDescription)")
        }
        return pipelineState!
    }
    
    func draw(view: MTKView,commandEncoder: MTLRenderCommandEncoder) {
        commandEncoder.setRenderPipelineState(pipelineState)
        drawInternal(commandEncoder: commandEncoder)
    }
}

