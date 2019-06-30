//
//  HomePresenter.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

protocol HomePresenterDelegate: ViewPresenterDelegate {
    func displayContacts()
    func displayDetails(forContact contact: Contact)
    func reloadRow(atIndexPath indexPath: IndexPath)
    func scroll(toRowAtIndexPath indexPath: IndexPath)
}
