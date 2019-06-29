//
//  EditContactPresenter.swift
//  JContacts
//
//  Created by Jatin Garg on 30/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

enum EditContactPresenterError: Error {
    case invalidFirstName, invalidLastName, invalidEmail, invalidPhone
}

class EditContactPresenter {
    private weak var delegate: EditPresenterDelegate?
    private(set) var contact: Contact?
    private(set) var editedContact: Contact?
    private var imageData: Data?
    
    
    init(contact: Contact?, delegate: EditPresenterDelegate) {
        self.contact = contact
        self.delegate = delegate
    }
    
    public func getContact() {
        delegate?.displayContact()
    }
    
    public func processCameraTap() {
        delegate?.displayPictureOptions()
    }
    
    public func setImage(data: Data) {
        imageData = data
    }
    
    public func setNewContactInformation(_ newContact: Contact) {
        editedContact = newContact
    }
    
    
    
    
}
