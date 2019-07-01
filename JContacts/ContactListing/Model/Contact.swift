//
//  Contact.swift
//  JContactsTests
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

struct Contact: Codable {
    var id: Int
    var firstName: String
    var lastName: String
    var avatar: String
    var isFavorite: Bool
    var email: String?
    var phoneNumber: String?
    
    public var fullName: String {
        return "\(firstName.capitalized) \(lastName.capitalized)"
    }
    
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "profile_pic"
        case isFavorite = "favorite"
        case email = "email"
        case phoneNumber = "phone_number"
    }
}
