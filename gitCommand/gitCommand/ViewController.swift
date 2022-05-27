//
//  ViewController.swift
//  Created on 2021/12/15
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2021 Zepp Health. All rights reserved.
//  @author <#zepp.health#>(<#zepp.health#>@zepp.com)   
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        test()
        test2()
    }
    
    func test() {
        let value = 1
        debugPrint("\(value)")
    }
    
    func test2() {
        let value = 2
        debugPrint("\(value)")
    }
}

