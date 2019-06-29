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
        }
    }
    
    var parameters: [URLQueryItem] {
        switch self {
        case .getContacts:
            return []
        }
    }
    
    var method: String {
        switch self {
        case .getContacts:
            return "GET"
        }
    }
}
