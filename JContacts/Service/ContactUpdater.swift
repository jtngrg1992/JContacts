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
            switch(result) {
            case .success(let contact):
                completion(.success(contact))
            case .failure(let error) :
                completion(.failure(error))
            }
        })
    }
    
    public func updateContact(_ completion: @escaping (Result<Contact, Error>) -> ()) {
        if imageData != nil {
            //upload the image data first and wait for the url
            uploadImage { (result) in
                switch (result){
                case .success(let url):
                    //construct a new contact model from the information and send it accross
                    let newContact = Contact(id: self.existingContactID ?? 0,
                                             firstName: self.firstName,
                                             lastName: self.lastName,
                                             avatar: url,
                                             isFavorite: self.isFavorite,
                                             detailURL: "",
                                             details: ContactDetail(email: self.email,
                                                                    phoneNumber: self.phoneNumber, creationDate: "", modificationDate: ""))
                    self.uploadContact(contact: newContact, completion)
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }else{
            //
        }
    }
    
    
}
