//
//  MBOAuthCredential.swift
//  MBOAuthCredential
//
//  Created by Romain ASNAR on 19/11/15.
//  Copyright © 2015 Romain ASNAR. All rights reserved.
//

import Foundation
import Security

open class MBOAuthCredential: NSObject, NSCoding
{
    // MARK: - Type
    
    fileprivate struct CodingKeys {
        static let base = Bundle.main.bundleIdentifier! + "."
        static let userIdentifier = base + "user_identifier"
        static let accessToken = base + "access_token"
        static let expirationDate = base + "expiration_date"
        static let refreshToken = base + "refresh_token"
    }
    
    // MARK: - Property
    
    open var userIdentifier: String? = nil
    
    open var token: String? {
        if self.isExpired() {
            return nil
        }
        return self.accessToken
    }
    
    open var refreshToken: String? = nil
    
    open var expirationDate: Date? = nil
    
    open var archivedOAuthCredential: Data {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
    
    fileprivate var accessToken: String? = nil
    
    // MARK: - Life cycle
    
    public init(userIdentifier: String,
        accessToken: String,
        refreshToken: String,
        expirationDate: Date? = nil
        )
    {
        self.userIdentifier = userIdentifier
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expirationDate = expirationDate
    }
    
    // MARK: - NSCoding protocol
    
    @objc required public init?(coder decoder: NSCoder)
    {
        self.userIdentifier = decoder.decodeObject(forKey: CodingKeys.userIdentifier) as? String
        self.accessToken = decoder.decodeObject(forKey: CodingKeys.accessToken) as? String
        self.expirationDate = decoder.decodeObject(forKey: CodingKeys.expirationDate) as? Date
        self.refreshToken = decoder.decodeObject(forKey: CodingKeys.refreshToken) as? String
    }
    
    @objc open func encode(with coder: NSCoder)
    {
        coder.encode(self.userIdentifier, forKey: CodingKeys.userIdentifier)
        coder.encode(self.accessToken, forKey: CodingKeys.accessToken)
        coder.encode(self.expirationDate, forKey: CodingKeys.expirationDate)
        coder.encode(self.refreshToken, forKey: CodingKeys.refreshToken)
    }
    
    // MARK: - Archiving
    
    open func storeToKeychain() throws
    {
        guard let userIdentifier = self.userIdentifier,
            let _ = self.accessToken,
            let _ = self.refreshToken
            else {
                throw MBOAuthCredentialError.badCredentials
        }
        
        let query = [
            "\(kSecClass)"          : "\(kSecClassGenericPassword)",
            "\(kSecAttrAccount)"    : userIdentifier,
            "\(kSecValueData)"      : self.archivedOAuthCredential
            ] as NSDictionary
        
        let secItemDeleteStatus = SecItemDelete(query as CFDictionary)
        if secItemDeleteStatus != noErr && secItemDeleteStatus != errSecItemNotFound {
            throw MBOAuthCredentialError.unknown(Int(secItemDeleteStatus))
        }
        
        let secItemAddStatus = SecItemAdd(query as CFDictionary, nil)
        if secItemAddStatus != noErr {
            throw MBOAuthCredentialError.unknown(Int(secItemAddStatus))
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(userIdentifier, forKey: "mb_user_identifier")
        
        let synchronizeResult = userDefaults.synchronize()
        if synchronizeResult == false {
            throw MBUserDefaultsError.canNotSynchronizeUserDefault
        }
    }
    
    open class func retreiveCredential(
        userIdentifier: String? = nil
        ) throws -> MBOAuthCredential
    {
        let identifier: String
        if let _userIdentifier = userIdentifier {
            identifier = _userIdentifier
        }
        else {
            guard let _userIdentifier = self.userIdentifierFromNSUserDefaults() else {
                throw MBOAuthCredentialError.userIdentifierMissing
            }
            identifier = _userIdentifier
        }
        
        let searchQuery = [
            "\(kSecClass)"          : "\(kSecClassGenericPassword)",
            "\(kSecAttrAccount)"    : identifier,
            "\(kSecReturnData)"     : true
            ] as NSDictionary
        
        var result: AnyObject?
        let secItemCopyStatus = SecItemCopyMatching(searchQuery, &result)
        if secItemCopyStatus != noErr {
            throw MBOAuthCredentialError.unknown(Int(secItemCopyStatus))
        }
        guard let retrievedData = result as? Data else {
            throw MBOAuthCredentialError.canNotCopy
        }
        guard let credential = NSKeyedUnarchiver.unarchiveObject(with: retrievedData) as? MBOAuthCredential else {
            throw MBOAuthCredentialError.canNotUnarchiveObject
        }
        return credential
    }
    
    fileprivate class func userIdentifierFromNSUserDefaults() -> String?
    {
        let userDefaults = UserDefaults.standard
        if let identifier = userDefaults.object(forKey: "mb_user_identifier") as? String {
            return identifier
        }
        return nil
    }
    
    // MARK: - Authentication
    
    open func isAuthenticated() -> Bool
    {
        let hasAccessToken = (self.accessToken != nil)
        return (hasAccessToken) && (!self.isExpired())
    }
    
    open func isExpired() -> Bool
    {
        if let expirationDate = self.expirationDate {
            let today = Date()
            let isExpired = (expirationDate.compare(today) == ComparisonResult.orderedAscending)
            return isExpired
        }
        return false
    }
}

public enum MBOAuthCredentialError: MBError
{
    case unknown(Int)
    case badCredentials
    case badResults()
    case userIdentifierMissing
    case canNotUnarchiveObject
    case canNotCopy
    
    public var code: Int {
        switch self {
        case .unknown:
            return 1000
        case .badCredentials:
            return 1001
        case .badResults:
            return 1002
        case .userIdentifierMissing:
            return 1003
        case .canNotUnarchiveObject:
            return 1004
        case .canNotCopy:
            return 1005
        }
    }
    
    public var domain: String {
        return "OAuthCredentialDomain"
    }
    
    public var description: String {
        switch self {
        case .unknown:
            return "Unknown error."
        case .badCredentials:
            return "Bad credentials."
        case .badResults:
            return "Bad results."
        case .userIdentifierMissing:
            return "User identifier missing"
        case .canNotUnarchiveObject:
            return "Can not unarchive object."
        case .canNotCopy:
            return "Can not copy."
        }
    }
    
    public var reason: String {
        switch self {
        case .unknown(let status):
            return "Security function throw error with status : \(status)."
        case .badCredentials:
            return ""
        case .badResults:
            return ""
        case .userIdentifierMissing:
            return ""
        case .canNotUnarchiveObject:
            return ""
        case .canNotCopy:
            return ""
        }
    }
}
