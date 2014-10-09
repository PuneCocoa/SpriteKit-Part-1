//
//  GameViewController.swift
//  MonkeyJump
//
//  Created by Kauserali on 09/10/14.
//  Copyright (c) 2014 PuneCocoa. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, GameSceneDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            scene.gameSceneDelegate = self
        }
    }

    // MARK: GameSceneDelegate method
    func gameOver(#score: Double) {
        if let gameOverViewController = storyboard?.instantiateViewControllerWithIdentifier("GameOverViewController") as? GameOverViewController {
            gameOverViewController.distance = score
            navigationController?.pushViewController(gameOverViewController, animated: true)
        }
    }
}
