//
//  ViewController.swift
//  BridgeDemo
//
//  Created by tstone10 on 2019/4/18.
//  Copyright © 2019 wenslow. All rights reserved.
//

import UIKit
import BridgeTestFramework

class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let bridgeVC = BridgeViewController(colorService: ColorService())
        present(bridgeVC, animated: true, completion: nil)
    }
}

protocol ColorLayer {
    func backgroundColor() -> UIColor
}

class ColorService: ColorLayer, BridgeTestFrameworkColorLayer {
    func backgroundColor() -> UIColor {
        return .red
    }
}
