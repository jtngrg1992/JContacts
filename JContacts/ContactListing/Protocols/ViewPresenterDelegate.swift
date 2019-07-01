//
//  ViewPresenter.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation


protocol ViewPresenterDelegate: class {
    func togglePageLoader(atPosition position: LoaderPosition, _ shouldShow: Bool)
    func displayError(_ error: Error)
    func displayinfo (_ message: String)
    func displaySuccess( _ message: String)
}
