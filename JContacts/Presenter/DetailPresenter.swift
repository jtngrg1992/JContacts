//
//  DetailPresenter.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

enum DetailPresenterError: Error {
    case invalidPhoneNumber
}

class DetailPresenter {
    private(set) var contact: Contact
    private weak var delegate: DetailPresenterDelegate?
    
    init(contact: Contact, delegate: DetailPresenterDelegate) {
        self.contact = contact
        self.delegate = delegate
    }
    
    public func fetchContactDetails() {
        //show basic details
        //delegate?.displayContactDetails(contact)
        //hit server to get more details
        delegate?.togglePageLoader(atPosition: .bottom, true)
        NetworkService<ContactDetail>.request(router: Router.getContactDetail(contact.id)) { [weak self] (result) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.delegate?.togglePageLoader(atPosition: .bottom, false)
                switch (result) {
                case .success(let detail):
                    self.contact.details = detail
                    self.delegate?.displayContactDetails(self.contact)
                case .failure(let error):
                    self.delegate?.displayError(error)
                }
            }
        }
    }
    
    public func initiateTextMessage() {
        do {
            try System.sayHello(to: contact)
        }catch(let error) {
            delegate?.displayError(error)
        }
    }
    
    public func initiateCall() {
        do {
            try System.placeACall(with: contact)
        }catch(let error) {
            delegate?.displayError(error)
        }
    }
    
    public func sendEmail() {
        do {
            try System.sendEmail(to: contact)
        }catch (let error) {
            delegate?.displayError(error)
        }
    }
}
