//
//  Croc.swift
//  MonkeyJump
//
//  Created by Kauserali on 09/10/14.
//  Copyright (c) 2014 PuneCocoa. All rights reserved.
//

import SpriteKit

class Croc: SKSpriteNode {
    lazy var walkTextures: [SKTexture] = {
        var walkTextures = [SKTexture]()
        let atlas = SKTextureAtlas(named: "characteranimations")
        for index in 1...4 {
            let textureName = "enemy_croc_walk\(index).png"
            let walkTexture = atlas.textureNamed(textureName)
            walkTextures.append(walkTexture)
        }
        return walkTextures
    }()
    
    class func croc() -> Croc {
        let atlas = SKTextureAtlas(named: "characteranimations")
        let snakeTexture = atlas.textureNamed("enemy_croc_walk1.png")
        let croc = Croc(texture: snakeTexture)
        croc.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(croc.walkTextures, timePerFrame: 0.2)))
        return croc
    }
}
