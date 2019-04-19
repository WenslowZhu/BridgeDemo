//
//  ViewController.swift
//  BridgeDemo
//
//  Created by tstone10 on 2019/4/18.
//  Copyright © 2019 wenslow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

protocol ColorLayer {
    func backgroundColor() -> UIColor
}

class ColorService: ColorLayer {
    func backgroundColor() -> UIColor {
        return .white
    }
}
