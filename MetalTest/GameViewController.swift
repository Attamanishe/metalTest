//
//  GameViewController.swift
//  MetalTest
//
//  Created by MacBook Pro on 6/21/19.
//  Copyright © 2019 Borb. All rights reserved.
//

import Cocoa
import MetalKit

// Our macOS specific view controller
class GameViewController: NSViewController {

    var renderer: Renderer!
    var metalView: MTKView!
    var scene: Scene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        metalView = view as? MTKView
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.clearColor = Colors.black
        renderer = Renderer(metalView: metalView)
        metalView.delegate = renderer
        scene = Scene()
        scene.AddChild(child: Camera())
        var sprite = Sprite(imageName: "test.png")
        sprite.transform.scale = float3(5,5,5)
        sprite.transform.position = float3(0,0,0)
        //scene.AddChild(child: sprite)
       
        var cub = Cube(imageName: "test2.png")
        scene.AddChild(child: cub)
        var cub2 = Cube(imageName: "test2.png")
        cub.AddChild(child: cub2)
        cub.transform.position = float3(0,0,0)
        sprite = Sprite(imageName: "test2.png")
        cub2.transform.position = float3(0,0,2)
        Camera.Main?.transform.position = float3(0,0,20)
//        var mask = MaskedSprite(imageName: "test4.png",maskImageName: "test2.png")
//
//        mask.transform.scale = float3(1,1,1)
//        mask.transform.rotation = float3(0,60,0)
//        //mask.transform.position = float3(3,0,3)
//        scene.AddChild(child: mask)

//         //sprite.transform.rotation = float3(0,0,-45)
//        sprite = Sprite(imageName: "test.png")
//       // sprite.transform.scale = float3(1,0.5,0.5)
//       // sprite.transform.position = float3(-2,0,0)
//       // sprite.transform.rotation = float3(45,0,0)
//        mask.AddChild(child: sprite)
//
//        sprite = Sprite(imageName: "test.png")
//       // sprite.transform.scale = float3(0.5,0.5,0.5)
//      //  sprite.transform.position = float3(0,-1,0)
//        mask.AddChild(child: sprite)
        
        Renderer.Instance?.setRenderableScene(scene: scene)
    }
}
