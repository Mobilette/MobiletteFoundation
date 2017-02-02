//
//  ViewController.swift
//  MBError
//
//  Created by Romain ASNAR on 19/11/15.
//  Copyright © 2015 Romain ASNAR. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try self.map("objects: []$$")
        }
        catch let error as MBError {
            print("error: \(error.error)")
        }
        catch _ {
            print("An error occured.")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func map(_ JSONString: String) throws
    {
        let mappingError = MappingError.canNotMapIntoObject(JSONString)
        print("Error: \(mappingError)")
        throw mappingError
    }
    
    enum MappingError: MBError
    {
        case canNotMapIntoObject(String)
        
        var code: Int {
            switch self {
            case .canNotMapIntoObject:
                return 3001
            }
        }
        
        var domain: String {
            return "MappingDomain"
        }
        
        var description: String {
            switch self {
            case .canNotMapIntoObject:
                return "Can not map objects."
            }
        }
        
        var reason: String {
            switch self {
            case .canNotMapIntoObject(let JSONString):
                return "'\(JSONString)' can not be mapped into an object."
            }
        }
    }

}

