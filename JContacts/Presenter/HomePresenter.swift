//
//  HomePresenter.swift
//  JContacts
//
//  Created by Jatin Garg on 29/06/19.
//  Copyright © 2019 Jatin Garg. All rights reserved.
//

import Foundation

class HomePresenter {
    private weak var delegate: HomePresenterDelegate?
    private var contactsList: [Contact] = [] {
        didSet{
            viewModel = HomeViewModel(contacts: contactsList)
        }
    }
    
    private var viewModel: HomeViewModel?
    
    public var selectedContact: Contact?
    
    init( delegate: HomePresenterDelegate) {
        self.delegate = delegate
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(contactUpdated),
                                               name: .didUpdateContact,
                                               object: nil)
    }
    
    @objc func contactUpdated(_ notification: Notification) {
        guard
            let newContact = notification.object as? Contact,
            let _ = viewModel,
            let indexTupple = viewModel!.find(newContact)
            else {
                return
        }
        
        viewModel?.sections[indexTupple.section].sectionChildren[indexTupple.row] = newContact
        
        //find out the index path or updated contact and instruct delegate to reload it
        delegate?.reloadRow(atIndexPath: IndexPath(row: indexTupple.row,
                                                   section: indexTupple.section))
    }
    
    public func fetchContacts() {
        delegate?.togglePageLoader(atPosition: .page, true)
        NetworkService<[Contact]>.request(router: Router.getContacts) { [weak self] (result) in
            guard let `self` = self else {
                return
            }
            
            DispatchQueue.main.async {
                self.delegate?.togglePageLoader(atPosition: .page, false)
                switch result {
                case .success (let contactList):
                    //sort the contact list according to first names
                    self.contactsList = contactList.sorted { $0.firstName.localizedCaseInsensitiveCompare($1.firstName) == ComparisonResult.orderedAscending}
                    self.delegate?.displayContacts()
                case .failure(let error):
                    self.delegate?.displayError(error)
                }
            }
            
        }
    }
    
    
    public var sectionCount: Int {
        return viewModel?.sections.count ?? 0
    }
    
    public func rowCount(inSection sectionIndex: Int) -> Int {
        guard let `viewModel` = self.viewModel else {
            return 0
        }
        
        if viewModel.sections.indices.contains(sectionIndex) {
            return viewModel.sections[sectionIndex].sectionChildren.count
        }else{
            return 0
        }
    }
    
    public func contact(inSection sectionIndex: Int, andRow rowIndex: Int) -> Contact {
        guard
            let `viewModel` = viewModel,
            viewModel.sections.indices.contains(sectionIndex),
            viewModel.sections[sectionIndex].sectionChildren.indices.contains(rowIndex)
        else {
            fatalError(Strings.INVALID_CONTACT_INDICES)
        }
        return viewModel.sections[sectionIndex].sectionChildren[rowIndex]
    }
    
    public func title(forSectionAtIndex index: Int) -> String {
        guard
            let `viewModel` = viewModel,
            viewModel.sections.indices.contains(index)
        else{
            fatalError(Strings.INVALID_CONTACT_INDICES)
        }
        return viewModel.sections[index].sectionTitle
    }
    
    public func processRowSelection(atIndexPath indexPath: IndexPath) {
        /*
            finds out the contact item that was clicked and notifies
            delete to take appropriate action
         */
        
        guard
            let `viewModel` = viewModel,
            viewModel.sections.indices.contains(indexPath.section),
            viewModel.sections[indexPath.section].sectionChildren.indices.contains(indexPath.row)
            else{
                fatalError(Strings.INVALID_CONTACT_INDICES)
        }
        
        selectedContact = viewModel.sections[indexPath.section].sectionChildren[indexPath.row]
        delegate?.displayDetails(forContact: selectedContact!)
        
    }
    
    public func processAlphabetTap(_ alphabet: String) {
        /*
            1. find out the index of the section that starts with this alphabet.
            2. Instruct delegate to scroll to the first row of that section.
         */
        
        guard
            let `viewModel` = viewModel,
            let sectionIndex = viewModel.index(ofSectionStartingWith: alphabet)
        else {
            return
        }
        
        
        let indexPath = IndexPath(row: 0, section: sectionIndex)
        delegate?.scroll(toRowAtIndexPath: indexPath)
    }
    
}
