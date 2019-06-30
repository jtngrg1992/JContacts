//
//  EditContactPresenter.swift
//  JContacts
//
//  Created by Jatin Garg on 30/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

class EditContactPresenter {
    private weak var delegate: EditPresenterDelegate?
    private(set) var contact: Contact?
    
    init(contact: Contact?, delegate: EditPresenterDelegate?) {
        self.contact = contact
        self.delegate = delegate
    }
    
    private func dispatchRelevantNotification(usingPayload payload: Contact) {
        var notification: Notification.Name!
        
        if(contact == nil) {
            //we are in creation mode
            notification = .didCreateContact
        }else {
            //we are in editing mode
            notification = .didUpdateContact
        }
        
        NotificationCenter.default.post(name: notification, object: payload)
    }
    
    public func validateFormInputs() throws {
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
    
    public var areNewInputsDifferent: Bool {
        //Caution : Unsafe variable, use only if validateFormInputs is guaranteed not to throw anything
        if contact == nil {
            return true
        }
        return (
            delegate!.editedFirstName! != contact!.firstName ||
            delegate!.editedLastName! != contact!.lastName ||
            delegate!.editedEmail != contact!.email! ||
            delegate!.editedPhoneNumber != contact!.phoneNumber!
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
            return
        }
        
        
        //Reaching here indicates that all the inputs are valid.
        //Check whether any inputs are different from previous values
        
        if areNewInputsDifferent || delegate!.pickedImageData != nil {
            //we have something to save to the server
            delegate?.toggleSaveButton(false)
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
                self.delegate?.togglePageLoader(atPosition: .page, false)
                self.delegate?.toggleSaveButton(true)
                switch result {
                case .success(let newContact ):
                    self.delegate?.displaySuccess("Contact was Updated")
                    
                    //dispatch notification to trigger updates in previous views
                    self.dispatchRelevantNotification(usingPayload: newContact)
                    
                case .failure(let error):
                    self.delegate?.displayError(error)
                }
            }
            
        }else{
            //no changes worth saving have been made, notify delegate to dismiss
            delegate?.dismissSelf()
        }
    }
    
}
