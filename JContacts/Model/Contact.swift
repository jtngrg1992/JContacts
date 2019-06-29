//
//  Contact.swift
//  JContactsTests
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

struct Contact: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let avatar: String
    let isFavorite: Bool
    let detailURL: String
    
    public var fullName: String {
        return "\(firstName.capitalized) \(lastName.capitalized)"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar = "profile_pic"
        case isFavorite = "favorite"
        case detailURL = "url"
    }
}
