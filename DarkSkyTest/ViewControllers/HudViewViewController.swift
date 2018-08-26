//
//  HudViewViewController.swift
//  DarkSkyTest
//
//  Created by Shane Whitehead on 26/8/18.
//  Copyright © 2018 Beam Communications. All rights reserved.
//

import UIKit

class HudViewViewController: UIViewController {
	
	@IBOutlet weak var hudImageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		hudImageView.image = WeatherStyleKit.imageOfHorizonHud()
	}
	
}
