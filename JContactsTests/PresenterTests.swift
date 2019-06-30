//
//  PresenterTests.swift
//  JContactsTests
//
//  Created by Jatin Garg on 30/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import XCTest
@testable import JContacts


class PresenterTests: XCTestCase {
    private var editPresenter: EditContactPresenter!
    private let validContact = Contact(id: 0,
                                       firstName: "Jatin",
                                       lastName: "Garg",
                                       avatar: "",
                                       isFavorite: false,
                                       email: "jg@spark6.com",
                                       phoneNumber: "+919999464303")
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPassableValidation() throws {
        let passableDelegate = EditContactViewController()
        passableDelegate.editedFirstName = "Jatin"
        passableDelegate.editedLastName = "Garg"
        passableDelegate.editedPhoneNumber = "+919999464303"
        passableDelegate.editedEmail = "jg@spark6.com"
        
        editPresenter = EditContactPresenter(contact: validContact, delegate: passableDelegate)
        XCTAssertNoThrow(try editPresenter.validateFormInputs())
    }
    
    func testFailingValidationForEmail() {
        let failableDelegate = EditContactViewController()
        failableDelegate.editedFirstName = "Jatin"
        failableDelegate.editedLastName = "Garg"
        failableDelegate.editedPhoneNumber = "+919999464303"
        failableDelegate.editedEmail = ""
        
        editPresenter = EditContactPresenter(contact: validContact, delegate: failableDelegate)
        XCTAssertThrowsError(try editPresenter.validateFormInputs())
    }
    
    func testFailingValidationForFirstName() {
        let failableDelegate = EditContactViewController()
        failableDelegate.editedFirstName = ""
        failableDelegate.editedLastName = "Garg"
        failableDelegate.editedPhoneNumber = "+919999464303"
        failableDelegate.editedEmail = ""
        
        editPresenter = EditContactPresenter(contact: validContact, delegate: failableDelegate)
        XCTAssertThrowsError(try editPresenter.validateFormInputs())
    }
    
    func testFailingValidationForLastName() {
        let failableDelegate = EditContactViewController()
        failableDelegate.editedFirstName = "Jatin"
        failableDelegate.editedLastName = ""
        failableDelegate.editedPhoneNumber = "+919999464303"
        failableDelegate.editedEmail = ""
        
        editPresenter = EditContactPresenter(contact: validContact, delegate: failableDelegate)
        XCTAssertThrowsError(try editPresenter.validateFormInputs())
    }
    
    func testFailingValidationForPhone() {
        let failableDelegate = EditContactViewController()
        failableDelegate.editedFirstName = "Jatin"
        failableDelegate.editedLastName = "Garg"
        failableDelegate.editedPhoneNumber = "+999464303"
        failableDelegate.editedEmail = ""
        
        editPresenter = EditContactPresenter(contact: validContact, delegate: failableDelegate)
        XCTAssertThrowsError(try editPresenter.validateFormInputs())
    }
    
    func testInputDifferentialCheckCaseOne() {
        let failableDelegate = EditContactViewController()
        failableDelegate.editedFirstName = "Jatin"
        failableDelegate.editedLastName = "Garg"
        failableDelegate.editedPhoneNumber = "+999464303"
        failableDelegate.editedEmail = ""
        
        editPresenter = EditContactPresenter(contact: validContact, delegate: failableDelegate)
        XCTAssertTrue(editPresenter.areNewInputsDifferent)
    }
    
    func testInputDifferentialCheckCaseTwo() {
        let failableDelegate = EditContactViewController()
        failableDelegate.editedFirstName = "Jatin"
        failableDelegate.editedLastName = "Garg"
        failableDelegate.editedPhoneNumber = "+919999464303"
        failableDelegate.editedEmail = "jg@spark6.com"
        
        editPresenter = EditContactPresenter(contact: validContact, delegate: failableDelegate)
        let val = editPresenter.areNewInputsDifferent
        XCTAssertFalse(val)
    }
    
}
