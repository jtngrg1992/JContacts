//
//  Images.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import UIKit

enum Images: String {
    case avatarPlaceholder = "placeholder_photo"
    case isFavouriteHome = "home_favourite"
    case isFavouriteDetail = "favourite_button_selected"
    case isNotFavouriteDetail = "favourite_button"
    
    public var equivalentImage: UIImage? {
        return UIImage(named: self.rawValue)
    }
    
}
