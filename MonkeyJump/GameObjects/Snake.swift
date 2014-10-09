//
//  Snake.swift
//  MonkeyJump
//
//  Created by Kauserali on 09/10/14.
//  Copyright (c) 2014 PuneCocoa. All rights reserved.
//

import SpriteKit

class Snake: SKSpriteNode {
    
    lazy var walkTextures: [SKTexture] = {
        var walkTextures = [SKTexture]()
        let atlas = SKTextureAtlas(named: "characteranimations")
        for index in 1...4 {
            let textureName = "enemy_snake_crawl\(index).png"
            let walkTexture = atlas.textureNamed(textureName)
            walkTextures.append(walkTexture)
        }
        return walkTextures
    }()
    
    class func snake() -> Snake {
        let atlas = SKTextureAtlas(named: "characteranimations")
        let snakeTexture = atlas.textureNamed("enemy_snake_crawl1.png")
        let snake = Snake(texture: snakeTexture)
        snake.runAction(SKAction.repeatActionForever(SKAction.animateWithTextures(snake.walkTextures, timePerFrame: 0.1)))
        return snake
    }
}
