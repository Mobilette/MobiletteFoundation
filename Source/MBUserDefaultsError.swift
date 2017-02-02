//
//  MBUserDefaultsError.swift
//  MBError
//
//  Created by Romain ASNAR on 19/11/15.
//  Copyright © 2015 Romain ASNAR. All rights reserved.
//

import Foundation

public enum MBUserDefaultsError: MBError
{
    case unknown(Int)
    case canNotSynchronizeUserDefault
    
    public var code: Int {
        switch self {
        case .unknown:
            return 2000
        case .canNotSynchronizeUserDefault:
            return 2001
        }
    }
    
    public var domain: String {
        return "NSUserDefaultsDomain"
    }
    
    public var description: String {
        switch self {
        case .unknown:
            return "Unknown error."
        case .canNotSynchronizeUserDefault:
            return "Can not synchronize user defaults."
        }
    }
    
    public var reason: String {
        switch self {
        case .unknown(let status):
            return "An unknown error with status : \(status)."
        case .canNotSynchronizeUserDefault:
            return "."
        }
    }
}
