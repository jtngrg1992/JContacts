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
        let testContactID = 6415
        let router = Router.getContactDetail(testContactID)
        let detailExpectation = expectation(description: "Contact Details")
        var details: ContactDetail?
        
        NetworkService<ContactDetail>.request(router: router) { result in
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
    

}
