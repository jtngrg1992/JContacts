//
//  DetailPresenterDelegate.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

protocol DetailPresenterDelegate: ViewPresenterDelegate {
    func displayContactDetails(_ details: Contact)
}
