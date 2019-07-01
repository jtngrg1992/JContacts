//
//  DetailPresenter.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

class DetailPresenter {
    private(set) var contact: Contact
    private weak var delegate: DetailPresenterDelegate?
    
    init(contact: Contact, delegate: DetailPresenterDelegate) {
        self.contact = contact
        self.delegate = delegate
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didRecieveContactUpdate),
                                               name: .didUpdateContact, object: nil)
    }
    
    @objc func didRecieveContactUpdate(_ notification: Notification) {
        guard let newContact = notification.object as? Contact else {
            return
        }
        
        contact = newContact
        delegate?.displayContactDetails(contact)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: .didUpdateContact,
                                                  object: nil)
    }
    
    public func fetchContactDetails() {
        //show basic details
        //hit server to get more details
        delegate?.togglePageLoader(atPosition: .bottom, true)
        NetworkService<Contact>.request(router: Router.getContactDetail(contact.id)) { [weak self] (result) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.delegate?.togglePageLoader(atPosition: .bottom, false)
                switch (result) {
                case .success(let detail):
                    self.contact = detail
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
    
    public func toggleFavoriteStatus() {
        contact.isFavorite = !contact.isFavorite
        let router = Router.updateContact(contact)
        delegate?.togglePageLoader(atPosition: .top, true)
        NetworkService<Contact>.request(router: router) { [weak self] (result) in
            DispatchQueue.main.async {
                guard let `self` = self else {
                    return
                }
                
                self.delegate?.togglePageLoader(atPosition: .top, false)
                switch result {
                case .success(_ ) :
                    self.delegate?.displayContactDetails(self.contact)
                    NotificationCenter.default.post(name: .didUpdateContact, object: self.contact)
                case .failure(let error):
                    self.delegate?.displayError(error)
                }
            }
        }
    }
}
