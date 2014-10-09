//
//  HedgeHog.swift
//  MonkeyJump
//
//  Created by Kauserali on 09/10/14.
//  Copyright (c) 2014 PuneCocoa. All rights reserved.
//

import SpriteKit

class HedgeHog: SKSpriteNode {

    lazy var walkTextures: [SKTexture] = {
        var walkTextures = [SKTexture]()
        let atlas = SKTextureAtlas(named: "characteranimations")
        for index in 1...4 {
            let textureName = "enemy_hedgehog_walk\(index).png"
            let walkTexture = atlas.textureNamed(textureName)
            walkTextures.append(walkTexture)
        }
        return walkTextures
    }()
    
    class func hedgehog() -> HedgeHog {
        let atlas = SKTextureAtlas(named: "characteranimations")
        let snakeTexture = atlas.textureNamed("enemy_hedgehog_walk1.png")
        let hedgehog = HedgeHog(texture: snakeTexture)
        hedgehog.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(hedgehog.walkTextures, timePerFrame: 0.2)))
        return hedgehog
    }
}
