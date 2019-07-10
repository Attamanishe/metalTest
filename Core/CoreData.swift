//
//  File.swift
//  MetalTest
//
//  Created by MacBook Pro on 6/26/19.
//  Copyright © 2019 Borb. All rights reserved.
//

import Foundation
import MetalKit

class CoreData {
    private static var device: MTLDevice!
    
    public static func setDevice(device: MTLDevice)
    {
        self.device = device
    }
    
    public static func getDevice()->MTLDevice
    {
        return self.device
    }
}
