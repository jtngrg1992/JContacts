//
//  ContactUpdater.swift
//  JContacts
//
//  Created by Jatin Garg on 30/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

class ContactUpdater {
    public var existingContactID: Int?
    private let imageData: Data?
    private let firstName: String
    private let lastName: String
    private let email: String
    private let phoneNumber: String
    private let isFavorite: Bool
    
    private let dg = DispatchGroup()
    
    private var imageUploader: ImageUploader?
    private var imageURL: String?
    private var newContact: Contact {
        return Contact(id: self.existingContactID ?? 0,
                                 firstName: firstName,
                                 lastName: lastName,
                                 avatar: imageURL ?? "",
                                 isFavorite: isFavorite,
                                 email: email,
                                 phoneNumber: phoneNumber)
    }
    
    init(imageData: Data?, firstName: String, lastName: String, email: String, phoneNumber: String, isFavorite: Bool) {
        self.imageData = imageData
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.isFavorite = isFavorite
    }
    
    private func uploadImage(_ completion: @escaping (Result<String,Error>) -> ()) {
        imageUploader = ImageUploader(data: imageData!)
        imageUploader?.beginUpload(completion)
    }
    
    private func uploadContact (contact: Contact, _ completion:  @escaping (Result<Contact, Error>) -> ()) {
        let router = self.existingContactID != nil ? Router.updateContact(contact) : Router.getContacts
        NetworkService<Contact>.request(router: router, completion: { (result) in
            DispatchQueue.main.async {
                switch(result) {
                case .success(let contact):
                    completion(.success(contact))
                case .failure(let error) :
                    completion(.failure(error))
                }
            }
        })
    }
    
    
    
    public func updateContact(_ completion: @escaping (Result<Contact, Error>) -> ()) {
        if imageData != nil {
            //upload the image data first and wait for the url
            uploadImage { (result) in
                switch (result){
                case .success(let url):
                    self.imageURL = url
                    self.uploadContact(contact: self.newContact, completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }else{
            //upload just the contact data, no image has been chosen
            uploadContact(contact: newContact, completion)
        }
    }
    
    
}
