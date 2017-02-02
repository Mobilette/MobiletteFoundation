//
//  MBConfigurationHelper.swift
//  MBConfigurationHelper
//
//  Created by Romain ASNAR on 19/11/15.
//  Copyright © 2015 Romain ASNAR. All rights reserved.
//

import Foundation

open class MBConfigurationHelper
{
    open class func configuration(fileKey: String, key: String) -> String?
    {
        if let configuration = MBConfigurationHelper.configurationFile(fileKey: fileKey) {
            return configuration.object(forKey: key) as? String
        }
        return nil
    }
    
    open class func configurationFile(fileKey: String) -> NSDictionary?
    {
        let file = Bundle.main.object(forInfoDictionaryKey: fileKey) as? String
        if let path = Bundle.main.path(forResource: file, ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        return nil
    }
}
