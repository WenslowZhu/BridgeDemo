//
//  BridgeViewController.swift
//  BridgeTestFramework
//
//  Created by tstone10 on 2019/4/18.
//  Copyright © 2019 wenslow. All rights reserved.
//

import UIKit

public protocol BridgeTestFrameworkColorLayer {
    func backgroundColor() -> UIColor
}

public class BridgeViewController: UIViewController {
    
    let colorService: BridgeTestFrameworkColorLayer
    
    public init(colorService: BridgeTestFrameworkColorLayer) {
        self.colorService = colorService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorService.backgroundColor()
    }
}
