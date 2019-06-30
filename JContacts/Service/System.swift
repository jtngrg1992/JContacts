//
//  System.swift
//  JContacts
//
//  Created by Jatin Garg on 30/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

enum SystemError: Error {
    case invalidPhoneNumber
    case urlConstructionFailed
    case unableToOpenURL
    case invalidEmail
}

extension SystemError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber:
            return Strings.INVALID_PHONE
        case .urlConstructionFailed:
            return Strings.FAILED_URL_CONSTRUCTION
        case .unableToOpenURL:
            return Strings.FAILED_URL_CONSTRUCTION
        case .invalidEmail:
            return Strings.INVALID_EMAIL
        }
    }
}

class System {
    private static var application = UIApplication.shared
    
    private class func obtainPhoneNumber(from contact: Contact) throws -> String {
        guard let phoneNumber = contact.phoneNumber,
            phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines).count >= 10
            else{
                throw SystemError.invalidPhoneNumber
        }
        return phoneNumber
    }
    
    public class func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    private class func obtainEmail(from contact: Contact) throws -> String {
        guard
            let email = contact.email,
            isValidEmail(email)
            else{
                throw SystemError.invalidEmail
        }
        return email
    }
    
    class func sayHello(to contact: Contact) throws {
        let phoneNumber = try obtainPhoneNumber(from: contact)
        let sms = "sms:\(phoneNumber)"
        guard
            let url = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let convertedURL = URL(string: url)
            else {
                throw SystemError.urlConstructionFailed
        }
        if application.canOpenURL(convertedURL) {
            application.open(convertedURL, options: [:], completionHandler: nil)
        }else{
            throw SystemError.unableToOpenURL
        }
        
    }
    
    class func placeACall(with contact: Contact) throws {
        let phoneNumber = try obtainPhoneNumber(from: contact)
        let string = "tel://\(phoneNumber)"
        guard
            let url = URL(string: string)
            else{
                throw SystemError.urlConstructionFailed
        }
        if application.canOpenURL(url) {
            application.open(url, options: [:], completionHandler: nil)
        }else{
            throw SystemError.unableToOpenURL
        }
    }
    
    class func sendEmail(to contact: Contact) throws {
        let email = try obtainEmail(from: contact)
        guard let url = URL(string: "mailto:\(email)") else {
            throw SystemError.urlConstructionFailed
        }
        
        if application.canOpenURL(url) {
            application.open(url, options: [:], completionHandler: nil)
        }else{
            throw SystemError.unableToOpenURL
        }
    }
}
