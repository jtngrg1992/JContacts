//
//  EditPresenterDelegate.swift
//  JContacts
//
//  Created by Jatin Garg on 30/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

protocol EditPresenterDelegate: ViewPresenterDelegate {
    var pickedImageData: Data? { get set }
    var editedFirstName: String? { get set }
    var editedLastName: String?{ get set }
    var editedEmail: String? { get set }
    var editedPhoneNumber: String? { get set }
    func displayContact()
    func displayPictureOptions()
    func dismissSelf()
    func toggleSaveButton(_ shouldEnable: Bool)
}
