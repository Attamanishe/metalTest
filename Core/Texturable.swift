//
// Created by MacBook Pro on 2019-06-26.
// Copyright (c) 2019 Borb. All rights reserved.
//

import Foundation
import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get set }
}

extension Texturable
{
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
}
