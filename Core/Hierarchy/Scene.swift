//
//  Scene.swift
//  MetalTest
//
//  Created by MacBook Pro on 6/24/19.
//  Copyright © 2019 Borb. All rights reserved.
//

import Foundation

class SceneObject: Object {
    
    
    func getModelMatrix() -> matrix_float4x4 {
        var matrix = matrix4x4_translation(transform.position.x, transform.position.y, transform.position.z)
        matrix *= matrix4x4_rotation(transform.rotation.x.radians(), float3(1,0,0))
        matrix *= matrix4x4_rotation(transform.rotation.y.radians(), float3(0,1,0))
        matrix *= matrix4x4_rotation(transform.rotation.z.radians(), float3(0,0,1))
        matrix *= matrix4x4_scale(transform.scale.x,transform.scale.y,transform.scale.z)
        
        let parent = GetParent() as? SceneObject
        if parent != nil
        {
            return (parent?.getModelMatrix())! * matrix
        }
        return matrix
    }
}

class Scene: Object {
    
    override init() {
        super.init()
    }
    
    func getObjects() -> [Renderable] {
        var renderables = [Renderable]()
        for child in GetChilds()
        {
            renderables.append(contentsOf: getObjects(child))
        }
        
        return renderables
    }
    
    func getObjects(_ object : Object) -> [Renderable] {
        var renderables = [Renderable]()
        let result  = object as? Renderable
        if result != nil
        {
            renderables.append(result!)
        }

        for child in object.GetChilds()
        {
            renderables.append(contentsOf: getObjects(child))
        }

        return renderables
    }
    

}
