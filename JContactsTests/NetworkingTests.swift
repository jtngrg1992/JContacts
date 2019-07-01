//
//  NetworkingTests.swift
//  JContactsTests
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import XCTest
@testable import JContacts

class NetworkingTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testContactsListing() {
        let router = Router.getContacts
        let contactsExpectation = expectation(description: "Contacts listed")
        var contactsList: [Contact]?
        
        NetworkService<[Contact]>.request(router: router) { (result) in
            switch result {
            case .success(let list):
                contactsList = list
                contactsExpectation.fulfill()
            default: break
                
            }
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(contactsList)
        }
    }

    func testContactDetailFetching() {
        let testContactID = 5705
        let router = Router.getContactDetail(testContactID)
        let detailExpectation = expectation(description: "Contact Details")
        var details: Contact?
        
        NetworkService<Contact>.request(router: router) { result in
            switch result {
            case .success(let detail):
                details = detail
                detailExpectation.fulfill()
            default: break
                
            }
        }
        waitForExpectations(timeout: 10) { (error) in
            XCTAssertNotNil(details)
        }
    }
    
    func testImageUpload() {
        let imageData = Images.avatarPlaceholder.equivalentImage!.jpegData(compressionQuality: 0.5)
        let imagUploader = ImageUploader(data: imageData!)
        var url: String?
        let uploadExpectation = expectation(description: "Image Uploaded")
        
        imagUploader.beginUpload { (result) in
            switch result {
            case .success( let u ):
                url = u
            default: break
            }
            uploadExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) { _ in
            XCTAssertNotNil(url)
        }
        
    }
    
    func testContactCreation() {
        let sampleContact = Contact(id: 0,
                                    firstName: "Jatin",
                                    lastName: "Garg",
                                    avatar: "",
                                    isFavorite: false,
                                    email: "jg@spark6.com",
                                    phoneNumber: "+919999464303")
        let router = Router.createContact(sampleContact)
        var error: Error?
        let creationExpection = expectation(description: "Contact Created")
        
        NetworkService<Contact>.request(router: router) { (result) in
            switch(result) {
            case .success(_):
                break
            case .failure(let e):
                error = e
            }
            creationExpection.fulfill()
        }
        waitForExpectations(timeout: 10) { _ in
            XCTAssertNil(error)
        }
    }
    

}
