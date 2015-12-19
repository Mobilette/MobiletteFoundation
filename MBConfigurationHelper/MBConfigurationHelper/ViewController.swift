//
//  ViewController.swift
//  MBConfigurationHelper
//
//  Created by Romain ASNAR on 19/11/15.
//  Copyright © 2015 Romain ASNAR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let apiURL = MBConfigurationHelper.configuration("WEB_SERVICE_BASE_URL", key: "API_URL")
        print(apiURL ?? "No value for API_URL in configuration file.")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

