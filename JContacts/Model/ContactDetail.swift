//
//  ContactDetailModel.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

//Note : Represents only the details that are incremental to Contact model

struct ContactDetail: Codable {
    let email: String
    let phoneNumber: String
    let creationDate: String
    let modificationDate: String
    
    private enum CodingKeys: String, CodingKey {
        case email
        case phoneNumber = "phone_number"
        case creationDate = "created_at"
        case modificationDate = "updated_at"
    }
}
