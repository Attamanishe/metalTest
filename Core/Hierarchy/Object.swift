//
//  Object.swift
//  MetalTest
//
//  Created by MacBook Pro on 6/24/19.
//  Copyright © 2019 Borb. All rights reserved.
//

import Foundation

protocol IObject
{
    func GetID() -> Int
    func GetName() -> String
    func GetParent() -> Object?
    func GetChilds() -> [Object]
    func AddChild(child: Object)
}

protocol IDestructible {
    func Destroy()
}

protocol TransformChangeDelegate {
    func onChange(transform: Transform)
}

class Transform
{
    public var transformChangeDelegate:TransformChangeDelegate?
    var position: float3 = float3(0,0,0)
    {
        didSet
        {
            transformChangeDelegate?.onChange(transform: self)
        }
    }
    var scale: float3 = float3(1,1,1)
    {
        didSet
        {
            transformChangeDelegate?.onChange(transform: self)
        }
    }
    var rotation: float3 = float3(0,0,0)
    {
        didSet
        {
            transformChangeDelegate?.onChange(transform: self)
        }
    }
}

class Object: NSObject {
    
    public var transform: Transform { get { return _transform } }
    
    private var _transform: Transform = Transform()
    
    private var _name: String = ""
    private var _id: Int = 0
    
    private var _parent: Object?
    private var _childs: [Object] = [Object]()
    
    override init() {
        super.init()
    }
}

extension Object: IObject {
    
    func AddChild(child: Object) {
        child._parent = self
        _childs.append(child)
    }
    
    func GetName() -> String {
        return _name
    }
    
    
    func GetParent() -> Object? {
        return _parent
    }
    
    func GetChilds() -> [Object] {
        return _childs
    }
    
    
    func GetID() -> Int {
        return self.hashValue
    }
}

extension Object: IDestructible
{
    func Destroy() {
        
        let parent = GetParent()
        if (parent != nil)
        {
            var childs = parent!.GetChilds()
            childs.remove(at: (childs.firstIndex(of: self))!)
        }
        for child in self.GetChilds() {
            child.Destroy()
        }
    }
}

