//
//  TwitterRouter.swift
//  MBRouterProtocol
//
//  Created by Romain ASNAR on 19/11/15.
//  Copyright © 2015 Romain ASNAR. All rights reserved.
//

import Foundation
import Alamofire

protocol TwitterRouterProtocolV2: RouterProtocol {
}

extension TwitterRouterProtocolV2 {
    var version: String {
        return "v2"
    }
    var baseURLString: String? {
        if let baseURLStringFromConfiguration = self.baseURLStringFromConfiguration {
            return "\(baseURLStringFromConfiguration)/\(self.version)"
        }
        return "http://api.twitter.com/\(self.version)"
    }
}

enum UserRouter: TwitterRouterProtocolV2, URLRequestConvertible
{
    case create([String: AnyObject])
    case update(String, [String: AnyObject])
    
    var method: Alamofire.Method {
        switch self {
        case .create:
            return .POST
        case .update:
            return .PATCH
        }
    }
    
    var resource: String {
        return "user"
    }
    
    var path: String {
        switch self {
        case .create:
            return "/\(resource)/"
        case .update(let identifier, _):
            return "/\(resource)/\(identifier)/"
        }
    }
    
    // MARK: - URLRequestConvertible
    
    var URLRequest: NSMutableURLRequest {
        let mutableURLRequest: NSMutableURLRequest = self.baseURLRequest
        
        switch self {
        case .create(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .update(_, let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        }
    }
}
