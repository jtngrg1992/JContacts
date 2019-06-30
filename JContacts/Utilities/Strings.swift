//
//  Strings.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation


struct Strings {
    //Action Prompts and titles
    static let DETAIL_EDIT_ACTION = "Edit"
    
    static let EDIT_PIC_CAMERA_OPTION = "Camera"
    static let EDIT_PIC_CAMERA_ROLL_OPTION = "Camera Roll"
    static let EDIT_PIC_CANCEL_OPTION = "Cancel"
    static let FAILURE_ALERT_TITLE = "Oops!"
    static let INFO_ALERT_TITLE = "FYI"
    static let EDIT_CHOOSE_PIC_TITLE = "Choose an option"
    static let SUCCESS_ALERT_TITLE = "Voila!"
    
    
    
    //Errors
    
    //1. Network Errors
    static let RESOURCE_NOT_FOUND = "The requested resource was not found"
    static let VALIDATION_FALIED = "We couldn't validate your request"
    static let INTERNAL_ERROR = "An internal server error was encountered"
    static let NULL_DATA = "We could find the requested data"
    static let URL_CONSTRUCTION_FAILURE = "Failed to construct the url using supplied configuration"
    static let UNABLE_TO_TYPECASE_URL_RESPONSE = #"Failed to typecast variable of type "URLResponse" to "HTTPURLResponse"#
    static func UNKNOWN_STATUS_CODE(_ code: Int) -> String {
        return "Unknown status code: \(code)"
    }
    
    //2. Edit Presenter Errors
    static let INVALID_FIRSTNAME = "First name is invalid"
    static let INVALID_LASTNAME = "Last name is invalid"
    static let INVALID_PHONE = "Phone number is invalid"
    static let INVALID_EMAIL = "Email address is invalid"
    
    //3. System Errors
    static let FAILED_URL_CONSTRUCTION = "We couldn't open the requsted application"
    
    //4. Home Errors
    static let INVALID_CONTACT_INDICES = "Unable to locate the requested contact information"
    static func FAILED_CELL_DESTRUCTURE(_ cellClass: String) -> String {
        return "Couldn't find a cell of type \(cellClass)"
    }
    
    //General messages
    static let CONTACT_UPDATED = "Contact has been updated"
    static let CONTACT_CREATED = "Contact has been created"

}

