//
//  Renderer.swift
//  MetalTest
//
//  Created by MacBook Pro on 6/21/19.
//  Copyright © 2019 Borb. All rights reserved.
//

// Our platform independent renderer class

import Metal
import MetalKit
import simd

class Renderer: NSObject, MTKViewDelegate {
    public static var Instance: Renderer?
    
    private var metalView: MTKView!
    private var scene: Scene?
    
    private var commandQueue: MTLCommandQueue
    private var depthStencilState: MTLDepthStencilState!
    private var samplerState: MTLSamplerState!

    init?(metalView: MTKView!)
    {
        self.metalView = metalView
        metalView.depthStencilPixelFormat = .depth32Float_stencil8
        CoreData.setDevice(device: metalView.device!)
        commandQueue = CoreData.getDevice().makeCommandQueue()!
        super.init()
        depthStencilState =  buildDepthState()
        samplerState =  buildSamplerState()
        Renderer.Instance = self
        
    }
    
    func getTexture(_ imageName: String) -> MTLTexture?
    {
        let loader = MTKTextureLoader(device: CoreData.getDevice())
        var texture: MTLTexture? = nil
        do  {
            let textureUrl = Bundle.main.url(forResource: imageName, withExtension: nil)
            if textureUrl != nil
            {
                texture = try loader.newTexture(URL: textureUrl!, options: nil)
            }
            else {
                print("there is no image \(imageName)")
            }
        }
        catch{
            print("texture \(imageName) not created")
        }
        
        return texture
    }
    
    public func draw(in view: MTKView) {
        let drawable = view.currentDrawable!
        let commandBuffer = commandQueue.makeCommandBuffer()!
        let descriptor = view.currentRenderPassDescriptor!
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor:descriptor)!
        commandEncoder.setDepthStencilState(depthStencilState)
        commandEncoder.setFrontFacing(.counterClockwise)
        commandEncoder.setCullMode(.back)
        commandEncoder.setFragmentSamplerState(samplerState, index: 0)

        
        for rendarable in (scene?.getObjects())!
        {
            rendarable.draw(view: view,commandEncoder: commandEncoder)
        }
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }

    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    public func setRenderableScene(scene: Scene)
    {
        self.scene = scene
    }
    
    func buildDepthState() -> MTLDepthStencilState {
        let stateDescriptor = MTLDepthStencilDescriptor()
        stateDescriptor.depthCompareFunction = .less
        stateDescriptor.isDepthWriteEnabled = true
        
        return CoreData.getDevice().makeDepthStencilState(descriptor: stateDescriptor)!
    }
    
    func buildSamplerState() -> MTLSamplerState {
        let stateDescriptor = MTLSamplerDescriptor()
        stateDescriptor.minFilter = .linear
        stateDescriptor.magFilter = .linear
        return CoreData.getDevice().makeSamplerState(descriptor: stateDescriptor)!
    }
}
