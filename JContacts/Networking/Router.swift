//
//  Router.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation


enum Router {
    case getContacts
    case getContactDetail(Int)
    case updateContact(Contact)
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "gojek-contacts-app.herokuapp.com"
    }
    
    var path: String {
        switch self {
        case .getContacts:
            return "/contacts.json"
        case .getContactDetail(let contactID):
            return "/contacts/\(contactID).json"
        case .updateContact(let contact):
            return "/contacts/\(contact.id).json"
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getContacts, .getContactDetail(_ ), .updateContact(_):
            return []
        }
    }
    
    var httpBody: [String:Any]? {
        switch self {
        case .getContacts, .getContactDetail(_ ):
            return nil
        case .updateContact(let contact):
            var parameterDictionary: [String:Any] = [
                "first_name" : contact.firstName,
                "last_name" : contact.lastName,
                "favorite" : contact.isFavorite
            ]
            
            if let _ = URL(string: contact.avatar) {
                //to prevent contact existing picture from being removed if no picture was provided in update
                parameterDictionary["profile_pic"] = contact.avatar
            }
            
            if let phoneNumber = contact.details?.phoneNumber {
                parameterDictionary["phone_number"] = phoneNumber
            }
            
            if let email = contact.details?.email {
                parameterDictionary["email"] = email
            }
            
            return parameterDictionary
        }
    }
    
    var method: String {
        switch self {
        case .getContacts, .getContactDetail(_ ):
            return "GET"
        case .updateContact(_):
            return "PUT"
        }
    }
}
