//
//  File.swift
//  MetalTest
//
//  Created by MacBook Pro on 7/2/19.
//  Copyright © 2019 Borb. All rights reserved.
//

import Foundation

protocol Updatable
{
    func preUpdate()
    func update()
    func postUpdate()
}
