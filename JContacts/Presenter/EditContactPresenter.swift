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
    
    init(contact: Contact?, delegate: EditPresenterDelegate) {
        self.contact = contact
        self.delegate = delegate
    }
    
    private func validateFormInputs() throws {
        guard
            let editedFirstName = delegate?.editedFirstName,
            editedFirstName.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
            else{
               throw EditContactPresenterError.invalidFirstName
        }
        
        guard
            let editedLastName = delegate?.editedLastName,
            editedLastName.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
            else{
                throw EditContactPresenterError.invalidLastName
        }
        
        guard
            let editedEmail = delegate?.editedEmail,
            System.isValidEmail(editedEmail)
            else{
                throw EditContactPresenterError.invalidEmail
                
        }
        
        guard
            let editedPhone = delegate?.editedPhoneNumber,
            editedPhone.trimmingCharacters(in: .whitespacesAndNewlines).count >= 10
            else{
                throw EditContactPresenterError.invalidPhone
        }
    }
    
    private var areNewInputsDifferent: Bool {
        //Caution : Unsafe variable, use only if validateFormInputs is guaranteed not to throw anything
        if contact == nil {
            return true
        }
        return (
            delegate!.editedFirstName! != contact!.firstName ||
            delegate!.editedLastName! != contact!.lastName ||
            contact?.details == nil ||
            delegate!.editedEmail != contact!.details!.email ||
            delegate!.editedPhoneNumber != contact!.details!.phoneNumber
        )
        
    }
    
    public func getContact() {
        delegate?.displayContact()
    }
    
    public func processCameraTap() {
        delegate?.displayPictureOptions()
    }
    
    public func saveContactInformation() {
        //check for validity of all inputs
        do {
            try validateFormInputs()
        }catch (let error) {
            delegate?.displayError(error)
        }
        
        
        //Reaching here indicates that all the inputs are valid.
        //Check whether any inputs are different from previous values
        
        if areNewInputsDifferent || delegate!.pickedImageData != nil {
            //we have something to save to the server
            let updater = ContactUpdater(imageData: delegate?.pickedImageData,
                                         firstName: delegate!.editedFirstName!,
                                         lastName: delegate!.editedLastName!,
                                         email: delegate!.editedEmail!,
                                         phoneNumber: delegate!.editedPhoneNumber!,
                                         isFavorite: contact?.isFavorite ?? false)
            updater.existingContactID = contact?.id
            
            delegate?.togglePageLoader(atPosition: .page, true)
            
            updater.updateContact { [weak self] (result) in
                guard let `self` = self else { return }
                switch result {
                case .success(_ ):
                    self.delegate?.displaySuccess("Contact was Updated")
                case .failure(let error):
                    self.delegate?.displayError(error)
                }
            }
            
        }
    }
    
    
    
    
}
