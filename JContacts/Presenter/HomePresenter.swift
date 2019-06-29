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
    
    init( delegate: HomePresenterDelegate) {
        self.delegate = delegate
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
                    self.delegate?.displayContacts(contactList)
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
    
}
