//
//  GameScene.swift
//  MonkeyJump
//
//  Created by Kauserali on 09/10/14.
//  Copyright (c) 2014 PuneCocoa. All rights reserved.
//

import SpriteKit

@objc protocol GameSceneDelegate {
    func gameOver(#score: Double)
}
class GameScene: SKScene {
    
    let BackgroundScrollSpeed: Double = 170
    let MonkeySpeed: Double = 20
    let jumpSound = SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false)
    let hurtSound = SKAction.playSoundFileNamed("hurt.mp3", waitForCompletion: false)
    
    var monkey: Monkey!
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    var livesLabel: SKLabelNode!
    var distanceLabel: SKLabelNode!
    
    var previousTime: CFTimeInterval = 0
    var nextSpawn: CFTimeInterval = 0
    var difficultyMeasure: Double = 1
    var distance: Double = 0
    var jumping: Bool = false
    var invincible: Bool = false
    
    weak var gameSceneDelegate: GameSceneDelegate?
    
    override func didMoveToView(view: SKView) {
        background1 = childNodeWithName("background1") as SKSpriteNode
        background2 = childNodeWithName("background2") as SKSpriteNode
        livesLabel = childNodeWithName("lives_label") as SKLabelNode
        distanceLabel = childNodeWithName("distance_label") as SKLabelNode
        
        monkey = Monkey.monkey()
        monkey.position = CGPoint(x: 70, y: 86)
        addChild(monkey)
        monkey.state = .Walking
        
        distanceLabel.text = "Distance:0"
        livesLabel.text = "Lives:\(monkey.noOfLives)"
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        if !jumping {
            jumping = true
            runAction(jumpSound)
            monkey.state = .Jumping
            
            let jumpUpAction = SKAction.moveByX(0, y: 120, duration: 0.6)
            let reverse = jumpUpAction.reversedAction()
            let action = SKAction.sequence([jumpUpAction, reverse])
            monkey.runAction(action, completion: {
                self.jumping = false
                self.monkey.state = .Walking
            })
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if monkey.state == MonkeyState.Dead {
            println("You're dead")
            return
        }
        if previousTime == 0 {
            previousTime = currentTime
        }
        
        let deltaTime = currentTime - previousTime
        previousTime = currentTime
        let xOffset = BackgroundScrollSpeed * -1 * deltaTime
        
        if background1.position.x < (background1.size.width * -1) {
            background1.position = CGPoint(x: background2.position.x + background2.size.width, y: background1.size.height/2)
        }
        if background2.position.x < (background2.size.width * -1) {
            background2.position = CGPoint(x: background1.position.x + background1.size.width, y: background2.size.height/2)
        }
        background1.position = CGPoint(x: background1.position.x + CGFloat(xOffset), y: background1.position.y)
        background2.position = CGPoint(x: background2.position.x + CGFloat(xOffset), y: background2.position.y)
        
        distance += MonkeySpeed * deltaTime
        distanceLabel.text = "Distance:\(Int(distance))"
        
        if currentTime > nextSpawn {
            let enemyType = arc4random() % 3
            
            var enemySprite: SKSpriteNode?
            
            switch(enemyType) {
            case 0:
                enemySprite = Snake.snake()
            case 1:
                enemySprite = Croc.croc()
            case 2:
                enemySprite = HedgeHog.hedgehog()
            default:
                println("Thats weird..how did this happen?")
            }
            
            if let enemy = enemySprite {
                enemy.position = CGPoint(x: size.width + enemy.size.width/2, y: 70)
                
                addChild(enemy)
                enemy.runAction(SKAction.moveBy(CGVectorMake(-size.width - enemy.size.width/2, 0), duration: 3), completion: {
                    enemy.removeFromParent()
                })
            }
            
            let randomInterval = 4/difficultyMeasure
            nextSpawn = currentTime + randomInterval
            
            if difficultyMeasure < 2.22 {
                difficultyMeasure = difficultyMeasure + 0.122
            }
        }
        
        if !invincible {
            for sprite in children as [SKNode] {
                if sprite is Monkey {
                    continue
                } else if (sprite is Snake) || (sprite is Croc) || (sprite is HedgeHog) {
                    let enemyRect = CGRectInset(sprite.frame, 10, 10)
                    if CGRectIntersectsRect(monkey.frame, enemyRect) {
                        invincible = true
                        monkey.noOfLives -= 1
                        
                        livesLabel.text = "Lives:\(monkey.noOfLives)"
                        if monkey.noOfLives <= 0 {
                            monkey.state = .Dead
                            userInteractionEnabled = false
                            self.monkeyDead()
                            return
                        }
                        
                        runAction(hurtSound)
                        
                        let fadeOut = SKAction.fadeOutWithDuration(0.187)
                        let fadeIn = fadeOut.reversedAction()
                        let blinkAnimation = SKAction.sequence([fadeOut, fadeIn])
                        let repeatBlink = SKAction.repeatAction(blinkAnimation, count: 4)
                        monkey.runAction(repeatBlink, completion: {
                            self.invincible = false
                            self.monkey.state = .Walking
                        })
                        break
                    }
                }
            }
        }
    }
    
    func monkeyDead() {
        gameSceneDelegate?.gameOver(score: distance)
    }
}

