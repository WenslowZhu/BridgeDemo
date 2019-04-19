//
//  BridgeViewController.swift
//  BridgeTestFramework
//
//  Created by tstone10 on 2019/4/18.
//  Copyright © 2019 wenslow. All rights reserved.
//

import UIKit

public class BridgeViewController: UIViewController {
    
    let colorService = ColorService()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorService.backgroundColor()
    }
}
