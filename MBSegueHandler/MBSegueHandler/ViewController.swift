//
//  ViewController.swift
//  MBSegueHandler
//
//  Created by Romain ASNAR on 19/11/15.
//  Copyright © 2015 Romain ASNAR. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SegueHandlerType {

    enum SegueIdentifier: String {
        case ShowRed
        case ShowBlue
        case ShowMagic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segueIdentifierForSegue(segue) {
        case .ShowRed:
            print("ShowRed")
        case .ShowBlue:
            print("ShowBlue")
        case .ShowMagic:
            print("ShowMagic")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func doSomethingMagic(_ sender: AnyObject!) {
        performSegueWithIdentifier(.ShowMagic, sender: nil)
    }
}

