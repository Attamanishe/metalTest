//
//  Camera.swift
//  MetalTest
//
//  Created by MacBook Pro on 7/2/19.
//  Copyright © 2019 Borb. All rights reserved.
//

import Foundation
class Camera: SceneObject, TransformChangeDelegate
{
    func onChange(transform: Transform) {
         updateViewMatrix()
    }
    
    public static var Main:Camera?

    public var farPlane: Float = 100
    {
        didSet
        {
            updateProjectionMatrix()
        }
    }
    
    public var nearPlane: Float = 0
    {
        didSet
        {
            updateProjectionMatrix()
        }
    }
    
    public var fieldsOfView: Float = Float(45).radians()
    {
        didSet
        {
            updateProjectionMatrix()
        }
    }
    
    public var aspect: Float = 1.5
    {
        didSet
        {
            updateProjectionMatrix()
        }
    }
    
    public var viewMatrix: matrix_float4x4!
    public var projectionMatrix: matrix_float4x4!
    
    override init()
    {
        super.init()
        Camera.Main = self
        updateViewMatrix()
        updateProjectionMatrix()
        transform.transformChangeDelegate = self
    }
    
    private func updateViewMatrix()
    {
        var matrix = getModelMatrix()
        if matrix[3][0] != 0
        {
            matrix[3][0] *= -1
        }
        if matrix[3][1] != 0
        {
            matrix[3][1] *= -1
        }
        if matrix[3][2] != 0
        {
            matrix[3][2] *= -1
        }
        viewMatrix = matrix
    }
    
    private func updateProjectionMatrix()
    {
        projectionMatrix = matrix_perspective_right_hand(fovyRadians: fieldsOfView, aspectRatio: aspect, nearZ: nearPlane, farZ: farPlane)
    }
}
