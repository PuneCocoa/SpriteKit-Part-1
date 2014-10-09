//
//  GameOverViewController.swift
//  MonkeyJump
//
//  Created by Kauserali on 10/10/14.
//  Copyright (c) 2014 PuneCocoa. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {

    var distance: Double!
    @IBOutlet weak var distanceCompletedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        distanceCompletedLabel.text = "Distance completed:\(Int(distance))"
    }
    
    @IBAction func mainMenuButtonPressed(sender: UIButton) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
