//
//  ViewController.swift
//  MBOAuthCredential
//
//  Created by Romain ASNAR on 19/11/15.
//  Copyright © 2015 Romain ASNAR. All rights reserved.
//

import UIKit
import MobiletteFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.credentialDemo()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func credentialDemo()
    {
        do {
            let credentialWithError = try MBOAuthCredential.retreiveCredential()
        }
        catch let error as MBError {
            print("error: \(error.error)")
        }
        catch _ {
            print("An error occured.")
        }
        
        let credential = MBOAuthCredential(userIdentifier: "romsi", accessToken: "42", refreshToken: "43")
        do {
            try credential.storeToKeychain()
        }
        catch let error as MBError {
            print("error: \(error.error)")
        }
        catch _ {
            print("An error occured.")
        }
        
        let credentialWithoutError: MBOAuthCredential
        do {
            credentialWithoutError = try MBOAuthCredential.retreiveCredential(userIdentifier: "romsi")
        }
        catch let error as MBError {
            print("error: \(error.error)")
            return
        }
        catch _ {
            print("An error occured.")
            return
        }
        
        print(credentialWithoutError.token ?? "No access token.")
    }
}

