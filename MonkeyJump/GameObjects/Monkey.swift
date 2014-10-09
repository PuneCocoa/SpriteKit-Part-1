//
//  Monkey.swift
//  MonkeyJump
//
//  Created by Kauserali on 09/10/14.
//  Copyright (c) 2014 PuneCocoa. All rights reserved.
//

import SpriteKit

enum MonkeyState: Int, Printable {
    case Idle, Walking, Jumping, Dead
    
    var description: String {
        get {
            switch(self) {
                case .Idle:
                    return "Idle"
                case .Walking:
                    return "Walking"
                case .Jumping:
                    return "Jumping"
                case .Dead:
                    return "Dead"
            }
        }
    }
}

class Monkey: SKSpriteNode {
    var noOfLives: Int = 3
    
    lazy var walkTextures: [SKTexture] = {
        var walkTextures = [SKTexture]()
        let atlas = SKTextureAtlas(named: "characteranimations")
        for index in 1...8 {
            let textureName = "monkey_run\(index).png"
            let walkTexture = atlas.textureNamed(textureName)
            walkTextures.append(walkTexture)
        }
        return walkTextures
    }()
    
    lazy var jumpTextures: [SKTexture] = {
        var jumpTextures = [SKTexture]()
        let atlas = SKTextureAtlas(named: "characteranimations")
        for index in 1...4 {
            let textureName = "monkey_jump\(index).png"
            let walkTexture = atlas.textureNamed(textureName)
            jumpTextures.append(walkTexture)
        }
        return jumpTextures
    }()
    
    var state: MonkeyState = MonkeyState.Idle {
        didSet {
            var animation: SKAction?
            
            if state != oldValue {
                switch(state) {
                    case .Walking:
                        animation = SKAction.repeatActionForever(SKAction.animateWithTextures(walkTextures, timePerFrame: 0.08))
                    case .Jumping:
                        animation = SKAction.animateWithTextures(jumpTextures, timePerFrame: 0.1)
                    case .Dead:
                        removeAllActions()
                        let atlas = SKTextureAtlas(named: "characteranimations")
                        texture = atlas.textureNamed("monkey_dead.png")
                    default:
                        removeAllActions()
                        let atlas = SKTextureAtlas(named: "characteranimations")
                        texture = atlas.textureNamed("monkey_run1.png")
                }
            }
            
            if let anim = animation {
                removeAllActions()
                runAction(anim)
            }
        }
    }
    
    class func monkey() -> Monkey {
        let atlas = SKTextureAtlas(named: "characteranimations")
        let monkeyTexture = atlas.textureNamed("monkey_run1.png")
        return Monkey(texture: monkeyTexture)
    }
}
